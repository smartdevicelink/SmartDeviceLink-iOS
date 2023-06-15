//
//  SDLDiagnosticMessageResponseSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLDiagnosticMessageResponse.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLDiagnosticMessageResponseSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLDiagnosticMessageResponse* testResponse = [[SDLDiagnosticMessageResponse alloc] init];
        
        testResponse.messageDataResult = @[@3, @9, @27, @81];
        
        expect(testResponse.messageDataResult).to(equal(@[@3, @9, @27, @81]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameResponse:
                                                           @{SDLRPCParameterNameParameters:
                                                                 @{SDLRPCParameterNameMessageDataResult:@[@3, @9, @27, @81]},
                                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameDiagnosticMessage}} mutableCopy];
        SDLDiagnosticMessageResponse* testResponse = [[SDLDiagnosticMessageResponse alloc] initWithDictionary:dict];
        
        expect(testResponse.messageDataResult).to(equal(@[@3, @9, @27, @81]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLDiagnosticMessageResponse* testResponse = [[SDLDiagnosticMessageResponse alloc] init];
        
        expect(testResponse.messageDataResult).to(beNil());
    });
});

QuickSpecEnd
