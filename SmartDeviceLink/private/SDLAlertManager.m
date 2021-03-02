//
//  SDLAlertManager.m
//  SmartDeviceLink
//
//  Created by Nicole on 11/10/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLAlertManager.h"

#import "SDLAlertView.h"
#import "SDLDisplayCapability.h"
#import "SDLGlobals.h"
#import "SDLLogMacros.h"
#import "SDLNotificationConstants.h"
#import "SDLOnHMIStatus.h"
#import "SDLPermissionManager.h"
#import "SDLPredefinedWindows.h"
#import "SDLPresentAlertOperation.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLSystemCapability.h"
#import "SDLSystemCapabilityManager.h"
#import "SDLWindowCapability.h"

NS_ASSUME_NONNULL_BEGIN

// Assigns a set range of unique cancel ids in order to prevent overlap with other sub-screen managers that use cancel ids. If the max cancel id is reached, generation starts over from the cancel id min value.
UInt16 const AlertCancelIdMin = 1;
UInt16 const AlertCancelIdMax = 100;

@interface SDLAlertManager()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;
@property (weak, nonatomic) SDLSystemCapabilityManager *systemCapabilityManager;
@property (weak, nonatomic) SDLPermissionManager *permissionManager;

@property (copy, nonatomic, nullable) SDLWindowCapability *currentWindowCapability;
@property (strong, nonatomic) NSOperationQueue *transactionQueue;
@property (copy, nonatomic) dispatch_queue_t readWriteQueue;

@property (assign, nonatomic) UInt16 nextCancelId;
@property (assign, nonatomic) BOOL isAlertRPCAllowed;

@end

@implementation SDLAlertManager

#pragma mark - Lifecycle

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager systemCapabilityManager:(SDLSystemCapabilityManager *)systemCapabilityManager permissionManager:(SDLPermissionManager *)permissionManager {
    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _fileManager = fileManager;
    _systemCapabilityManager = systemCapabilityManager;
    _permissionManager = permissionManager;
    _transactionQueue = [self sdl_newTransactionQueue];

    _readWriteQueue = dispatch_queue_create_with_target("com.sdl.screenManager.alertManager.readWriteQueue", DISPATCH_QUEUE_SERIAL, [SDLGlobals sharedGlobals].sdlProcessingQueue);
    _nextCancelId = AlertCancelIdMin;

    _currentWindowCapability = self.systemCapabilityManager.defaultMainWindowCapability;

    return self;
}

- (void)start {
    SDLLogD(@"Starting manager");

    __weak typeof(self) weakself = self;
    [self.permissionManager subscribeToRPCPermissions:@[[[SDLPermissionElement alloc] initWithRPCName:SDLRPCFunctionNameAlert parameterPermissions:nil]] groupType:SDLPermissionGroupTypeAny withHandler:^(NSDictionary<SDLRPCFunctionName,SDLRPCPermissionStatus *> * _Nonnull updatedPermissionStatuses, SDLPermissionGroupStatus status) {
        weakself.isAlertRPCAllowed = (status == SDLPermissionGroupStatusAllowed);

        [weakself sdl_updateTransactionQueueSuspended];
    }];
    [self.systemCapabilityManager subscribeToCapabilityType:SDLSystemCapabilityTypeDisplays withObserver:self selector:@selector(sdl_displayCapabilityDidUpdate)];
}

- (void)stop {
    SDLLogD(@"Stopping manager");

    _currentWindowCapability = nil;
    _nextCancelId = AlertCancelIdMin;

    [_transactionQueue cancelAllOperations];
    self.transactionQueue = [self sdl_newTransactionQueue];

    [self.permissionManager removeAllObservers];
    [self.systemCapabilityManager unsubscribeFromCapabilityType:SDLSystemCapabilityTypeDisplays withObserver:self];
}

- (void)presentAlert:(SDLAlertView *)alert withCompletionHandler:(nullable SDLAlertCompletionHandler)handler {
    SDLPresentAlertOperation *op = [[SDLPresentAlertOperation alloc] initWithConnectionManager:self.connectionManager fileManager:self.fileManager systemCapabilityManager:self.systemCapabilityManager currentWindowCapability:self.currentWindowCapability alertView:alert cancelID:self.nextCancelId];

    __weak typeof(op) weakPreloadOp = op;
    op.completionBlock = ^{
        SDLLogD(@"Alert finished presenting: %@", alert);

        if (handler != nil) {
            handler(weakPreloadOp.error);
        }
    };

    [self.transactionQueue addOperation:op];
}

/// Creates a new serial queue. If an alert is already being presented when a new alert is added to the queue, the newest alert will not be sent until module dismisses the previous alert.
/// The queue is initially suspended until the manager knows it can send the `Alert` RPCS without getting a disallowed response.
/// @return A concurrent operation queue
- (NSOperationQueue *)sdl_newTransactionQueue {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.name = @"com.sdl.screenManager.alertManager.transactionQueue";
    queue.maxConcurrentOperationCount = 1;
    queue.qualityOfService = NSQualityOfServiceUserInteractive;
    queue.underlyingQueue = [SDLGlobals sharedGlobals].sdlConcurrentQueue;
    queue.suspended = YES;

    return queue;
}

/// Suspend the queue if the window capabilities are nil (we assume that text and graphics are not supported yet)
- (void)sdl_updateTransactionQueueSuspended {
    if (self.currentWindowCapability == nil || !self.isAlertRPCAllowed) {
        SDLLogD(@"Suspending the transaction queue. Window capabilities is nil: %@, alert has permission be sent at the current HMI level: %@", (self.currentWindowCapability == nil ? @"YES" : @"NO"), self.isAlertRPCAllowed ? @"YES" : @"NO");
        self.transactionQueue.suspended = YES;
    } else {
        SDLLogD(@"Starting the transaction queue");
        self.transactionQueue.suspended = NO;
    }
}

/// Updates pending operations in the queue with the new window capability (i.e. the window capability will change when the template changes)
- (void)sdl_updatePendingOperationsWithNewWindowCapability {
    for (NSOperation *operation in self.transactionQueue.operations) {
        if (operation.isExecuting) { continue; }

        ((SDLPresentAlertOperation *)operation).currentWindowCapability = self.currentWindowCapability;
    }
}

#pragma mark - Observers

/// Called when the current window capabilities have updated.
- (void)sdl_displayCapabilityDidUpdate {
    self.currentWindowCapability = [self.systemCapabilityManager defaultMainWindowCapability];
    [self sdl_updateTransactionQueueSuspended];
    [self sdl_updatePendingOperationsWithNewWindowCapability];
}

#pragma mark - Getters

/// Generates a `cancelID` for an Alert `CancelInteraction` request. `cancelID`s do not need to be unique for different RPC functions, however, we will set a max value for `cancelID`s so if a developer, for some reason, is using both the alert manager and the `Alert` RPC they can use any value above the max `cancelID` without worrying about conflicts. Once an alert with the associated `cancelID` has been dismissed, the `cancelID` can be reused so it is very unlikely there will be conflicts with an already existing generated `cancelID`.
- (UInt16)nextCancelId {
    __block UInt16 cancelId = 0;
    [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
        cancelId = self->_nextCancelId;
        if (cancelId >= AlertCancelIdMax) {
            self->_nextCancelId = AlertCancelIdMin;
        } else {
            self->_nextCancelId = cancelId + 1;
        }
    }];

    return cancelId;
}

@end

NS_ASSUME_NONNULL_END
