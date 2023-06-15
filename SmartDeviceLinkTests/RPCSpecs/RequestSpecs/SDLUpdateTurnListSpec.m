//
//  SDLUpdateTurnListSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLUpdateTurnList.h"
#import "SDLTurn.h"
#import "SDLSoftButton.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLUpdateTurnListSpec)

SDLTurn* turn = [[SDLTurn alloc] init];
SDLSoftButton* button = [[SDLSoftButton alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLUpdateTurnList* testRequest = [[SDLUpdateTurnList alloc] init];
        
        testRequest.turnList = [@[turn] mutableCopy];
        testRequest.softButtons = [@[button] mutableCopy];
        
        expect(testRequest.turnList).to(equal([@[turn] mutableCopy]));
        expect(testRequest.softButtons).to(equal([@[button] mutableCopy]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameRequest:
                                                           @{SDLRPCParameterNameParameters:
                                                                 @{SDLRPCParameterNameTurnList:[@[turn] mutableCopy],
                                                                   SDLRPCParameterNameSoftButtons:[@[button] mutableCopy]},
                                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameUpdateTurnList}} mutableCopy];
        SDLUpdateTurnList* testRequest = [[SDLUpdateTurnList alloc] initWithDictionary:dict];
        
        expect(testRequest.turnList).to(equal([@[turn] mutableCopy]));
        expect(testRequest.softButtons).to(equal([@[button] mutableCopy]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLUpdateTurnList* testRequest = [[SDLUpdateTurnList alloc] init];
        
        expect(testRequest.turnList).to(beNil());
        expect(testRequest.softButtons).to(beNil());
    });
});

QuickSpecEnd
