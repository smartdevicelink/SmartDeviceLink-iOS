//
//  SDLIAPControlSessionSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 4/16/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

@import Quick;
@import Nimble;
@import OCMock;

#import "SDLIAPControlSession.h"

#import "EAAccessory+OCMock.h"
#import "SDLIAPConstants.h"
#import "SDLIAPControlSessionDelegate.h"
#import "SDLIAPSession.h"
#import "SDLTimer.h"


@interface SDLIAPControlSession()
@property (nullable, strong, nonatomic) SDLTimer *protocolIndexTimer;
@property (weak, nonatomic) id<SDLIAPControlSessionDelegate> delegate;
@end

QuickSpecBegin(SDLIAPControlSessionSpec)

describe(@"SDLIAPControlSession", ^{
    __block SDLIAPControlSession *controlSession = nil;
    __block EAAccessory *mockAccessory = nil;
    __block id<SDLIAPControlSessionDelegate> mockDelegate = nil;

    beforeEach(^{
        mockDelegate = OCMProtocolMock(@protocol(SDLIAPControlSessionDelegate));
        mockAccessory = [EAAccessory.class sdlCoreMock];
    });

    describe(@"init", ^{
        beforeEach(^{
            controlSession = [[SDLIAPControlSession alloc] initWithAccessory:mockAccessory delegate:mockDelegate forProtocol:ControlProtocolString];
        });
        
        it(@"Should init correctly", ^{
            expect(controlSession.accessory).to(equal(mockAccessory));
            expect(controlSession.delegate).to(equal(mockDelegate));
            expect(controlSession.isSessionInProgress).to(beFalse());
        });
    });

});

QuickSpecEnd
