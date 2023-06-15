//
//  SDLHeadLampStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLAmbientLightStatus.h"
#import "SDLHeadLampStatus.h"
#import "SDLRPCParameterNames.h"


QuickSpecBegin(SDLHeadLampStatusSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLHeadLampStatus* testStruct = [[SDLHeadLampStatus alloc] init];
        
        testStruct.lowBeamsOn = @YES;
        testStruct.highBeamsOn = @NO;
        testStruct.ambientLightSensorStatus = SDLAmbientLightStatusTwilight3;
        
        expect(testStruct.lowBeamsOn).to(equal(@YES));
        expect(testStruct.highBeamsOn).to(equal(@NO));
        expect(testStruct.ambientLightSensorStatus).to(equal(SDLAmbientLightStatusTwilight3));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameLowBeamsOn:@YES,
                                       SDLRPCParameterNameHighBeamsOn:@NO,
                                       SDLRPCParameterNameAmbientLightSensorStatus:SDLAmbientLightStatusTwilight3} mutableCopy];
        SDLHeadLampStatus* testStruct = [[SDLHeadLampStatus alloc] initWithDictionary:dict];
        
        expect(testStruct.lowBeamsOn).to(equal(@YES));
        expect(testStruct.highBeamsOn).to(equal(@NO));
        expect(testStruct.ambientLightSensorStatus).to(equal(SDLAmbientLightStatusTwilight3));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLHeadLampStatus* testStruct = [[SDLHeadLampStatus alloc] init];
        
        expect(testStruct.lowBeamsOn).to(beNil());
        expect(testStruct.highBeamsOn).to(beNil());
        expect(testStruct.ambientLightSensorStatus).to(beNil());
    });
});

QuickSpecEnd
