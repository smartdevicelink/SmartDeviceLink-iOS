//
//  SDLLockScreenStatusManagerSpec
//  SmartDeviceLink-iOS

@import Quick;
@import Nimble;
@import OCMock;

#import "SDLOnDriverDistraction.h"
#import "SDLHMILevel.h"
#import "SDLLockScreenStatusInfo.h"
#import "SDLLockScreenStatusManager.h"
#import "SDLNotificationConstants.h"
#import "SDLNotificationDispatcher.h"
#import "SDLOnHMIStatus.h"
#import "SDLRPCNotificationNotification.h"


QuickSpecBegin(SDLLockScreenStatusManagerSpec)

describe(@"the lockscreen status manager", ^{
    __block SDLLockScreenStatusManager *testManager;
    __block id mockDispatcher;

    beforeEach(^{
        mockDispatcher = OCMClassMock([SDLNotificationDispatcher class]);
        testManager = [[SDLLockScreenStatusManager alloc] initWithNotificationDispatcher:mockDispatcher];
    });
    
    it(@"should properly initialize user selected app boolean to false", ^{
        expect(@(testManager.userSelected)).to(beFalse());
    });
    
    it(@"should properly initialize driver is distracted boolean to false", ^{
        expect(@(testManager.driverDistracted)).to(beFalse());
    });
    
    it(@"should properly initialize hmi level object to nil", ^{
        expect(testManager.hmiLevel).to(beNil());
    });
    
    describe(@"when setting HMI level", ^{
        context(@"to FULL", ^{
            beforeEach(^{
                testManager.userSelected = NO;
                testManager.hmiLevel = SDLHMILevelFull;
            });
            
            it(@"should set user selected to true", ^{
                expect(@(testManager.userSelected)).to(beTrue());
            });
        });
        
        context(@"to LIMITED", ^{
            beforeEach(^{
                testManager.userSelected = NO;
                testManager.hmiLevel = SDLHMILevelLimited;
            });
            
            it(@"should set user selected to true", ^{
                expect(@(testManager.userSelected)).to(beTrue());
            });
        });
        
        context(@"to BACKGROUND", ^{
            beforeEach(^{
                testManager.hmiLevel = SDLHMILevelBackground;
            });
            
            context(@"when user selected is false", ^{
                beforeEach(^{
                    testManager.userSelected = NO;
                });
                
                it(@"should not alter the value", ^{
                    expect(@(testManager.userSelected)).to(beFalse());
                });
            });
            
            context(@"when user selected is true", ^{
                beforeEach(^{
                    testManager.userSelected = YES;
                });
                
                it(@"should not alter the value", ^{
                    expect(@(testManager.userSelected)).to(beTrue());
                });
            });
        });
        
        context(@"to NONE", ^{
            beforeEach(^{
                testManager.userSelected = YES;
                testManager.hmiLevel = SDLHMILevelNone;
            });
            
            it(@"should set user selected to false", ^{
                expect(@(testManager.userSelected)).to(beFalse());
            });
        });
    });
    
    describe(@"when getting lock screen status", ^{
        context(@"when HMI level is nil", ^{
            beforeEach(^{
                testManager.hmiLevel = nil;
            });
            
            it(@"should return lock screen off", ^{
                expect(@(testManager.lockScreenStatus)).to(equal(SDLLockScreenStatusOff));
            });
        });
        
        context(@"when HMI level is NONE", ^{
            beforeEach(^{
                testManager.hmiLevel = SDLHMILevelNone;
            });
            
            it(@"should return lock screen off", ^{
                expect(@(testManager.lockScreenStatus)).to(equal(SDLLockScreenStatusOff));
            });
        });
        
        context(@"when HMI level is BACKGROUND", ^{
            beforeEach(^{
                testManager.hmiLevel = SDLHMILevelBackground;
            });
            
            context(@"when user selected is true", ^{
                beforeEach(^{
                    testManager.userSelected = YES;
                });

                context(@"if we do not set the driver distraction state", ^{
                    it(@"should return lock screen required", ^{
                        expect(@(testManager.lockScreenStatus)).to(equal(SDLLockScreenStatusRequired));
                    });
                });

                context(@"if we set the driver distraction state to false", ^{
                    beforeEach(^{
                        testManager.driverDistracted = NO;
                    });

                    it(@"should return lock screen optional", ^{
                        expect(@(testManager.lockScreenStatus)).to(equal(SDLLockScreenStatusOptional));
                    });
                });

                context(@"if we set the driver distraction state to true", ^{
                    beforeEach(^{
                        testManager.driverDistracted = YES;
                    });

                    it(@"should return lock screen required", ^{
                        expect(@(testManager.lockScreenStatus)).to(equal(SDLLockScreenStatusRequired));
                    });
                });
            });
            
            context(@"when user selected is false", ^{
                beforeEach(^{
                    testManager.userSelected = NO;
                });
                
                it(@"should return lock screen off", ^{
                    expect(@(testManager.lockScreenStatus)).to(equal(SDLLockScreenStatusOff));
                });
            });
        });
        
        context(@"when HMI level is LIMITED", ^{
            beforeEach(^{
                testManager.hmiLevel = SDLHMILevelLimited;
            });
            
            context(@"if we do not set the driver distraction state", ^{
                it(@"should return lock screen required", ^{
                    expect(@(testManager.lockScreenStatus)).to(equal(SDLLockScreenStatusRequired));
                });
            });
            
            context(@"if we set the driver distraction state to false", ^{
                beforeEach(^{
                    testManager.driverDistracted = NO;
                });
                
                it(@"should return lock screen optional", ^{
                    expect(@(testManager.lockScreenStatus)).to(equal(SDLLockScreenStatusOptional));
                });
            });
            
            context(@"if we set the driver distraction state to true", ^{
                beforeEach(^{
                    testManager.driverDistracted = YES;
                });
                
                it(@"should return lock screen required", ^{
                    expect(@(testManager.lockScreenStatus)).to(equal(SDLLockScreenStatusRequired));
                });
            });
        });
        
        context(@"when HMI level is FULL", ^{
            beforeEach(^{
                testManager.hmiLevel = SDLHMILevelFull;
            });
            
            context(@"if we do not set the driver distraction state", ^{
                it(@"should return lock screen required", ^{
                    expect(@(testManager.lockScreenStatus)).to(equal(SDLLockScreenStatusRequired));
                });
            });
            
            context(@"if we set the driver distraction state to false", ^{
                beforeEach(^{
                    testManager.driverDistracted = NO;
                });
                
                it(@"should return lock screen optional", ^{
                    expect(@(testManager.lockScreenStatus)).to(equal(SDLLockScreenStatusOptional));
                });
            });
            
            context(@"if we set the driver distraction state to true", ^{
                beforeEach(^{
                    testManager.driverDistracted = YES;
                });
                
                it(@"should return lock screen required", ^{
                    expect(@(testManager.lockScreenStatus)).to(equal(SDLLockScreenStatusRequired));
                });
            });
        });
    });
    
    describe(@"when sending a lock screen status notification", ^{
        __block SDLLockScreenStatusInfo *onLockScreenStatusNotification = nil;
        beforeEach(^{
            testManager.userSelected = YES;
            testManager.driverDistracted = NO;
            testManager.hmiLevel = SDLHMILevelLimited;
            
            onLockScreenStatusNotification = testManager.lockScreenStatusNotification;
        });
        
        it(@"should properly return user selected", ^{
            expect(onLockScreenStatusNotification.userSelected).to(beTrue());
        });
        
        it(@"should properly return driver distraction status", ^{
            expect(onLockScreenStatusNotification.driverDistractionStatus).to(beFalse());
        });
        
        it(@"should properly return HMI level", ^{
            expect(onLockScreenStatusNotification.hmiLevel).to(equal(SDLHMILevelLimited));
        });
        
        it(@"should properly return lock screen status", ^{
            expect(@(onLockScreenStatusNotification.lockScreenStatus)).to(equal(SDLLockScreenStatusOptional));
        });
    });

    describe(@"when receiving an HMI status", ^{
        beforeEach(^{
            OCMExpect([mockDispatcher postNotificationName:SDLDidChangeLockScreenStatusNotification infoObject:[OCMArg checkWithBlock:^BOOL(id value) {
                SDLLockScreenStatusInfo *lockScreenStatusInfo = (SDLLockScreenStatusInfo *)value;
                expect(lockScreenStatusInfo.hmiLevel).to(equal(SDLHMILevelFull));
                return [lockScreenStatusInfo isKindOfClass:[SDLLockScreenStatusInfo class]];
            }]]);

            SDLOnHMIStatus *hmiStatus = [[SDLOnHMIStatus alloc] initWithHMILevel:SDLHMILevelFull systemContext:SDLSystemContextMain audioStreamingState:SDLAudioStreamingStateAudible videoStreamingState:nil windowID:nil];
            [testManager updateHMIStatus:hmiStatus];
        });

        it(@"should update the driver distraction status and send a notification", ^{
            expect(testManager.hmiLevel).to(equal(SDLHMILevelFull));
            OCMVerifyAllWithDelay(mockDispatcher, 0.5);
        });
    });

    describe(@"when receiving a driver distraction status", ^{
        beforeEach(^{
            OCMExpect([mockDispatcher postNotificationName:SDLDidChangeLockScreenStatusNotification infoObject:[OCMArg checkWithBlock:^BOOL(id value) {
                SDLLockScreenStatusInfo *lockScreenStatusInfo = (SDLLockScreenStatusInfo *)value;
                expect(lockScreenStatusInfo.driverDistractionStatus).to(beTrue());
                return [lockScreenStatusInfo isKindOfClass:[SDLLockScreenStatusInfo class]];
            }]]);

            SDLOnDriverDistraction *driverDistraction = [[SDLOnDriverDistraction alloc] init];
            driverDistraction.state = SDLDriverDistractionStateOn;
            [testManager updateDriverDistractionState:driverDistraction];
        });

        it(@"should update the driver distraction status and send a notification", ^{
            expect(testManager.driverDistracted).to(beTrue());
            OCMVerifyAllWithDelay(mockDispatcher, 0.5);
        });
    });
});

QuickSpecEnd
