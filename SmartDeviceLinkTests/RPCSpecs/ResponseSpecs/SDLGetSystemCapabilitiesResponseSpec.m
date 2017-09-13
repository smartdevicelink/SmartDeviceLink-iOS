#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLGetSystemCapabilityResponse.h"

#import "SDLNames.h"
#import "SDLNavigationCapability.h"
#import "SDLSystemCapability.h"
#import "SDLSystemCapabilityType.h"

QuickSpecBegin(SDLGetSystemCapabilitiesResponseSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLGetSystemCapabilityResponse *testRequest = [[SDLGetSystemCapabilityResponse alloc] init];

        testRequest.systemCapability = [[SDLSystemCapability alloc] initWithNavigationCapability:[[SDLNavigationCapability alloc] initWithSendLocation:YES waypoints:NO]];

        expect(testRequest.systemCapability.systemCapabilityType).to(equal([SDLSystemCapabilityType NAVIGATION]));
        expect(testRequest.systemCapability.navigationCapability.sendLocationEnabled).to(equal(YES));
        expect(testRequest.systemCapability.navigationCapability.getWayPointsEnabled).to(equal(NO));
        expect(testRequest.systemCapability.phoneCapability).to(beNil());
    });
});

describe(@"Initialization tests", ^{
    it(@"Should get correctly when initialized with a dictionary", ^ {
        NSDictionary *dict = @{NAMES_response: @{
                                       NAMES_parameters: @{
                                               NAMES_systemCapability: @{NAMES_systemCapabilityType: @"NAVIGATION",
                                                                         NAMES_navigationCapability: @{NAMES_getWayPointsEnabled: @(NO),
                                                                                                       NAMES_sendLocationEnabled: @(YES)}}
                                               }
                                       }
                               };
        SDLGetSystemCapabilityResponse *testResponse = [[SDLGetSystemCapabilityResponse alloc] initWithDictionary:[dict mutableCopy]];

        expect(testResponse.systemCapability.systemCapabilityType).to(equal([SDLSystemCapabilityType NAVIGATION]));
        expect(testResponse.systemCapability.navigationCapability.sendLocationEnabled).to(equal(YES));
        expect(testResponse.systemCapability.navigationCapability.getWayPointsEnabled).to(equal(NO));
        expect(testResponse.systemCapability.phoneCapability).to(beNil());
    });

    it(@"Should return nil if not set", ^ {
        SDLGetSystemCapabilityResponse *testResponse = [[SDLGetSystemCapabilityResponse alloc] init];

        expect(testResponse.systemCapability).to(beNil());
    });
});


QuickSpecEnd
