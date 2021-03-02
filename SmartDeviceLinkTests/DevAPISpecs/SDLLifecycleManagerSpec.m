#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLLifecycleManager.h"

#import "SDLAppServiceData.h"
#import "SDLChangeRegistration.h"
#import "SDLConfiguration.h"
#import "SDLConnectionManagerType.h"
#import "SDLEncryptionConfiguration.h"
#import "SDLEncryptionLifecycleManager.h"
#import "SDLError.h"
#import "SDLFileManagerConfiguration.h"
#import "SDLFileManager.h"
#import "SDLGlobals.h"
#import "SDLHMILevel.h"
#import "SDLLifecycleConfiguration.h"
#import "SDLLifecycleProtocolHandler.h"
#import "SDLLockScreenConfiguration.h"
#import "SDLLockScreenManager.h"
#import "SDLLogConfiguration.h"
#import "SDLManagerDelegate.h"
#import "SDLNotificationDispatcher.h"
#import "SDLOnAppInterfaceUnregistered.h"
#import "SDLOnAppServiceData.h"
#import "SDLOnHashChange.h"
#import "SDLOnHMIStatus.h"
#import "SDLPerformAppServiceInteractionResponse.h"
#import "SDLPermissionManager.h"
#import "SDLProtocol.h"
#import "SDLRegisterAppInterface.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLResult.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLSecondaryTransportManager.h"
#import "SDLShow.h"
#import "SDLStateMachine.h"
#import "SDLStreamingMediaConfiguration.h"
#import "SDLStreamingMediaManager.h"
#import "SDLSystemCapabilityManager.h"
#import "SDLTextAlignment.h"
#import "SDLTTSChunk.h"
#import "SDLUnregisterAppInterface.h"
#import "SDLUnregisterAppInterfaceResponse.h"
#import "SDLVehicleType.h"
#import "SDLVersion.h"
#import "SDLVideoStreamingState.h"

@interface SDLStreamingMediaManager ()

@property (strong, nonatomic, nullable) SDLSecondaryTransportManager *secondaryTransportManager;
- (void)startSecondaryTransportWithProtocol:(SDLProtocol *)protocol;

@end

@interface SDLLifecycleManager ()
// this private property is used for testing
@property (copy, nonatomic) dispatch_queue_t lifecycleQueue;
@property (assign, nonatomic) int32_t lastCorrelationId;
@property (strong, nonatomic) SDLLanguage currentVRLanguage;
@property (strong, nonatomic, nullable) SDLSecondaryTransportManager *secondaryTransportManager;
@property (strong, nonatomic) SDLEncryptionLifecycleManager *encryptionLifecycleManager;
@property (strong, nonatomic, nullable) SDLLifecycleProtocolHandler *protocolHandler;
@end

@interface SDLGlobals ()
@property (copy, nonatomic, readwrite) SDLVersion *protocolVersion;
@end

QuickConfigurationBegin(SendingRPCsConfiguration)

+ (void)configure:(Configuration *)configuration {
    sharedExamples(@"unable to send an RPC", ^(QCKDSLSharedExampleContext exampleContext) {
        it(@"cannot publicly send RPCs", ^{
            SDLLifecycleManager *testManager = exampleContext()[@"manager"];
            SDLShow *testShow = [[SDLShow alloc] initWithMainField1:@"test" mainField2:nil mainField3:nil mainField4:nil alignment:nil statusBar:nil mediaTrack:nil graphic:nil secondaryGraphic:nil softButtons:nil customPresets:nil metadataTags:nil templateTitle:nil windowID:nil templateConfiguration:nil];

            [testManager sendRequest:testShow withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
                expect(error).to(equal([NSError sdl_lifecycle_notReadyError]));
            }];
        });
    });
}

QuickConfigurationEnd


QuickSpecBegin(SDLLifecycleManagerSpec)

describe(@"a lifecycle manager", ^{
    __block SDLLifecycleManager *testManager = nil;
    __block SDLConfiguration *testConfig = nil;
    __block SDLProtocol *protocolMock = nil;
    __block id sdlManagerDelegateProtocolMock = nil;
    __block id lockScreenManagerMock = nil;
    __block id fileManagerMock = nil;
    __block id permissionManagerMock = nil;
    __block id streamingManagerMock = nil;
    __block id systemCapabilityMock = nil;
    __block id secondaryTransportManagerMock = nil;
    __block id encryptionManagerMock = nil;
    SDLVehicleType *vehicleType = [[SDLVehicleType alloc] initWithMake:@"Make" model:@"Model" modelYear:@"Model Year" trim:@"Trim"];
    NSString *softwareVersion = @"1.1.1.1";
    NSString *hardwareVersion = @"2.2.2.2";

    void (^transitionToState)(SDLState *) = ^(SDLState *state) {
        dispatch_sync(testManager.lifecycleQueue, ^{
            [testManager.lifecycleStateMachine transitionToState:state];
        });
    };

    void (^setToStateWithEnterTransition)(SDLState *, SDLState *) = ^(SDLState *oldState, SDLState *newState) {
        dispatch_sync(testManager.lifecycleQueue, ^{
            [testManager.lifecycleStateMachine setToState:newState fromOldState:oldState callEnterTransition:YES];
        });
    };

    beforeEach(^{
        protocolMock = OCMClassMock([SDLProtocol class]);
        sdlManagerDelegateProtocolMock = OCMProtocolMock(@protocol(SDLManagerDelegate));
        lockScreenManagerMock = OCMClassMock([SDLLockScreenManager class]);
        fileManagerMock = OCMClassMock([SDLFileManager class]);
        permissionManagerMock = OCMClassMock([SDLPermissionManager class]);
        streamingManagerMock = OCMClassMock([SDLStreamingMediaManager class]);
        systemCapabilityMock = OCMClassMock([SDLSystemCapabilityManager class]);
        secondaryTransportManagerMock = OCMClassMock([SDLSecondaryTransportManager class]);
        encryptionManagerMock = OCMClassMock([SDLEncryptionLifecycleManager class]);

        SDLLifecycleConfiguration *testLifecycleConfig = [SDLLifecycleConfiguration defaultConfigurationWithAppName:@"Test App" fullAppId:@"TestFullAppID"];
        testLifecycleConfig.shortAppName = @"Short Name";
        testLifecycleConfig.appType = SDLAppHMITypeNavigation;
        
        testConfig = [[SDLConfiguration alloc] initWithLifecycle:testLifecycleConfig lockScreen:[SDLLockScreenConfiguration disabledConfiguration] logging:[SDLLogConfiguration defaultConfiguration] streamingMedia:[SDLStreamingMediaConfiguration insecureConfiguration] fileManager:[SDLFileManagerConfiguration defaultConfiguration] encryption:[SDLEncryptionConfiguration defaultConfiguration]];
        testConfig.lifecycleConfig.languagesSupported = @[SDLLanguageEnUs, SDLLanguageEnGb];
        testConfig.lifecycleConfig.language = SDLLanguageEnUs;
        testConfig.lifecycleConfig.minimumProtocolVersion = [SDLVersion versionWithMajor:2 minor:0 patch:0];
        testConfig.lifecycleConfig.minimumRPCVersion = [SDLVersion versionWithMajor:2 minor:0 patch:0];
        testManager = [[SDLLifecycleManager alloc] initWithConfiguration:testConfig delegate:sdlManagerDelegateProtocolMock];
        testManager.lockScreenManager = lockScreenManagerMock;
        testManager.fileManager = fileManagerMock;
        testManager.permissionManager = permissionManagerMock;
        testManager.streamManager = streamingManagerMock;
        testManager.systemCapabilityManager = systemCapabilityMock;
        testManager.secondaryTransportManager = secondaryTransportManagerMock;
        testManager.encryptionLifecycleManager = encryptionManagerMock;

        [SDLGlobals sharedGlobals].protocolVersion = [SDLVersion versionWithMajor:3 minor:0 patch:0];
        [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithMajor:3 minor:0 patch:0];
    });
    
    it(@"should initialize properties", ^{
        expect(testManager.configuration).toNot(equal(testConfig)); // This is copied
        expect(testManager.delegate).toNot(beNil());
        expect(testManager.lifecycleState).to(match(SDLLifecycleStateStopped));
        expect(@(testManager.lastCorrelationId)).to(equal(@0));
        expect(testManager.fileManager).toNot(beNil());
        expect(testManager.permissionManager).toNot(beNil());
        expect(testManager.streamManager).toNot(beNil());
        expect(testManager.registerResponse).to(beNil());
        expect(testManager.lockScreenManager).toNot(beNil());
        expect(testManager.notificationDispatcher).toNot(beNil());
        expect(testManager.responseDispatcher).toNot(beNil());
        expect(testManager.streamManager).toNot(beNil());
        expect(testManager.systemCapabilityManager).toNot(beNil());
        expect(testManager.rpcOperationQueue).toNot(beNil());
        expect(@([testManager conformsToProtocol:@protocol(SDLConnectionManagerType)])).to(equal(@YES));
        expect(testManager.authToken).to(beNil());
        expect(testManager.currentVRLanguage).toNot(beNil());
    });
    
    itBehavesLike(@"unable to send an RPC", ^{ return @{ @"manager": testManager }; });
    
    describe(@"after receiving an HMI Status", ^{
        __block SDLOnHMIStatus *testHMIStatus = nil;
        __block SDLHMILevel testHMILevel = nil;
        
        beforeEach(^{
            testHMIStatus = [[SDLOnHMIStatus alloc] init];
        });
        
        context(@"a non-none hmi level", ^{
            beforeEach(^{
                testHMILevel = SDLHMILevelNone;
                testHMIStatus.hmiLevel = testHMILevel;
                
                [testManager.notificationDispatcher postRPCNotificationNotification:SDLDidChangeHMIStatusNotification notification:testHMIStatus];
            });
            
            it(@"should set the hmi level", ^{
                expect(testManager.hmiLevel).toEventually(equal(testHMILevel));
            });
        });
        
        context(@"a non-full, non-none hmi level", ^{
            beforeEach(^{
                testHMILevel = SDLHMILevelBackground;
                testHMIStatus.hmiLevel = testHMILevel;
                
                [testManager.notificationDispatcher postRPCNotificationNotification:SDLDidChangeHMIStatusNotification notification:testHMIStatus];
            });
            
            it(@"should set the hmi level", ^{
                expect(testManager.hmiLevel).toEventually(equal(testHMILevel));
            });
        });
        
        context(@"a full hmi level", ^{
            beforeEach(^{
                testHMILevel = SDLHMILevelFull;
                testHMIStatus.hmiLevel = testHMILevel;
                
                [testManager.notificationDispatcher postRPCNotificationNotification:SDLDidChangeHMIStatusNotification notification:testHMIStatus];
            });
            
            it(@"should set the hmi level", ^{
                expect(testManager.hmiLevel).toEventually(equal(testHMILevel));
            });
        });
    });
    
    describe(@"calling stop", ^{
        beforeEach(^{
            [testManager stop];
        });
        
        it(@"should do nothing", ^{
            expect(testManager.lifecycleState).to(match(SDLLifecycleStateStopped));
            expect(testManager.lifecycleState).toEventuallyNot(match(SDLLifecycleStateStarted));
        });
    });
    
    describe(@"when started", ^{
        __block BOOL readyHandlerSuccess = NO;
        __block NSError *readyHandlerError = nil;

        beforeEach(^{
            readyHandlerSuccess = NO;
            readyHandlerError = nil;

            [testManager startWithReadyHandler:^(BOOL success, NSError * _Nullable error) {
                readyHandlerSuccess = success;
                readyHandlerError = error;
            }];

            testManager.protocolHandler.protocol = protocolMock;
        });
        
        it(@"should initialize enter the started state and start the secondary transport", ^{
            expect(testManager.lifecycleState).to(match(SDLLifecycleStateStarted));

            expect(testManager.secondaryTransportManager).toNot(beNil());
        });

        describe(@"after receiving a connect notification", ^{
            beforeEach(^{
                // When we connect, we should be creating an sending an RAI
                OCMExpect([protocolMock sendRPC:[OCMArg isKindOfClass:[SDLRegisterAppInterface class]]]);
            });

            context(@"when the protocol system info is set", ^{
                SDLSystemInfo *testSystemInfo = [[SDLSystemInfo alloc] initWithVehicleType:vehicleType softwareVersion:softwareVersion hardwareVersion:hardwareVersion];

                beforeEach(^{
                    OCMStub(protocolMock.systemInfo).andReturn(testSystemInfo);
                    OCMExpect([sdlManagerDelegateProtocolMock didReceiveSystemInfo:[OCMArg isEqual:testSystemInfo]]).andReturn(YES);
                    [testManager.notificationDispatcher postNotificationName:SDLRPCServiceDidConnect infoObject:nil];
                });

                it(@"should call the delegate handler", ^{
                    OCMVerifyAllWithDelay(sdlManagerDelegateProtocolMock, 1.0);
                });
            });

            context(@"when the protocol system info is not set", ^{
                beforeEach(^{
                    OCMStub(protocolMock.systemInfo).andReturn(nil);
                    [testManager.notificationDispatcher postNotificationName:SDLRPCServiceDidConnect infoObject:nil];
                });

                it(@"should call the delegate handler", ^{
                    OCMReject([sdlManagerDelegateProtocolMock didReceiveSystemInfo:[OCMArg isNil]]);
                });
            });
            
            it(@"should send a register app interface request and be in the connected state", ^{
                [testManager.notificationDispatcher postNotificationName:SDLRPCServiceDidConnect infoObject:nil];
                OCMVerifyAllWithDelay(protocolMock, 1.0);
                expect(testManager.lifecycleState).toEventually(equal(SDLLifecycleStateConnected));
            });
            
            itBehavesLike(@"unable to send an RPC", ^{ return @{ @"manager": testManager }; });
            
            describe(@"after receiving a disconnect notification", ^{
                beforeEach(^{
                    [testManager.notificationDispatcher postNotificationName:SDLRPCServiceDidConnect infoObject:nil];
                    [testManager.notificationDispatcher postNotificationName:SDLTransportDidDisconnect infoObject:nil];
                    [NSThread sleepForTimeInterval:0.1];
                });
                
                it(@"should be in the started state", ^{
                    expect(testManager.lifecycleState).to(equal(SDLLifecycleStateReconnecting));
                });
            });
            
            describe(@"stopping the manager", ^{
                it(@"should simply stop", ^{
                    [testManager.notificationDispatcher postNotificationName:SDLRPCServiceDidConnect infoObject:nil];
                    [testManager stop];
                    
                    expect(testManager.lifecycleState).toEventually(equal(SDLLifecycleStateStopped));
                });
            });
        });

        describe(@"in the connected state when the minimum protocol version is in effect", ^{
            beforeEach(^{
                [SDLGlobals sharedGlobals].protocolVersion = [SDLVersion versionWithMajor:1 minor:0 patch:0];

                OCMExpect([protocolMock endServiceWithType:SDLServiceTypeRPC]);
                [testManager.lifecycleStateMachine setToState:SDLLifecycleStateConnected fromOldState:nil callEnterTransition:YES];
            });

            it(@"should disconnect", ^{
                OCMVerifyAll(protocolMock);
            });
        });
        
        describe(@"in the connected state", ^{
            beforeEach(^{
                [testManager.lifecycleStateMachine setToState:SDLLifecycleStateConnected fromOldState:nil callEnterTransition:NO];
            });

             describe(@"after receiving a register app interface response", ^{
                it(@"should eventually reach the ready state", ^{
                    NSError *fileManagerStartError = [NSError errorWithDomain:@"testDomain" code:0 userInfo:nil];
                    NSError *permissionManagerStartError = [NSError errorWithDomain:@"testDomain" code:0 userInfo:nil];

                    OCMStub([fileManagerMock startWithCompletionHandler:([OCMArg invokeBlockWithArgs:@(YES), fileManagerStartError, nil])]);
                    OCMStub([permissionManagerMock startWithCompletionHandler:([OCMArg invokeBlockWithArgs:@(YES), permissionManagerStartError, nil])]);

                    // Make sure we have an HMI status to move the lifecycle forward
                    testManager.hmiLevel = SDLHMILevelFull;
                    transitionToState(SDLLifecycleStateRegistered);

                    expect(testManager.lifecycleState).toEventually(equal(SDLLifecycleStateReady));
                    OCMVerify([(SDLLockScreenManager *)lockScreenManagerMock start]);
                    OCMVerify([(SDLSystemCapabilityManager *)systemCapabilityMock start]);
                    OCMVerify([fileManagerMock startWithCompletionHandler:[OCMArg any]]);
                    OCMVerify([permissionManagerMock startWithCompletionHandler:[OCMArg any]]);
                    OCMVerify([encryptionManagerMock startWithProtocol:[OCMArg any]]);
                });

                itBehavesLike(@"unable to send an RPC", ^{ return @{ @"manager": testManager }; });
            });

            context(@"when the protocol system info is not set", ^{
                beforeEach(^{
                    testManager.systemInfo = nil;
                    OCMExpect([sdlManagerDelegateProtocolMock didReceiveSystemInfo:[OCMArg isNotNil]]).andReturn(YES);
                });

                it(@"should call the delegate handler", ^{
                    SDLRegisterAppInterfaceResponse *response = [[SDLRegisterAppInterfaceResponse alloc] init];
                    response.resultCode = SDLResultSuccess;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
                    response.vehicleType = vehicleType;
                    response.systemSoftwareVersion = softwareVersion;
#pragma clang diagnostic pop
                    testManager.registerResponse = response;
                    [testManager.lifecycleStateMachine setToState:SDLLifecycleStateRegistered fromOldState:nil callEnterTransition:YES];

                    OCMVerifyAllWithDelay(sdlManagerDelegateProtocolMock, 1.0);
                });
            });

            context(@"when the protocol system info is set", ^{
                SDLSystemInfo *testSystemInfo = [[SDLSystemInfo alloc] initWithVehicleType:vehicleType softwareVersion:softwareVersion hardwareVersion:hardwareVersion];

                beforeEach(^{
                    testManager.systemInfo = testSystemInfo;
                });

                it(@"should call not the delegate handler", ^{
                    SDLRegisterAppInterfaceResponse *response = [[SDLRegisterAppInterfaceResponse alloc] init];
                    response.resultCode = SDLResultSuccess;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
                    response.vehicleType = vehicleType;
                    response.systemSoftwareVersion = softwareVersion;
#pragma clang diagnostic pop
                    [testManager.lifecycleStateMachine setToState:SDLLifecycleStateRegistered fromOldState:nil callEnterTransition:YES];

                    OCMReject([sdlManagerDelegateProtocolMock didReceiveSystemInfo:[OCMArg isNotNil]]);
                });
            });

            context(@"when the register response returns different language than the one passed with the lifecycle configuration", ^{
                it(@"should should update the configuration when the app supports the head unit language", ^{
                    SDLRegisterAppInterfaceResponse *registerAppInterfaceResponse = [[SDLRegisterAppInterfaceResponse alloc] init];
                    registerAppInterfaceResponse.success = @YES;
                    registerAppInterfaceResponse.resultCode = SDLResultWrongLanguage;
                    registerAppInterfaceResponse.info = @"Language mismatch";
                    registerAppInterfaceResponse.language = SDLLanguageEnGb;
                    registerAppInterfaceResponse.hmiDisplayLanguage = SDLLanguageEnGb;
                    testManager.registerResponse = registerAppInterfaceResponse;

                    SDLLifecycleConfigurationUpdate *update = [[SDLLifecycleConfigurationUpdate alloc] initWithAppName:@"EnGb" shortAppName:@"E" ttsName:[SDLTTSChunk textChunksFromString:@"EnGb ttsName"] voiceRecognitionCommandNames:@[@"EnGb", @"Gb"]];
                    OCMStub([testManager.delegate managerShouldUpdateLifecycleToLanguage:[OCMArg any] hmiLanguage:[OCMArg any]]).andReturn(update);

                    OCMExpect([protocolMock sendRPC:[OCMArg checkWithBlock:^BOOL(id value) {
                        SDLChangeRegistration *changeRegistration = (SDLChangeRegistration *)value;
                        expect(changeRegistration.appName).to(equal(update.appName));
                        expect(changeRegistration.ngnMediaScreenAppName).to(equal(update.shortAppName));
                        expect(changeRegistration.ttsName).to(equal(update.ttsName));
                        expect(changeRegistration.vrSynonyms).to(equal(@[@"EnGb", @"Gb"]));
                        return [value isKindOfClass:[SDLChangeRegistration class]];
                    }]]);

                    setToStateWithEnterTransition(SDLLifecycleStateRegistered, SDLLifecycleStateUpdatingConfiguration);

                    OCMVerifyAllWithDelay(protocolMock, 0.5);

                    expect(testManager.configuration.lifecycleConfig.language).toEventually(equal(SDLLanguageEnGb));
                    expect(testManager.currentVRLanguage).toEventually(equal(SDLLanguageEnGb));
                    expect(testManager.configuration.lifecycleConfig.appName).toEventually(equal(@"EnGb"));
                    expect(testManager.configuration.lifecycleConfig.shortAppName).toEventually(equal(@"E"));
                    expect(testManager.configuration.lifecycleConfig.ttsName).toEventually(equal([SDLTTSChunk textChunksFromString:@"EnGb ttsName"]));
                });

                it(@"should not update the configuration when the app does not support the head unit language or display language", ^{
                    SDLRegisterAppInterfaceResponse *registerAppInterfaceResponse = [[SDLRegisterAppInterfaceResponse alloc] init];
                    registerAppInterfaceResponse.success = @YES;
                    registerAppInterfaceResponse.resultCode = SDLResultWrongLanguage;
                    registerAppInterfaceResponse.info = @"Language mismatch";
                    registerAppInterfaceResponse.language = SDLLanguageDeDe;
                    registerAppInterfaceResponse.hmiDisplayLanguage = SDLLanguageDeDe;
                    testManager.registerResponse = registerAppInterfaceResponse;

                    OCMStub([testManager.delegate managerShouldUpdateLifecycleToLanguage:[OCMArg any] hmiLanguage:[OCMArg any]]).andReturn(nil);

                    setToStateWithEnterTransition(SDLLifecycleStateRegistered, SDLLifecycleStateUpdatingConfiguration);

                    OCMVerifyAllWithDelay(protocolMock, 0.5);

                    expect(testManager.configuration.lifecycleConfig.language).toEventually(equal(SDLLanguageEnUs));
                    expect(testManager.currentVRLanguage).toEventually(equal(SDLLanguageEnUs));
                    expect(testManager.configuration.lifecycleConfig.appName).toEventually(equal(@"Test App"));
                    expect(testManager.configuration.lifecycleConfig.shortAppName).toEventually(equal(@"Short Name"));
                    expect(testManager.configuration.lifecycleConfig.ttsName).toEventually(beNil());
                });

                it(@"should update when the app supports the head unit display language", ^{
                    SDLRegisterAppInterfaceResponse *registerAppInterfaceResponse = [[SDLRegisterAppInterfaceResponse alloc] init];
                    registerAppInterfaceResponse.success = @YES;
                    registerAppInterfaceResponse.resultCode = SDLResultWrongLanguage;
                    registerAppInterfaceResponse.info = @"Language mismatch";
                    registerAppInterfaceResponse.language = SDLLanguageEnUs;
                    registerAppInterfaceResponse.hmiDisplayLanguage = SDLLanguageEnGb;
                    testManager.registerResponse = registerAppInterfaceResponse;

                    SDLLifecycleConfigurationUpdate *update = [[SDLLifecycleConfigurationUpdate alloc] initWithAppName:@"EnGb" shortAppName:@"Gb" ttsName:nil voiceRecognitionCommandNames:nil];
                    OCMStub([testManager.delegate managerShouldUpdateLifecycleToLanguage:registerAppInterfaceResponse.language hmiLanguage:registerAppInterfaceResponse.hmiDisplayLanguage]).andReturn(update);

                    setToStateWithEnterTransition(SDLLifecycleStateRegistered, SDLLifecycleStateUpdatingConfiguration);

                    OCMExpect([protocolMock sendRPC:[OCMArg checkWithBlock:^BOOL(id value) {
                        SDLChangeRegistration *changeRegistration = (SDLChangeRegistration *)value;
                        expect(changeRegistration.appName).to(equal(update.appName));
                        expect(changeRegistration.ngnMediaScreenAppName).to(equal(update.shortAppName));
                        expect(changeRegistration.ttsName).to(beNil());
                        expect(changeRegistration.vrSynonyms).to(beNil());
                        return [value isKindOfClass:[SDLChangeRegistration class]];
                    }]]);

                    setToStateWithEnterTransition(SDLLifecycleStateRegistered, SDLLifecycleStateUpdatingConfiguration);

                    OCMVerifyAllWithDelay(protocolMock, 0.5);

                    expect(testManager.configuration.lifecycleConfig.language).toEventually(equal(SDLLanguageEnGb));
                    expect(testManager.currentVRLanguage).toEventually(equal(SDLLanguageEnUs));
                    expect(testManager.configuration.lifecycleConfig.appName).toEventually(equal(@"EnGb"));
                    expect(testManager.configuration.lifecycleConfig.shortAppName).toEventually(equal(@"Gb"));
                    expect(testManager.configuration.lifecycleConfig.ttsName).toEventually(beNil());
                });
            });
            
            describe(@"after receiving a disconnect notification", ^{
                beforeEach(^{
                    OCMStub([protocolMock stopWithCompletionHandler:[OCMArg invokeBlock]]);
                    OCMStub([secondaryTransportManagerMock stopWithCompletionHandler:[OCMArg invokeBlock]]);
                    [testManager.notificationDispatcher postNotificationName:SDLTransportDidDisconnect infoObject:nil];
                    [NSThread sleepForTimeInterval:1.0];
                });
                
                it(@"should enter the started state", ^{
                    expect(testManager.lifecycleState).toEventually(equal(SDLLifecycleStateStarted));
                });
            });
            
            describe(@"stopping the manager", ^{
                beforeEach(^{
                    [testManager stop];
                });
                
                it(@"should enter the stopped state", ^{
                    expect(testManager.lifecycleState).to(equal(SDLLifecycleStateStopped));
                });
            });
        });

        describe(@"transitioning to the registered state when the minimum RPC version is in effect", ^{
            beforeEach(^{
                [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithMajor:1 minor:0 patch:0];

                [testManager.lifecycleStateMachine setToState:SDLLifecycleStateRegistered fromOldState:nil callEnterTransition:YES];
            });

            it(@"should disconnect", ^{
                expect(testManager.lifecycleState).to(equal(SDLLifecycleStateUnregistering));
            });
        });
        
        describe(@"transitioning from setting app icon state to the Setting Up HMI state", ^{
            context(@"before register response is a success", ^{
                it(@"ready handler should not be called yet", ^{
                    SDLRegisterAppInterfaceResponse *response = [[SDLRegisterAppInterfaceResponse alloc] init];
                    response.resultCode = SDLResultSuccess;
                    testManager.registerResponse = response;
                    
                    setToStateWithEnterTransition(nil, SDLLifecycleStateSettingUpHMI);

                    expect(@(readyHandlerSuccess)).to(equal(@NO));
                    expect(readyHandlerError).to(beNil());
                });
            });
            
            context(@"assume hmi status is nil", ^{
                it(@"mock notification and ensure state changes to ready", ^{
                    __block SDLOnHMIStatus *testHMIStatus = nil;
                    __block SDLHMILevel testHMILevel = nil;
                    testHMIStatus = [[SDLOnHMIStatus alloc] init];
                    
                    SDLRegisterAppInterfaceResponse *response = [[SDLRegisterAppInterfaceResponse alloc] init];
                    response.resultCode = SDLResultSuccess;
                    testManager.registerResponse = response;
                    
                    setToStateWithEnterTransition(nil, SDLLifecycleStateSettingUpHMI);
                    
                    testHMILevel = SDLHMILevelFull;
                    testHMIStatus.hmiLevel = testHMILevel;
                    
                    [testManager.notificationDispatcher postRPCNotificationNotification:SDLDidChangeHMIStatusNotification notification:testHMIStatus];

                    expect(testManager.lifecycleState).toEventually(equal(SDLLifecycleStateReady));
                    expect(@(readyHandlerSuccess)).toEventually(equal(@YES));
                    expect(readyHandlerError).toEventually(beNil());
                });
            });
        });

        describe(@"transitioning from the registered state to the ready state", ^{
            beforeEach(^{
                [testManager.lifecycleStateMachine setToState:SDLLifecycleStateRegistered fromOldState:nil callEnterTransition:NO];
            });

            context(@"when the register response is a success", ^{
                it(@"should call the ready handler with success", ^{
                    SDLRegisterAppInterfaceResponse *response = [[SDLRegisterAppInterfaceResponse alloc] init];
                    response.resultCode = SDLResultSuccess;
                    testManager.registerResponse = response;
                    
                    setToStateWithEnterTransition(nil, SDLLifecycleStateReady);

                    expect(@(readyHandlerSuccess)).toEventually(equal(@YES));
                    expect(readyHandlerError).toEventually(beNil());
                });
            });

            context(@"when the register response is a warning", ^{
                it(@"should call the ready handler with success but error", ^{
                    SDLRegisterAppInterfaceResponse *response = [[SDLRegisterAppInterfaceResponse alloc] init];
                    response.resultCode = SDLResultWarnings;
                    response.info = @"some info";
                    testManager.registerResponse = response;

                    setToStateWithEnterTransition(nil, SDLLifecycleStateReady);

                    expect(@(readyHandlerSuccess)).toEventually(equal(@YES));
                    expect(readyHandlerError).toEventuallyNot(beNil());
                    expect(@(readyHandlerError.code)).toEventually(equal(@(SDLManagerErrorRegistrationSuccessWithWarning)));
                    expect(readyHandlerError.userInfo[NSLocalizedFailureReasonErrorKey]).toEventually(match(response.info));
                });
            });
        });
        
        describe(@"in the ready state", ^{
            beforeEach(^{
                [testManager.lifecycleStateMachine setToState:SDLLifecycleStateReady fromOldState:nil callEnterTransition:NO];
            });

            it(@"can send an RPC of type Request", ^{
                SDLShow *testShow = [[SDLShow alloc] initWithMainField1:@"test" mainField2:nil mainField3:nil mainField4:nil alignment:nil statusBar:nil mediaTrack:nil graphic:nil secondaryGraphic:nil softButtons:nil customPresets:nil metadataTags:nil templateTitle:nil windowID:nil templateConfiguration:nil];
                OCMExpect([protocolMock sendRPC:testShow]);
                [testManager sendRPC:testShow];

                OCMVerifyAllWithDelay(protocolMock, 0.1);
            });

            it(@"can send an RPC of type Response", ^{
                SDLPerformAppServiceInteractionResponse *testResponse = [[SDLPerformAppServiceInteractionResponse alloc] init];
                OCMExpect([protocolMock sendRPC:testResponse]);
                [testManager sendRPC:testResponse];
                testResponse.correlationID = @(2);
                testResponse.success = @(true);
                testResponse.resultCode = SDLResultSuccess;
                testResponse.info = @"testResponse info";

                OCMVerifyAllWithDelay(protocolMock, 0.1);
            });

            it(@"can send an RPC of type Notification", ^{
                SDLOnAppServiceData *testNotification = [[SDLOnAppServiceData alloc] initWithServiceData:[[SDLAppServiceData alloc] init]];
                OCMExpect([protocolMock sendRPC:testNotification]);
                [testManager sendRPC:testNotification];

                OCMVerifyAllWithDelay(protocolMock, 0.1);
            });

            it(@"should throw an exception if the RPC is not of type `Request`, `Response` or `Notification`", ^{
                SDLRPCMessage *testMessage = [[SDLRPCMessage alloc] init];
                expectAction(^{
                    [testManager sendRPC:testMessage];
                }).to(raiseException());
            });
            
            describe(@"stopping the manager on certain SDLAppInterfaceUnregisteredReason", ^{
                it(@"should attempt to stop the manager when a PROTOCOL_VIOLATION notification is recieved", ^{

                    SDLOnAppInterfaceUnregistered *unreg = [[SDLOnAppInterfaceUnregistered alloc] init];
                    unreg.reason = SDLAppInterfaceUnregisteredReasonProtocolViolation;
                    
                    SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveAppUnregisteredNotification object:testManager.notificationDispatcher rpcNotification:unreg];
                    
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                    expect(testManager.lifecycleState).toEventually(equal(SDLLifecycleStateStopped));
                });
       
                it(@"should attempt to stop the manager when an APP_UNAUTHORIZED notification is recieved", ^{
                    
                    SDLOnAppInterfaceUnregistered *unreg = [[SDLOnAppInterfaceUnregistered alloc] init];
                    unreg.reason = SDLAppInterfaceUnregisteredReasonAppUnauthorized;
                    
                    SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveAppUnregisteredNotification object:testManager.notificationDispatcher rpcNotification:unreg];
                    
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                    expect(testManager.lifecycleState).toEventually(equal(SDLLifecycleStateStopped));
                });
            });
            
            
            describe(@"stopping the manager", ^{
                beforeEach(^{
                    [testManager stop];
                });
                
                it(@"should attempt to unregister", ^{
                    OCMVerify([protocolMock sendRPC:[OCMArg isKindOfClass:[SDLUnregisterAppInterface class]]]);
                    expect(testManager.lifecycleState).toEventually(match(SDLLifecycleStateUnregistering));
                });
                
                describe(@"when receiving an unregister response", ^{
                    __block SDLUnregisterAppInterfaceResponse *testUnregisterResponse = nil;
                    
                    beforeEach(^{
                        testUnregisterResponse = [[SDLUnregisterAppInterfaceResponse alloc] init];
                        testUnregisterResponse.success = @YES;
                        testUnregisterResponse.correlationID = @(testManager.lastCorrelationId);
                        
                        // This should run on `com.sdl.rpcProcessingQueue` to simulate the real case.
                        [testManager.notificationDispatcher postRPCResponseNotification:SDLDidReceiveUnregisterAppInterfaceResponse response:testUnregisterResponse];
                    });
                    
                    it(@"should stop", ^{
                        expect(testManager.lifecycleState).toEventually(match(SDLLifecycleStateStopped));
                    });
                });
            });
            
            describe(@"receiving an HMI level change", ^{
                __block SDLOnHMIStatus *testHMIStatus = nil;
                __block SDLHMILevel testHMILevel = nil;
                __block SDLHMILevel oldHMILevel = nil;
                
                beforeEach(^{
                    oldHMILevel = testManager.hmiLevel;
                    testHMIStatus = [[SDLOnHMIStatus alloc] init];
                });
                
                context(@"a full hmi level", ^{
                    beforeEach(^{
                        testHMILevel = SDLHMILevelFull;
                        testHMIStatus.hmiLevel = testHMILevel;
                        
                        [testManager.notificationDispatcher postRPCNotificationNotification:SDLDidChangeHMIStatusNotification notification:testHMIStatus];
                    });
                    
                    it(@"should set the hmi level", ^{
                        expect(testManager.hmiLevel).toEventually(equal(testHMILevel));
                    });
                    
                    it(@"should call the delegate", ^{
                        // Since notifications are sent to SDLManagerDelegate observers on the main thread, force the block to execute manually on the main thread. If this is not done, the test case may fail.
                        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
                        OCMVerify([testManager.delegate hmiLevel:[OCMArg any] didChangeToLevel:[OCMArg any]]);
                    });
                });
            });
            
            describe(@"receiving an audio state change", ^{
                __block SDLOnHMIStatus *testHMIStatus = nil;
                __block SDLAudioStreamingState testAudioStreamingState = nil;
                __block SDLAudioStreamingState oldAudioStreamingState = nil;
                
                beforeEach(^{
                    oldAudioStreamingState = testManager.audioStreamingState;
                    testHMIStatus = [[SDLOnHMIStatus alloc] init];
                });
                
                context(@"a not audible audio state", ^{
                    beforeEach(^{
                        testAudioStreamingState = SDLAudioStreamingStateNotAudible;
                        testHMIStatus.audioStreamingState = testAudioStreamingState;
                        
                        [testManager.notificationDispatcher postRPCNotificationNotification:SDLDidChangeHMIStatusNotification notification:testHMIStatus];
                    });
                    
                    it(@"should set the audio state", ^{
                        expect(testManager.audioStreamingState).toEventually(equal(testAudioStreamingState));
                    });
                    
                    it(@"should call the delegate", ^{
                        // Since notifications are sent to SDLManagerDelegate observers on the main thread, force the block to execute manually on the main thread. If this is not done, the test case may fail.
                        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];

                        OCMVerify([testManager.delegate audioStreamingState:oldAudioStreamingState didChangeToState:testAudioStreamingState]);
                    });
                });
            });

            describe(@"receiving a video state change", ^{
                __block SDLOnHMIStatus *testHMIStatus = nil;
                __block SDLVideoStreamingState testVideoStreamingState = nil;
                __block SDLAudioStreamingState oldVideoStreamingState = nil;

                beforeEach(^{
                    oldVideoStreamingState = testManager.videoStreamingState;
                    testHMIStatus = [[SDLOnHMIStatus alloc] init];
                });

                context(@"a not audible audio state", ^{
                    beforeEach(^{
                        testVideoStreamingState = SDLVideoStreamingStateNotStreamable;
                        testHMIStatus.videoStreamingState = testVideoStreamingState;

                        [testManager.notificationDispatcher postRPCNotificationNotification:SDLDidChangeHMIStatusNotification notification:testHMIStatus];
                    });

                    it(@"should set the audio state", ^{
                        expect(testManager.videoStreamingState).toEventually(equal(testVideoStreamingState));
                    });

                    it(@"should call the delegate", ^{
                        // Since notifications are sent to SDLManagerDelegate observers on the main thread, force the block to execute manually on the main thread. If this is not done, the test case may fail.
                        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];

                        OCMVerify([testManager.delegate videoStreamingState:oldVideoStreamingState didChangetoState:testVideoStreamingState]);
                    });
                });
            });
            
            describe(@"receiving a system context change", ^{
                __block SDLOnHMIStatus *testHMIStatus = nil;
                __block SDLSystemContext testSystemContext = nil;
                __block SDLSystemContext oldSystemContext = nil;

                beforeEach(^{
                    oldSystemContext = testManager.systemContext;
                    testHMIStatus = [[SDLOnHMIStatus alloc] init];
                });
                
                context(@"a alert system context state", ^{
                    beforeEach(^{
                        expect(testManager.lifecycleStateMachine.currentState).to(equal(SDLLifecycleStateReady));
                        expect(testManager.systemContext).to(beNil());

                        testSystemContext = SDLSystemContextAlert;
                        testHMIStatus.systemContext = testSystemContext;
                        
                        [testManager.notificationDispatcher postRPCNotificationNotification:SDLDidChangeHMIStatusNotification notification:testHMIStatus];
                    });
                    
                    it(@"should set the system context", ^{
                        expect(testManager.systemContext).toEventually(equal(testSystemContext));
                    });
                    
                    it(@"should call the delegate", ^{
                        // Since notifications are sent to SDLManagerDelegate observers on the main thread, force the block to execute manually on the main thread. If this is not done, the test case may fail.
                        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
                        OCMVerify([testManager.delegate systemContext:[OCMArg any] didChangeToContext:[OCMArg any]]);
                    });

                    afterEach(^{
                        expect(testManager.delegate).toNot(beNil());
                    });
                });
            });
         });
    });

    describe(@"configuring the lifecycle manager", ^{
        __block SDLLifecycleConfiguration *lifecycleConfig = nil;
        __block SDLLifecycleManager *testManager = nil;

        beforeEach(^{
            lifecycleConfig = [SDLLifecycleConfiguration defaultConfigurationWithAppName:@"Test app" fullAppId:@"Test ID"];
        });

        context(@"if secondary transport is not allowed", ^{
            beforeEach(^{
                lifecycleConfig.allowedSecondaryTransports = SDLSecondaryTransportsNone;
                SDLConfiguration *config = [[SDLConfiguration alloc] initWithLifecycle:lifecycleConfig lockScreen:[SDLLockScreenConfiguration disabledConfiguration] logging:[SDLLogConfiguration defaultConfiguration] fileManager:[SDLFileManagerConfiguration defaultConfiguration] encryption:[SDLEncryptionConfiguration defaultConfiguration]];
                testManager = [[SDLLifecycleManager alloc] initWithConfiguration:config delegate:nil];
                [testManager.lifecycleStateMachine setToState:SDLLifecycleStateStarted fromOldState:nil callEnterTransition:YES];
            });

            it(@"should not create a secondary transport manager", ^{
                expect(testManager.secondaryTransportManager).to(beNil());
            });
        });

        context(@"if a secondary transport is allowed but app is NOT a navigation or projection app", ^{
            beforeEach(^{
                 lifecycleConfig.allowedSecondaryTransports = SDLSecondaryTransportsTCP;
                 lifecycleConfig.appType = SDLAppHMITypeSocial;
                 SDLConfiguration *config = [[SDLConfiguration alloc] initWithLifecycle:lifecycleConfig lockScreen:[SDLLockScreenConfiguration disabledConfiguration] logging:[SDLLogConfiguration defaultConfiguration] fileManager:[SDLFileManagerConfiguration defaultConfiguration] encryption:[SDLEncryptionConfiguration defaultConfiguration]];
                 testManager = [[SDLLifecycleManager alloc] initWithConfiguration:config delegate:nil];
                 [testManager.lifecycleStateMachine setToState:SDLLifecycleStateStarted fromOldState:nil callEnterTransition:YES];
            });

             it(@"should not create a secondary transport manager", ^{
                 expect(testManager.secondaryTransportManager).to(beNil());
             });
        });

        context(@"if a secondary transport is allowed and app is a navigation or projection app", ^{
            beforeEach(^{
                lifecycleConfig.allowedSecondaryTransports = SDLSecondaryTransportsTCP;
                lifecycleConfig.appType = SDLAppHMITypeProjection;
                SDLConfiguration *config = [[SDLConfiguration alloc] initWithLifecycle:lifecycleConfig lockScreen:[SDLLockScreenConfiguration disabledConfiguration] logging:[SDLLogConfiguration defaultConfiguration] streamingMedia:[SDLStreamingMediaConfiguration insecureConfiguration] fileManager:[SDLFileManagerConfiguration defaultConfiguration] encryption:[SDLEncryptionConfiguration defaultConfiguration]];
                testManager = [[SDLLifecycleManager alloc] initWithConfiguration:config delegate:nil];

                [testManager.lifecycleStateMachine setToState:SDLLifecycleStateStarted fromOldState:nil callEnterTransition:YES];
            });

            it(@"should create a secondary transport manager", ^{
                expect(testManager.streamManager).toNot(beNil());
                expect(testManager.secondaryTransportManager).toNot(beNil());
            });
        });
    });
});

QuickSpecEnd
