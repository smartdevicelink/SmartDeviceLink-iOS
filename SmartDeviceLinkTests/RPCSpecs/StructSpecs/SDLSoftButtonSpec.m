//
//  SDLSoftButtonSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLImage.h"
#import "SDLRPCParameterNames.h"
#import "SDLSoftButton.h"
#import "SDLSoftButtonType.h"
#import "SDLSystemAction.h"


QuickSpecBegin(SDLSoftButtonSpec)

SDLImage* image = [[SDLImage alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSoftButton* testStruct = [[SDLSoftButton alloc] init];
        
        testStruct.type = SDLSoftButtonTypeImage;
        testStruct.text = @"Button";
        testStruct.image = image;
        testStruct.isHighlighted = @YES;
        testStruct.softButtonID = @5423;
        testStruct.systemAction = SDLSystemActionKeepContext;
        
        expect(testStruct.type).to(equal(SDLSoftButtonTypeImage));
        expect(testStruct.text).to(equal(@"Button"));
        expect(testStruct.image).to(equal(image));
        expect(testStruct.isHighlighted).to(equal(@YES));
        expect(testStruct.softButtonID).to(equal(@5423));
        expect(testStruct.systemAction).to(equal(SDLSystemActionKeepContext));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameType:SDLSoftButtonTypeImage,
                                       SDLRPCParameterNameText:@"Button",
                                       SDLRPCParameterNameImage:image,
                                       SDLRPCParameterNameIsHighlighted:@YES,
                                       SDLRPCParameterNameSoftButtonId:@5423,
                                       SDLRPCParameterNameSystemAction:SDLSystemActionKeepContext} mutableCopy];
        SDLSoftButton* testStruct = [[SDLSoftButton alloc] initWithDictionary:dict];
        
        expect(testStruct.type).to(equal(SDLSoftButtonTypeImage));
        expect(testStruct.text).to(equal(@"Button"));
        expect(testStruct.image).to(equal(image));
        expect(testStruct.isHighlighted).to(equal(@YES));
        expect(testStruct.softButtonID).to(equal(@5423));
        expect(testStruct.systemAction).to(equal(SDLSystemActionKeepContext));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLSoftButton* testStruct = [[SDLSoftButton alloc] init];
        
        expect(testStruct.type).to(beNil());
        expect(testStruct.text).to(beNil());
        expect(testStruct.image).to(beNil());
        expect(testStruct.isHighlighted).to(beNil());
        expect(testStruct.softButtonID).to(beNil());
        expect(testStruct.systemAction).to(beNil());
    });
});

QuickSpecEnd
