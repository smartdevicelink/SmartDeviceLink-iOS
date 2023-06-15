//
//  SDLButtonPressSpec.m
//  SmartDeviceLink-iOS
//

#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLButtonPress.h"
#import "SDLModuleType.h"
#import "SDLButtonName.h"
#import "SDLButtonPressMode.h"

QuickSpecBegin(SDLButtonPressSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLButtonPress* testRequest = [[SDLButtonPress alloc] init];
        
        testRequest.moduleType = SDLModuleTypeClimate;
        testRequest.moduleId = @"123";
        testRequest.buttonName = SDLButtonNameAC;
        testRequest.buttonPressMode = SDLButtonPressModeShort;
        
        expect(testRequest.moduleType).to(equal(SDLModuleTypeClimate));
        expect(testRequest.moduleId).to(equal(@"123"));
        expect(testRequest.buttonName).to(equal(SDLButtonNameAC));
        expect(testRequest.buttonPressMode).to(equal(SDLButtonPressModeShort));
    });
    
    it(@"Should get correctly when initialized with a dictionary", ^ {
        NSDictionary *dict = @{SDLRPCParameterNameRequest:
                                   @{SDLRPCParameterNameParameters:
                                         @{SDLRPCParameterNameModuleType : SDLModuleTypeClimate,
                                           SDLRPCParameterNameButtonName : SDLButtonNameAC,
                                           SDLRPCParameterNameButtonPressMode : SDLButtonPressModeShort,
                                           SDLRPCParameterNameModuleId:@"123"
                                         },
                                     SDLRPCParameterNameOperationName:SDLRPCFunctionNameButtonPress}};
        SDLButtonPress *testRequest = [[SDLButtonPress alloc] initWithDictionary:dict];

        expect(testRequest.moduleType).to(equal(SDLModuleTypeClimate));
        expect(testRequest.moduleId).to(equal(@"123"));
        expect(testRequest.buttonName).to(equal(SDLButtonNameAC));
        expect(testRequest.buttonPressMode).to(equal(SDLButtonPressModeShort));
    });

    it(@"Should get correctly when initialized with initWithButtonName:moduleType:moduleId:buttonPressMode:", ^ {
        SDLButtonPress *testRequest = [[SDLButtonPress alloc] initWithButtonName:SDLButtonNameAC moduleType:SDLModuleTypeClimate moduleId:@"123" buttonPressMode:SDLButtonPressModeShort];

        expect(testRequest.buttonName).to(equal(SDLButtonNameAC));
        expect(testRequest.moduleType).to(equal(SDLModuleTypeClimate));
        expect(testRequest.moduleId).to(equal(@"123"));
        expect(testRequest.buttonPressMode).to(equal(SDLButtonPressModeShort));
    });

    it(@"Should return nil if not set", ^ {
        SDLButtonPress* testRequest = [[SDLButtonPress alloc] init];
        
        expect(testRequest.moduleType).to(beNil());
        expect(testRequest.moduleId).to(beNil());
        expect(testRequest.buttonName).to(beNil());
        expect(testRequest.buttonPressMode).to(beNil());
    });
});

QuickSpecEnd
