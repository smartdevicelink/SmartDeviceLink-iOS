//
//  SDLSubscribeButtonSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLButtonName.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLSubscribeButton.h"


QuickSpecBegin(SDLSubscribeButtonSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSubscribeButton* testRequest = [[SDLSubscribeButton alloc] init];
        
        testRequest.buttonName = SDLButtonNamePreset5;
        
        expect(testRequest.buttonName).to(equal(SDLButtonNamePreset5));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameRequest:
                                           @{SDLRPCParameterNameParameters:
                                                 @{SDLRPCParameterNameButtonName:SDLButtonNamePreset5},
                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameSubscribeButton}} mutableCopy];
        SDLSubscribeButton* testRequest = [[SDLSubscribeButton alloc] initWithDictionary:dict];
        
        expect(testRequest.buttonName).to(equal(SDLButtonNamePreset5));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLSubscribeButton* testRequest = [[SDLSubscribeButton alloc] init];
        
        expect(testRequest.buttonName).to(beNil());
    });
});

QuickSpecEnd
