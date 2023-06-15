@import Quick;
@import Nimble;
@import OCMock;

#import <SmartDeviceLink/SmartDeviceLink.h>
#import "SDLChoiceSetManager.h"

#import "SDLCheckChoiceVROptionalOperation.h"
#import "SDLDeleteChoicesOperation.h"
#import "SDLError.h"
#import "SDLGlobals.h"
#import "SDLPreloadPresentChoicesOperation.h"
#import "SDLPresentKeyboardOperation.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLStateMachine.h"
#import "SDLVersion.h"
#import "SDLWindowCapability.h"

#import "TestConnectionManager.h"

@interface SDLChoiceCell()

@property (assign, nonatomic) UInt16 choiceId;

@end

@interface SDLPreloadPresentChoicesOperation()

@property (strong, nonatomic) NSMutableSet<SDLChoiceCell *> *cellsToUpload;
@property (copy, nonatomic, nullable) NSError *internalError;
@property (copy, nonatomic) SDLUploadChoicesCompletionHandler preloadCompletionHandler;

@property (assign, nonatomic) UInt16 cancelId;
@property (strong, nonatomic, readwrite, nullable) SDLChoiceCell *selectedCell;
@property (strong, nonatomic, readwrite, nullable) SDLTriggerSource selectedTriggerSource;
@property (assign, nonatomic, readwrite) NSUInteger selectedCellRow;

@end

@interface SDLDeleteChoicesOperation()

@property (copy, nonatomic) SDLDeleteChoicesCompletionHandler deleteCompletionHandler;

@end

@interface SDLCheckChoiceVROptionalOperation()

@property (assign, nonatomic, getter=isVROptional) BOOL vrOptional;
@property (copy, nonatomic, nullable) NSError *internalError;
@property (copy, nonatomic) SDLCheckChoiceVROptionalCompletionHandler vrOptionalCompletionHandler;

@end

@interface SDLChoiceSetManager()

@property (strong, nonatomic, readonly) SDLStateMachine *stateMachine;
@property (strong, nonatomic) NSOperationQueue *transactionQueue;
@property (copy, nonatomic) dispatch_queue_t readWriteQueue;
@property (assign, nonatomic) UInt16 nextCancelId;

@property (copy, nonatomic, nullable) SDLHMILevel currentHMILevel;
@property (copy, nonatomic, nullable) SDLSystemContext currentSystemContext;
@property (copy, nonatomic, nullable) SDLWindowCapability *currentWindowCapability;

@property (copy, nonatomic, readwrite) NSSet<SDLChoiceCell *> *preloadedChoices;

@property (assign, nonatomic, getter=isVROptional) BOOL vrOptional;

- (void)sdl_hmiStatusNotification:(SDLRPCNotificationNotification *)notification;
- (void)sdl_displayCapabilityDidUpdate;
- (void)sdl_addUniqueNamesToCells:(NSMutableSet<SDLChoiceCell *> *)choices;

@end

QuickSpecBegin(SDLChoiceSetManagerSpec)

describe(@"choice set manager tests", ^{
    __block SDLChoiceSetManager *testManager = nil;

    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLFileManager *testFileManager = nil;
    __block SDLSystemCapabilityManager *testSystemCapabilityManager = nil;

    __block SDLWindowCapability *enabledWindowCapability = nil;
    __block SDLWindowCapability *disabledWindowCapability = nil;

    __block SDLChoiceSet *testChoiceSet = nil;
    __block SDLChoiceSet *testFailedChoiceSet = nil;
    __block NSString *testTitle = @"test title";
    __block id<SDLChoiceSetDelegate> choiceDelegate = nil;
    __block id<SDLKeyboardDelegate> keyboardDelegate = nil;
    __block SDLInteractionMode testMode = SDLInteractionModeBoth;

    __block SDLChoiceCell *testCell1 = nil;
    __block SDLChoiceCell *testCell2 = nil;
    __block SDLChoiceCell *testCell3 = nil;
    __block SDLChoiceCell *testCell4 = nil;
    __block SDLChoiceCell *testCell1Duplicate = nil;
    __block SDLChoiceCell *testCell1Similar = nil;
    __block SDLArtwork *testArtwork = nil;

    __block SDLTriggerSource resultTriggerSource = SDLTriggerSourceMenu;
    __block SDLChoiceCell *resultChoiceCell = nil;
    __block NSUInteger resultChoiceRow = NSUIntegerMax;
    __block NSError *resultError = nil;

    beforeEach(^{
        testConnectionManager = [[TestConnectionManager alloc] init];
        testFileManager = OCMClassMock([SDLFileManager class]);
        testSystemCapabilityManager = OCMClassMock([SDLSystemCapabilityManager class]);

        testManager = [[SDLChoiceSetManager alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager systemCapabilityManager:testSystemCapabilityManager];

        testArtwork = [[SDLArtwork alloc] initWithStaticIcon:SDLStaticIconNameKey];
        testCell1 = [[SDLChoiceCell alloc] initWithText:@"test1"];
        testCell2 = [[SDLChoiceCell alloc] initWithText:@"test2"];
        testCell3 = [[SDLChoiceCell alloc] initWithText:@"test3"];
        testCell4 = [[SDLChoiceCell alloc] initWithText:@"test4"];
        testCell1Duplicate = [[SDLChoiceCell alloc] initWithText:@"test1"];
        testCell1Similar = [[SDLChoiceCell alloc] initWithText:@"test1" secondaryText:@"secondary" tertiaryText:nil voiceCommands:nil artwork:nil secondaryArtwork:nil];

        enabledWindowCapability = [[SDLWindowCapability alloc] init];
        enabledWindowCapability.textFields = @[
            [[SDLTextField alloc] initWithName:SDLTextFieldNameMenuName characterSet:SDLCharacterSetUtf8 width:500 rows:1],
            [[SDLTextField alloc] initWithName:SDLTextFieldNameSecondaryText characterSet:SDLCharacterSetUtf8 width:500 rows:1],
            [[SDLTextField alloc] initWithName:SDLTextFieldNameTertiaryText characterSet:SDLCharacterSetUtf8 width:500 rows:1]
        ];
        enabledWindowCapability.imageFields = @[
            [[SDLImageField alloc] initWithName:SDLImageFieldNameChoiceImage imageTypeSupported:@[SDLFileTypePNG] imageResolution:nil],
            [[SDLImageField alloc] initWithName:SDLImageFieldNameChoiceSecondaryImage imageTypeSupported:@[SDLFileTypePNG] imageResolution:nil]
        ];
        disabledWindowCapability = [[SDLWindowCapability alloc] init];
        disabledWindowCapability.textFields = @[];

        keyboardDelegate = OCMProtocolMock(@protocol(SDLKeyboardDelegate));
        choiceDelegate = OCMProtocolMock(@protocol(SDLChoiceSetDelegate));
        testChoiceSet = [[SDLChoiceSet alloc] initWithTitle:testTitle delegate:choiceDelegate choices:@[testCell1, testCell2, testCell3]];
        testFailedChoiceSet = [[SDLChoiceSet alloc] initWithTitle:testTitle delegate:choiceDelegate choices:@[testCell1, testCell2, testCell3, testCell4]];

        resultTriggerSource = SDLTriggerSourceMenu;
        resultChoiceCell = nil;
        resultChoiceRow = NSUIntegerMax;
        resultError = nil;
    });

    it(@"should be in the correct startup state", ^{
        expect(testManager.currentState).to(equal(SDLChoiceManagerStateShutdown));

        SDLKeyboardProperties *defaultProperties = [[SDLKeyboardProperties alloc] initWithLanguage:SDLLanguageEnUs keyboardLayout:SDLKeyboardLayoutQWERTY keypressMode:SDLKeypressModeResendCurrentEntry limitedCharacterList:nil autoCompleteList:nil maskInputCharacters:nil customKeys:nil];
        expect(testManager.keyboardConfiguration).to(equal(defaultProperties));
    });

    describe(@"receiving an HMI status update", ^{
        __block SDLOnHMIStatus *newStatus = nil;
        beforeEach(^{
            newStatus = [[SDLOnHMIStatus alloc] init];
        });

        context(@"when starting with the queue suspended", ^{
            beforeEach(^{
                testManager.transactionQueue.suspended = YES;
                testManager.currentHMILevel = SDLHMILevelFull;
                testManager.currentWindowCapability = enabledWindowCapability;
            });

            it(@"should enable the queue when entering HMI FULL", ^{
                testManager.currentHMILevel = SDLHMILevelNone;

                SDLOnHMIStatus *newHMIStatus = [[SDLOnHMIStatus alloc] initWithHMILevel:SDLHMILevelFull systemContext:SDLSystemContextMain audioStreamingState:SDLAudioStreamingStateNotAudible videoStreamingState:nil windowID:@0];
                SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:nil rpcNotification:newHMIStatus];
                [testManager sdl_hmiStatusNotification:notification];

                expect(testManager.transactionQueue.isSuspended).to(beFalse());
            });

            it(@"should enable the queue when receiving a good window capability", ^{
                testManager.currentWindowCapability = disabledWindowCapability;
                OCMStub([testSystemCapabilityManager defaultMainWindowCapability]).andReturn(enabledWindowCapability);
                [testManager sdl_displayCapabilityDidUpdate];

                expect(testManager.transactionQueue.isSuspended).to(beFalse());
            });
        });

        context(@"when starting with the queue enabled", ^{
            beforeEach(^{
                testManager.transactionQueue.suspended = NO;
                testManager.currentHMILevel = SDLHMILevelFull;
                testManager.currentWindowCapability = enabledWindowCapability;
            });

            it(@"should suspend the queue when entering HMI NONE", ^{
                SDLOnHMIStatus *newHMIStatus = [[SDLOnHMIStatus alloc] initWithHMILevel:SDLHMILevelNone systemContext:SDLSystemContextMain audioStreamingState:SDLAudioStreamingStateNotAudible videoStreamingState:nil windowID:@0];
                SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:nil rpcNotification:newHMIStatus];
                [testManager sdl_hmiStatusNotification:notification];

                expect(testManager.transactionQueue.isSuspended).to(beTrue());
            });

            it(@"should suspend the queue when receiving a bad display capability", ^{
                OCMStub([testSystemCapabilityManager defaultMainWindowCapability]).andReturn(disabledWindowCapability);
                [testManager sdl_displayCapabilityDidUpdate];

                expect(testManager.transactionQueue.isSuspended).to(beTrue());
            });

            it(@"should not suspend the queue when receiving an empty display capability", ^{
                OCMStub([testSystemCapabilityManager defaultMainWindowCapability]).andReturn(disabledWindowCapability);
                [testManager sdl_displayCapabilityDidUpdate];

                expect(testManager.transactionQueue.isSuspended).to(beTrue());
            });
        });
    });

    describe(@"once started", ^{
        beforeEach(^{
            [testManager start];
        });

        it(@"should start checking for VR Optional", ^{
            expect(testManager.currentState).to(equal(SDLChoiceManagerStateCheckingVoiceOptional));

            expect(testManager.transactionQueue.operationCount).to(equal(1)); expect(testManager.transactionQueue.operations.lastObject).to(beAnInstanceOf([SDLCheckChoiceVROptionalOperation class]));
        });

        describe(@"after the bad vr optional response", ^{
            beforeEach(^{
                SDLCheckChoiceVROptionalOperation *vrOptionalOp = testManager.transactionQueue.operations.lastObject;
                vrOptionalOp.vrOptionalCompletionHandler(NO, [NSError errorWithDomain:@"test" code:0 userInfo:nil]);
            });

            it(@"should be in startup error", ^{
                expect(testManager.currentState).to(equal(SDLChoiceManagerStateStartupError));
            });
        });

        describe(@"after the vr optional response", ^{
            beforeEach(^{
                SDLCheckChoiceVROptionalOperation *vrOptionalOp = testManager.transactionQueue.operations.lastObject;
                vrOptionalOp.vrOptionalCompletionHandler(YES, nil);
            });

            it(@"should be ready", ^{
                expect(testManager.currentState).to(equal(SDLChoiceManagerStateReady));
            });
        });

        describe(@"once shutdown", ^{
            beforeEach(^{
                [testManager stop];
            });

            it(@"should shutdown", ^{
                expect(testManager.currentState).to(equal(SDLChoiceManagerStateShutdown));
                expect(testManager.vrOptional).to(beTrue());
                expect(testManager.currentHMILevel).to(equal(SDLHMILevelNone));
                expect(testManager.preloadedChoices).to(beEmpty());
            });
        });
    });

    describe(@"once ready", ^{
        beforeEach(^{
            [testManager.stateMachine setToState:SDLChoiceManagerStateReady fromOldState:SDLChoiceManagerStateCheckingVoiceOptional callEnterTransition:NO];
        });

        describe(@"preloading choices", ^{
            context(@"when some choices are already uploaded", ^{
                beforeEach(^{
                    testManager.preloadedChoices = [NSSet setWithArray:@[testCell1]];
                    [testManager preloadChoices:@[testCell1, testCell2, testCell3] withCompletionHandler:^(NSError * _Nullable error) {
                    }];
                });

                it(@"should properly start the preload", ^{
                    expect(testManager.transactionQueue.operations[0]).to(beAnInstanceOf([SDLPreloadPresentChoicesOperation class]));

                    SDLPreloadPresentChoicesOperation *testOp = testManager.transactionQueue.operations[0];
                    testOp.preloadCompletionHandler([NSSet setWithArray:@[testCell1, testCell2, testCell3]], nil);

                    expect(testManager.preloadedChoices).to(contain(testCell1));
                    expect(testManager.preloadedChoices).to(contain(testCell2));
                    expect(testManager.preloadedChoices).to(contain(testCell3));
                });
            });

            context(@"when the manager shuts down during preloading", ^{
                beforeEach(^{
                    [testManager preloadChoices:@[testCell1, testCell2, testCell3] withCompletionHandler:^(NSError * _Nullable error) {
                        resultError = error;
                    }];
                });

                it(@"should leave the list of pending and uploaded choice items empty when the operation finishes", ^{
                    expect(testManager.transactionQueue.operations.firstObject).to(beAnInstanceOf([SDLPreloadPresentChoicesOperation class]));

                    [testManager.stateMachine setToState:SDLChoiceManagerStateShutdown fromOldState:nil callEnterTransition:NO];
                    testManager.preloadedChoices = [NSMutableSet set];

                    SDLPreloadPresentChoicesOperation *testOp = testManager.transactionQueue.operations.firstObject;
                    [testOp finishOperation];

                    expect(testManager.preloadedChoices).to(beEmpty());
                });
            });
        });

        describe(@"deleting choices", ^{
            context(@"used in pending preloads", ^{
                beforeEach(^{
                    [testManager preloadChoices:@[testCell1, testCell2, testCell3, testCell4] withCompletionHandler:^(NSError * _Nullable error) {}];

                    [testManager deleteChoices:@[testCell1, testCell2, testCell3]];
                });

                it(@"should preload the choices, then delete them", ^{
                    expect(testManager.transactionQueue.operationCount).to(equal(2));
                    expect(testManager.transactionQueue.operations[0]).to(beAnInstanceOf(SDLPreloadPresentChoicesOperation.class));
                    expect(testManager.transactionQueue.operations[1]).to(beAnInstanceOf(SDLDeleteChoicesOperation.class));
                });
            });

            context(@"when the manager shuts down during deletion", ^{
                beforeEach(^{
                    testManager.preloadedChoices = [NSSet setWithArray:@[testCell1, testCell2, testCell3]];
                    [testManager deleteChoices:@[testCell1, testCell2]];

                    [SDLGlobals runSyncOnSerialSubQueue:testManager.readWriteQueue block:^{
                        [testManager.stateMachine setToState:SDLChoiceManagerStateShutdown fromOldState:SDLChoiceManagerStateReady callEnterTransition:YES];
                    }];
                });

                it(@"should leave the list of pending and uploaded choice items empty when the operation finishes", ^{
                    expect(testManager.transactionQueue.operationCount).to(equal(0));
                    expect(testManager.preloadedChoices).to(beEmpty());
                });
            });
        });

        describe(@"presenting a choice set", ^{
            it(@"should not present choices if the manager shuts down after the choices are uploaded but before presentation", ^{
                OCMExpect([choiceDelegate choiceSet:[OCMArg any] didReceiveError:[OCMArg isNotNil]]);
                [testManager presentChoiceSet:testChoiceSet mode:testMode withKeyboardDelegate:nil];

                SDLPreloadPresentChoicesOperation *preload = (SDLPreloadPresentChoicesOperation *)testManager.transactionQueue.operations[0];
                preload.loadedCells = [NSSet setWithArray:testChoiceSet.choices];

                [SDLGlobals runSyncOnSerialSubQueue:testManager.readWriteQueue block:^{
                    [testManager.stateMachine setToState:SDLChoiceManagerStateShutdown fromOldState:SDLChoiceManagerStateReady callEnterTransition:YES];
                }];
                [preload finishOperation];

                expect(testManager.preloadedChoices).to(beEmpty());
                expect(testManager.transactionQueue.operationCount).to(equal(0));
            });

            describe(@"when the manager shuts down during presentation", ^{
                it(@"should leave the list of pending and uploaded choice items empty when the operation finishes", ^{
                    [testManager presentChoiceSet:testChoiceSet mode:testMode withKeyboardDelegate:keyboardDelegate];

                    SDLPreloadPresentChoicesOperation *preloadChoicesOperation = (SDLPreloadPresentChoicesOperation *)testManager.transactionQueue.operations.firstObject;
                    [testManager.stateMachine setToState:SDLChoiceManagerStateShutdown fromOldState:nil callEnterTransition:NO];
                    [preloadChoicesOperation finishOperation];

                    expect(testManager.preloadedChoices).to(beEmpty());
                });
            });
        });

        describe(@"presenting a keyboard", ^{
            __block NSString *testInitialText = @"Test text";
            __block id<SDLKeyboardDelegate> testKeyboardDelegate = nil;

            beforeEach(^{
                testKeyboardDelegate = OCMProtocolMock(@protocol(SDLKeyboardDelegate));
            });

            it(@"should return a cancelID and should properly start the keyboard presentation with presentKeyboardWithInitialText:keyboardDelegate:", ^{
                NSNumber *cancelID = [testManager presentKeyboardWithInitialText:testInitialText delegate:testKeyboardDelegate];

                expect(cancelID).toNot(beNil());
                expect(testManager.transactionQueue.operations).to(haveCount(1));
                expect( testManager.transactionQueue.operations[0]).to(beAnInstanceOf([SDLPresentKeyboardOperation class]));
            });

            it(@"should return nil and should not start the keyboard presentation if  the keyboard can not be sent to Core", ^{
                [testManager.stateMachine setToState:SDLChoiceManagerStateCheckingVoiceOptional fromOldState:SDLChoiceManagerStateShutdown callEnterTransition:NO];
                NSNumber *cancelID = [testManager presentKeyboardWithInitialText:testInitialText delegate:testKeyboardDelegate];

                expect(cancelID).to(beNil());
                expect(testManager.transactionQueue.operations).to(haveCount(0));
            });
        });

        describe(@"generating a cancel id", ^{
            __block SDLChoiceSet *testChoiceSet = nil;
            __block SDLChoiceSet *testChoiceSet2 = nil;
            __block id<SDLChoiceSetDelegate> testChoiceDelegate = nil;

            beforeEach(^{
                testChoiceDelegate = OCMProtocolMock(@protocol(SDLChoiceSetDelegate));
                testChoiceSet = [[SDLChoiceSet alloc] initWithTitle:@"choice set 1" delegate:testChoiceDelegate choices:@[testCell1]];
                testChoiceSet2 = [[SDLChoiceSet alloc] initWithTitle:@"choice set 2" delegate:testChoiceDelegate choices:@[testCell2]];
                testManager = [[SDLChoiceSetManager alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager systemCapabilityManager:testSystemCapabilityManager];
                [testManager.stateMachine setToState:SDLChoiceManagerStateReady fromOldState:SDLChoiceManagerStateCheckingVoiceOptional callEnterTransition:NO];
            });

            it(@"should set the first cancelID correctly", ^{
                [testManager presentChoiceSet:testChoiceSet mode:SDLInteractionModeBoth withKeyboardDelegate:nil];

                SDLPreloadPresentChoicesOperation *preloadChoicesOperation = (SDLPreloadPresentChoicesOperation *)testManager.transactionQueue.operations[0];
                expect(@(preloadChoicesOperation.cancelId)).to(equal(101));
            });

            it(@"should reset the cancelID correctly once the max has been reached", ^{
                testManager.nextCancelId = 200;

                [testManager presentChoiceSet:testChoiceSet mode:SDLInteractionModeBoth withKeyboardDelegate:nil];

                SDLPreloadPresentChoicesOperation *presentChoicesOperation = testManager.transactionQueue.operations[0];
                expect(@(presentChoicesOperation.cancelId)).to(equal(200));

                [testManager presentChoiceSet:testChoiceSet2 mode:SDLInteractionModeBoth withKeyboardDelegate:nil];

                [NSThread sleepForTimeInterval:0.5];

                SDLPreloadPresentChoicesOperation *presentChoicesOperation2 = (SDLPreloadPresentChoicesOperation *)testManager.transactionQueue.operations[1];
                expect(@(presentChoicesOperation2.cancelId)).to(equal(101));
            });
        });

       describe(@"dismissing the keyboard", ^{
           __block id mockKeyboardOp1 = nil;
           __block id mockKeyboardOp2 = nil;
           __block NSOperationQueue *mockQueue = nil;
           __block UInt16 testCancelId = 387;

            beforeEach(^{
                mockKeyboardOp1 = OCMStrictClassMock([SDLPresentKeyboardOperation class]);
                OCMStub([mockKeyboardOp1 cancelId]).andReturn(88);

                mockKeyboardOp2 = OCMStrictClassMock([SDLPresentKeyboardOperation class]);
                OCMStub([mockKeyboardOp2 cancelId]).andReturn(testCancelId);

                mockQueue = OCMPartialMock([[NSOperationQueue alloc] init]);
                NSArray<SDLAsynchronousOperation *> *keyboardOps = @[mockKeyboardOp1, mockKeyboardOp2];
                OCMStub([mockQueue operations]).andReturn(keyboardOps);

                testManager.transactionQueue = mockQueue;
            });

           it(@"should dismiss the keyboard operation with the matching cancelID if it is executing", ^{
               OCMStub([mockKeyboardOp1 isExecuting]).andReturn(true);
               OCMStub([mockKeyboardOp2 isExecuting]).andReturn(true);

               OCMReject([mockKeyboardOp1 dismissKeyboard]);
               OCMExpect([mockKeyboardOp2 dismissKeyboard]);

               [testManager dismissKeyboardWithCancelID:@(testCancelId)];

               OCMVerifyAllWithDelay(mockKeyboardOp1, 0.5);
               OCMVerifyAllWithDelay(mockKeyboardOp2, 0.5);
           });

           it(@"should dismiss the keyboard operation with the matching cancelID if it is not executing", ^{
               OCMStub([mockKeyboardOp1 isExecuting]).andReturn(false);
               OCMStub([mockKeyboardOp2 isExecuting]).andReturn(false);

               OCMReject([mockKeyboardOp1 dismissKeyboard]);
               OCMExpect([mockKeyboardOp2 dismissKeyboard]);

               [testManager dismissKeyboardWithCancelID:@(testCancelId)];

               OCMVerifyAllWithDelay(mockKeyboardOp1, 0.5);
               OCMVerifyAllWithDelay(mockKeyboardOp2, 0.5);
           });
        });
    });
});

QuickSpecEnd
