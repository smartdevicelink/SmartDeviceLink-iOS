//
//  SDLDeleteInteractionChoiceSetSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLDeleteInteractionChoiceSet.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLDeleteInteractionChoiceSetSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLDeleteInteractionChoiceSet* testRequest = [[SDLDeleteInteractionChoiceSet alloc] init];
        
		testRequest.interactionChoiceSetID = @20314;

		expect(testRequest.interactionChoiceSetID).to(equal(@20314));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameRequest:
                                                           @{SDLRPCParameterNameParameters:
                                                                 @{SDLRPCParameterNameInteractionChoiceSetId:@20314},
                                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameDeleteInteractionChoiceSet}} mutableCopy];
        SDLDeleteInteractionChoiceSet* testRequest = [[SDLDeleteInteractionChoiceSet alloc] initWithDictionary:dict];
        
        expect(testRequest.interactionChoiceSetID).to(equal(@20314));
    });

    it(@"Should return nil if not set", ^ {
        SDLDeleteInteractionChoiceSet* testRequest = [[SDLDeleteInteractionChoiceSet alloc] init];
        
		expect(testRequest.interactionChoiceSetID).to(beNil());
	});
});

QuickSpecEnd
