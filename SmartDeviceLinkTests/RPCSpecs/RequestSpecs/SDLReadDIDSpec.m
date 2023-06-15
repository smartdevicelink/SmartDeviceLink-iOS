//
//  SDLReadDIDSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLReadDID.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLReadDIDSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLReadDID* testRequest = [[SDLReadDID alloc] init];
        
        testRequest.ecuName = @33112;
        testRequest.didLocation = [@[@200, @201, @205] mutableCopy];
        
        expect(testRequest.ecuName).to(equal(@33112));
        expect(testRequest.didLocation).to(equal([@[@200, @201, @205] mutableCopy]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameRequest:
                                                           @{SDLRPCParameterNameParameters:
                                                                 @{SDLRPCParameterNameECUName:@33112,
                                                                   SDLRPCParameterNameDIDLocation:[@[@200, @201, @205] mutableCopy]},
                                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameEndAudioPassThru}} mutableCopy];
        SDLReadDID* testRequest = [[SDLReadDID alloc] initWithDictionary:dict];
        
        expect(testRequest.ecuName).to(equal(@33112));
        expect(testRequest.didLocation).to(equal([@[@200, @201, @205] mutableCopy]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLReadDID* testRequest = [[SDLReadDID alloc] init];
        
        expect(testRequest.ecuName).to(beNil());
        expect(testRequest.didLocation).to(beNil());
    });
});

QuickSpecEnd
