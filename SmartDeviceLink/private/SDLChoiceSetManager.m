//
//  SDLChoiceSetManager.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/21/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLChoiceSetManager.h"

#import "SmartDeviceLink.h"

#import "SDLCheckChoiceVROptionalOperation.h"
#import "SDLDeleteChoicesOperation.h"
#import "SDLError.h"
#import "SDLGlobals.h"
#import "SDLPreloadPresentChoicesOperation.h"
#import "SDLPresentKeyboardOperation.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"
#import "SDLStateMachine.h"
#import "SDLVersion.h"
#import "SDLWindowCapability+ScreenManagerExtensions.h"

NS_ASSUME_NONNULL_BEGIN

SDLChoiceManagerState *const SDLChoiceManagerStateShutdown = @"Shutdown";
SDLChoiceManagerState *const SDLChoiceManagerStateCheckingVoiceOptional = @"CheckingVoiceOptional";
SDLChoiceManagerState *const SDLChoiceManagerStateReady = @"Ready";
SDLChoiceManagerState *const SDLChoiceManagerStateStartupError = @"StartupError";

typedef NSNumber * SDLChoiceId;

@interface SDLChoiceCell()

@property (assign, nonatomic) UInt16 choiceId;
@property (strong, nonatomic, readwrite) NSString *uniqueText;
@property (copy, nonatomic, readwrite, nullable) NSString *secondaryText;
@property (copy, nonatomic, readwrite, nullable) NSString *tertiaryText;
@property (copy, nonatomic, readwrite, nullable) NSArray<NSString *> *voiceCommands;
@property (strong, nonatomic, readwrite, nullable) SDLArtwork *artwork;
@property (strong, nonatomic, readwrite, nullable) SDLArtwork *secondaryArtwork;

@end

@interface SDLChoiceSetManager()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;
@property (weak, nonatomic) SDLSystemCapabilityManager *systemCapabilityManager;

@property (strong, nonatomic, readonly) SDLStateMachine *stateMachine;
@property (strong, nonatomic) NSOperationQueue *transactionQueue;
@property (copy, nonatomic) dispatch_queue_t readWriteQueue;

@property (copy, nonatomic, nullable) SDLHMILevel currentHMILevel;
@property (copy, nonatomic, nullable) SDLWindowCapability *currentWindowCapability;

@property (assign, nonatomic) UInt16 nextCancelId;
@property (assign, nonatomic, getter=isVROptional) BOOL vrOptional;
@property (copy, nonatomic, readwrite) NSSet<SDLChoiceCell *> *preloadedChoices;

@end

// Assigns a set range of unique cancel ids in order to prevent overlap with other sub-screen managers that use cancel ids. If the max cancel id is reached, generation starts over from the cancel id min value.
UInt16 const ChoiceCellCancelIdMin = 101;
UInt16 const ChoiceCellCancelIdMax = 200;

@implementation SDLChoiceSetManager

#pragma mark - Lifecycle

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager systemCapabilityManager:(SDLSystemCapabilityManager *)systemCapabilityManager {
    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _fileManager = fileManager;
    _systemCapabilityManager = systemCapabilityManager;
    _stateMachine = [[SDLStateMachine alloc] initWithTarget:self initialState:SDLChoiceManagerStateShutdown states:[self.class sdl_stateTransitionDictionary]];
    _transactionQueue = [self sdl_newTransactionQueue];

    _readWriteQueue = dispatch_queue_create_with_target("com.sdl.screenManager.choiceSetManager.readWriteQueue", DISPATCH_QUEUE_SERIAL, [SDLGlobals sharedGlobals].sdlProcessingQueue);

    _preloadedChoices = [NSSet set];

    _nextCancelId = ChoiceCellCancelIdMin;
    _vrOptional = YES;
    _keyboardConfiguration = [self sdl_defaultKeyboardConfiguration];
    _currentHMILevel = SDLHMILevelNone;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_hmiStatusNotification:) name:SDLDidChangeHMIStatusNotification object:nil];

    return self;
}

- (void)start {
    SDLLogD(@"Starting manager");

    [self.systemCapabilityManager subscribeToCapabilityType:SDLSystemCapabilityTypeDisplays withObserver:self selector:@selector(sdl_displayCapabilityDidUpdate)];

    if ([self.currentState isEqualToString:SDLChoiceManagerStateShutdown]) {
        [self.stateMachine transitionToState:SDLChoiceManagerStateCheckingVoiceOptional];
    }

    // Else, we're already started
}

- (void)stop {
    SDLLogD(@"Stopping manager");
    
    [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
        [self.stateMachine transitionToState:SDLChoiceManagerStateShutdown];
    }];
}

+ (NSDictionary<SDLState *, SDLAllowableStateTransitions *> *)sdl_stateTransitionDictionary {
    return @{
             SDLChoiceManagerStateShutdown: @[SDLChoiceManagerStateCheckingVoiceOptional],
             SDLChoiceManagerStateCheckingVoiceOptional: @[SDLChoiceManagerStateShutdown, SDLChoiceManagerStateReady, SDLChoiceManagerStateStartupError],
             SDLChoiceManagerStateReady: @[SDLChoiceManagerStateShutdown],
             SDLChoiceManagerStateStartupError: @[SDLChoiceManagerStateShutdown]
             };
}

- (NSOperationQueue *)sdl_newTransactionQueue {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.name = @"com.sdl.screenManager.choiceSetManager.transactionQueue";
    queue.maxConcurrentOperationCount = 1;
    queue.qualityOfService = NSQualityOfServiceUserInteractive;
    queue.underlyingQueue = [SDLGlobals sharedGlobals].sdlConcurrentQueue;
    queue.suspended = YES;

    return queue;
}

/// Suspend the transaction queue if we are in HMI NONE
/// OR if the text field name "menu name" (i.e. is the primary choice text) cannot be used, we assume we cannot present a PI.
- (void)sdl_updateTransactionQueueSuspended {
    if ([self.currentHMILevel isEqualToEnum:SDLHMILevelNone]
        || (![self.currentWindowCapability hasTextFieldOfName:SDLTextFieldNameMenuName])) {
        SDLLogD(@"Suspending the transaction queue. Current HMI level is: %@, window capability has MenuName (choice primary text): %@", self.currentHMILevel, ([self.currentWindowCapability hasTextFieldOfName:SDLTextFieldNameMenuName] ? @"YES" : @"NO"));
        self.transactionQueue.suspended = YES;
    } else {
        SDLLogD(@"Starting the transaction queue");
        self.transactionQueue.suspended = NO;
    }
}

#pragma mark - State Management

- (void)didEnterStateShutdown {
    SDLLogV(@"Manager shutting down");

    NSAssert(dispatch_get_specific(SDLProcessingQueueName) != nil, @"%@ must only be called on the SDL serial queue", NSStringFromSelector(_cmd));

    _currentHMILevel = SDLHMILevelNone;

    [self.transactionQueue cancelAllOperations];
    self.transactionQueue = [self sdl_newTransactionQueue];
    _preloadedChoices = [NSMutableSet set];

    _vrOptional = YES;
    _nextCancelId = ChoiceCellCancelIdMin;
}

- (void)didEnterStateCheckingVoiceOptional {
    // Setup by sending a Choice Set without VR, seeing if there's an error. If there is, send one with VR. This choice set will be used for `presentKeyboard` interactions.
    __weak typeof(self) weakself = self;
    SDLCheckChoiceVROptionalOperation *checkOp = [[SDLCheckChoiceVROptionalOperation alloc] initWithConnectionManager:self.connectionManager completionHandler:^(BOOL isVROptional, NSError * _Nullable error) {
        __strong typeof(weakself) strongself = weakself;
        if ([self.currentState isEqualToString:SDLChoiceManagerStateShutdown]) { return; }

        strongself.vrOptional = isVROptional;
        if (error != nil) {
            [strongself.stateMachine transitionToState:SDLChoiceManagerStateStartupError];
        } else {
            [strongself.stateMachine transitionToState:SDLChoiceManagerStateReady];
        }
    }];

    [self.transactionQueue addOperation:checkOp];
}

- (void)didEnterStateStartupError {
    // TODO
}

#pragma mark - Choice Management

#pragma mark Delete

- (void)deleteChoices:(NSArray<SDLChoiceCell *> *)choices {
    SDLLogV(@"Request to delete choices: %@", choices);
    if (![self.currentState isEqualToString:SDLChoiceManagerStateReady]) {
        SDLLogE(@"Attempted to delete choices in an incorrect state: %@, they will not be deleted", self.currentState);
        return;
    }

    __weak typeof(self) weakself = self;
    SDLDeleteChoicesOperation *deleteOp = [[SDLDeleteChoicesOperation alloc] initWithConnectionManager:self.connectionManager cellsToDelete:[NSSet setWithArray:choices] loadedCells:self.preloadedChoices completionHandler:^(NSSet<SDLChoiceCell *> * _Nonnull updatedLoadedCells, NSError *_Nullable error) {
        __strong typeof(weakself) strongself = weakself;
        if ([strongself.currentState isEqualToEnum:SDLChoiceManagerStateShutdown]) {
            SDLLogD(@"Cancelling deleting choices because the manager is shut down");
            return;
        }

        SDLLogD(@"Finished deleting choices");

        strongself.preloadedChoices = updatedLoadedCells;
        [strongself sdl_updatePendingTasksWithCurrentPreloads];

        if (error != nil) {
            SDLLogE(@"Failed to delete choices with error: %@", error);
        }
    }];

    [self.transactionQueue addOperation:deleteOp];
}

#pragma mark Upload / Present

- (void)preloadChoices:(NSArray<SDLChoiceCell *> *)choices withCompletionHandler:(nullable SDLPreloadChoiceCompletionHandler)handler {
    SDLLogV(@"Request to preload choices: %@", choices);
    if (choices.count == 0) {
        if (handler != nil) {
            handler([NSError sdl_choiceSetManager_choiceUploadFailed:@{
                NSLocalizedDescriptionKey: @"Choice upload failed",
                NSLocalizedFailureReasonErrorKey: @"No choices were provided for upload",
                NSLocalizedRecoverySuggestionErrorKey: @"Provide some choice cells to upload instead of an empty list"
            }]);
        }
        return;
    }
    if (![self.currentState isEqualToString:SDLChoiceManagerStateReady]) {
        NSError *error = [NSError sdl_choiceSetManager_incorrectState:self.currentState];
        SDLLogE(@"Cannot preload choices when the manager isn't in the ready state: %@", error);
        if (handler != nil) { handler(error); }
        return;
    }

    // Upload pending preloads
    // For backward compatibility with Gen38Inch display type head units
    SDLLogD(@"Starting preload choices");
    SDLLogV(@"Choices to be uploaded: %@", choices);
    NSString *displayName = self.systemCapabilityManager.displays.firstObject.displayName;

    __weak typeof(self) weakSelf = self;
    SDLPreloadPresentChoicesOperation *preloadOp = [[SDLPreloadPresentChoicesOperation alloc] initWithConnectionManager:self.connectionManager fileManager:self.fileManager displayName:displayName windowCapability:self.currentWindowCapability isVROptional:self.isVROptional cellsToPreload:choices loadedCells:self.preloadedChoices preloadCompletionHandler:^(NSSet<SDLChoiceCell *> * _Nonnull updatedLoadedCells, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        // Check if the manager has shutdown because the list of uploaded and pending choices should not be updated
        if ([strongSelf.currentState isEqualToString:SDLChoiceManagerStateShutdown]) {
            SDLLogD(@"Cancelling preloading choices because the manager is shut down");

            if (handler != nil) { handler([NSError sdl_choiceSetManager_incorrectState:SDLChoiceManagerStateShutdown]); }
            BLOCK_RETURN;
        }

        // Update the list of `preloadedChoices`
        strongSelf.preloadedChoices = updatedLoadedCells;
        [strongSelf sdl_updatePendingTasksWithCurrentPreloads];

        SDLLogD(@"Choices finished preloading");

        if (handler != nil) { handler(error); }
    }];

    [self.transactionQueue addOperation:preloadOp];
}

- (void)presentChoiceSet:(SDLChoiceSet *)choiceSet mode:(SDLInteractionMode)mode withKeyboardDelegate:(nullable id<SDLKeyboardDelegate>)delegate {
    if (![self.currentState isEqualToString:SDLChoiceManagerStateReady]) {
        SDLLogE(@"Attempted to present choices in an incorrect state: %@, it will not be presented", self.currentState);
        return;
    }

    if (choiceSet == nil) {
        SDLLogW(@"Attempted to present a nil choice set, ignoring.");
        return;
    }

    SDLLogD(@"Preloading and presenting choice set: %@", choiceSet);

    // Add an operation to present it once the preload is complete
    __weak typeof(self) weakSelf = self;
    NSString *displayName = self.systemCapabilityManager.displays.firstObject.displayName;
    SDLPreloadPresentChoicesOperation *presentOp = [[SDLPreloadPresentChoicesOperation alloc] initWithConnectionManager:self.connectionManager fileManager:self.fileManager choiceSet:choiceSet mode:mode keyboardProperties:self.keyboardConfiguration keyboardDelegate:delegate cancelID:self.nextCancelId displayName:displayName windowCapability:self.currentWindowCapability isVROptional:self.isVROptional loadedCells:self.preloadedChoices preloadCompletionHandler:^(NSSet<SDLChoiceCell *> * _Nonnull updatedLoadedCells, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        // Check if the manager has shutdown because the list of uploaded and pending choices should not be updated
        if ([strongSelf.currentState isEqualToString:SDLChoiceManagerStateShutdown]) {
            SDLLogD(@"Cancelling preloading choices because the manager is shut down");
            BLOCK_RETURN;
        }

        // Update the list of `preloadedChoices`
        strongSelf.preloadedChoices = updatedLoadedCells;
        [strongSelf sdl_updatePendingTasksWithCurrentPreloads];

        SDLLogD(@"Choices finished preloading");
    }];

    [self.transactionQueue addOperation:presentOp];
}

- (nullable NSNumber<SDLInt> *)presentKeyboardWithInitialText:(NSString *)initialText delegate:(id<SDLKeyboardDelegate>)delegate {
    if (![self.currentState isEqualToString:SDLChoiceManagerStateReady]) {
        SDLLogE(@"Attempted to present keyboard in an incorrect state: %@, it will not be presented", self.currentState);
        return nil;
    }

    SDLLogD(@"Presenting keyboard with initial text: %@", initialText);
    // Present a keyboard with the choice set that we used to test VR's optional state
    UInt16 keyboardCancelId = self.nextCancelId;
    SDLPresentKeyboardOperation *keyboardOperation = [[SDLPresentKeyboardOperation alloc] initWithConnectionManager:self.connectionManager keyboardProperties:self.keyboardConfiguration initialText:initialText keyboardDelegate:delegate cancelID:keyboardCancelId windowCapability:self.currentWindowCapability];
    [self.transactionQueue addOperation:keyboardOperation];
    return @(keyboardCancelId);
}

- (void)dismissKeyboardWithCancelID:(NSNumber<SDLInt> *)cancelID {
    for (SDLAsynchronousOperation *op in self.transactionQueue.operations) {
        if (![op isKindOfClass:SDLPresentKeyboardOperation.class]) { continue; }

        SDLPresentKeyboardOperation *keyboardOperation = (SDLPresentKeyboardOperation *)op;
        if (keyboardOperation.cancelId != cancelID.unsignedShortValue) { continue; }

        SDLLogD(@"Dismissing keyboard with cancel ID: %@", cancelID);
        [keyboardOperation dismissKeyboard];
        break;
    }
}

#pragma mark - Choice Management Helpers

- (void)sdl_updatePendingTasksWithCurrentPreloads {
    for (NSOperation *op in self.transactionQueue.operations) {
        if (op.isExecuting || op.isCancelled) { continue; }

        if ([op isMemberOfClass:SDLPreloadPresentChoicesOperation.class]) {
            SDLPreloadPresentChoicesOperation *preloadPresentOp = (SDLPreloadPresentChoicesOperation *)op;
            preloadPresentOp.loadedCells = self.preloadedChoices;
        } else if ([op isMemberOfClass:SDLDeleteChoicesOperation.class]) {
            SDLDeleteChoicesOperation *deleteOp = (SDLDeleteChoicesOperation *)op;
            deleteOp.loadedCells = self.preloadedChoices;
        }
    }
}

#pragma mark - Keyboard Configuration

- (void)setKeyboardConfiguration:(nullable SDLKeyboardProperties *)keyboardConfiguration {
    if (keyboardConfiguration == nil) {
        SDLLogD(@"Updating keyboard configuration to the default");
        _keyboardConfiguration = [self sdl_defaultKeyboardConfiguration];
    } else {
        SDLLogD(@"Updating keyboard configuration to a new configuration: %@", keyboardConfiguration);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        _keyboardConfiguration = [[SDLKeyboardProperties alloc] initWithLanguage:keyboardConfiguration.language layout:keyboardConfiguration.keyboardLayout keypressMode:SDLKeypressModeResendCurrentEntry limitedCharacterList:keyboardConfiguration.limitedCharacterList autoCompleteText:keyboardConfiguration.autoCompleteText autoCompleteList:keyboardConfiguration.autoCompleteList];
#pragma clang diagnostic pop

        if (keyboardConfiguration.keypressMode != SDLKeypressModeResendCurrentEntry) {
            SDLLogW(@"Attempted to set a keyboard configuration with an invalid keypress mode; only .resentCurrentEntry is valid. This value will be ignored, the rest of the properties will be set.");
        }
    }
}

- (SDLKeyboardProperties *)sdl_defaultKeyboardConfiguration {
    return [[SDLKeyboardProperties alloc] initWithLanguage:SDLLanguageEnUs keyboardLayout:SDLKeyboardLayoutQWERTY keypressMode:SDLKeypressModeResendCurrentEntry limitedCharacterList:nil autoCompleteList:nil maskInputCharacters:nil customKeys:nil];
}

#pragma mark - Getters

- (UInt16)nextCancelId {
    __block UInt16 cancelId = 0;
    [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
        cancelId = self->_nextCancelId;
        if (cancelId >= ChoiceCellCancelIdMax) {
            self->_nextCancelId = ChoiceCellCancelIdMin;
        } else {
            self->_nextCancelId = cancelId + 1;
        }
    }];

    return cancelId;
}

- (NSString *)currentState {
    return self.stateMachine.currentState;
}

#pragma mark - RPC Responses / Notifications

- (void)sdl_displayCapabilityDidUpdate {
    self.currentWindowCapability = self.systemCapabilityManager.defaultMainWindowCapability;
    [self sdl_updateTransactionQueueSuspended];
}

- (void)sdl_hmiStatusNotification:(SDLRPCNotificationNotification *)notification {
    // We can only present a choice set if we're in FULL
    SDLOnHMIStatus *hmiStatus = (SDLOnHMIStatus *)notification.notification;
    if (hmiStatus.windowID != nil && hmiStatus.windowID.integerValue != SDLPredefinedWindowsDefaultWindow) { return; }

    self.currentHMILevel = hmiStatus.hmiLevel;

    [self sdl_updateTransactionQueueSuspended];
}

@end

NS_ASSUME_NONNULL_END
