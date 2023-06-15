//
//  SDLOnTouchEventSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLOnTouchEvent.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLTouchEvent.h"
#import "SDLTouchType.h"


QuickSpecBegin(SDLOnTouchEventSpec)

SDLTouchEvent* event = [[SDLTouchEvent alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnTouchEvent* testNotification = [[SDLOnTouchEvent alloc] init];
        
        testNotification.type = SDLTouchTypeBegin;
        testNotification.event = [@[event] mutableCopy];
        
        expect(testNotification.type).to(equal(SDLTouchTypeBegin));
        expect(testNotification.event).to(equal([@[event] mutableCopy]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameNotification:
                                           @{SDLRPCParameterNameParameters:
                                                 @{SDLRPCParameterNameType:SDLTouchTypeBegin,
                                                   SDLRPCParameterNameEvent:[@[event] mutableCopy]},
                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameOnTouchEvent}} mutableCopy];
        SDLOnTouchEvent* testNotification = [[SDLOnTouchEvent alloc] initWithDictionary:dict];
        
        expect(testNotification.type).to(equal(SDLTouchTypeBegin));
        expect(testNotification.event).to(equal([@[event] mutableCopy]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnTouchEvent* testNotification = [[SDLOnTouchEvent alloc] init];
        
        expect(testNotification.type).to(beNil());
        expect(testNotification.event).to(beNil());
    });
});

QuickSpecEnd
