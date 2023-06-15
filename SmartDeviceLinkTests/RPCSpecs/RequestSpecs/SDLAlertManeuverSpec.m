//
//  SDLAlertManeuverSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLAlertManeuver.h"
#import "SDLTTSChunk.h"
#import "SDLSoftButton.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLAlertManeuverSpec)

SDLTTSChunk* tts = [[SDLTTSChunk alloc] init];
SDLSoftButton* button = [[SDLSoftButton alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLAlertManeuver* testRequest = [[SDLAlertManeuver alloc] init];
        
        testRequest.ttsChunks = [@[tts] mutableCopy];
        testRequest.softButtons = [@[button] mutableCopy];
        
        expect(testRequest.ttsChunks).to(equal([@[tts] mutableCopy]));
        expect(testRequest.softButtons).to(equal([@[button] mutableCopy]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameRequest:
                                                           @{SDLRPCParameterNameParameters:
                                                                 @{SDLRPCParameterNameTTSChunks:[@[tts] mutableCopy],
                                                                   SDLRPCParameterNameSoftButtons:[@[button] mutableCopy]},
                                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameAlertManeuver}} mutableCopy];
        SDLAlertManeuver* testRequest = [[SDLAlertManeuver alloc] initWithDictionary:dict];
        
        expect(testRequest.ttsChunks).to(equal([@[tts] mutableCopy]));
        expect(testRequest.softButtons).to(equal([@[button] mutableCopy]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLAlertManeuver* testRequest = [[SDLAlertManeuver alloc] init];
        
        expect(testRequest.ttsChunks).to(beNil());
        expect(testRequest.softButtons).to(beNil());
    });
});

QuickSpecEnd
