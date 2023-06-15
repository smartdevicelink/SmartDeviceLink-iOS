//
//  SDLRadioControlDataSpec.m
//  SmartDeviceLink-iOS
//

#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLRadioControlData.h"
#import "SDLRadioBand.h"
#import "SDLRadioState.h"
#import "SDLRDSData.h"
#import "SDLSISData.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLRadioControlDataSpec)
__block SDLRDSData *someRdsData = [[SDLRDSData alloc] init];
__block SDLSISData *testSISData = [[SDLSISData alloc] init];

describe(@"Initialization tests", ^{
    
    it(@"should properly initialize init", ^{
        SDLRadioControlData* testStruct = [[SDLRadioControlData alloc] init];

        expect(testStruct.frequencyInteger).to(beNil());
        expect(testStruct.frequencyFraction).to(beNil());
        expect(testStruct.band).to(beNil());
        expect(testStruct.rdsData).to(beNil());
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testStruct.availableHDs).to(beNil());
#pragma clang diagnostic pop
        expect(testStruct.availableHDChannels).to(beNil());
        expect(testStruct.hdChannel).to(beNil());
        expect(testStruct.signalStrength).to(beNil());
        expect(testStruct.signalChangeThreshold).to(beNil());
        expect(testStruct.radioEnable).to(beNil());
        expect(testStruct.state).to(beNil());
        expect(testStruct.hdRadioEnable).to(beNil());
        expect(testStruct.sisData).to(beNil());
    });
    
    it(@"should properly initialize initWithDictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameFrequencyInteger : @101,
                                       SDLRPCParameterNameFrequencyFraction : @7,
                                       SDLRPCParameterNameBand : SDLRadioBandAM,
                                       SDLRPCParameterNameRDSData : someRdsData,
                                       SDLRPCParameterNameAvailableHDs : @2,
                                       SDLRPCParameterNameAvailableHDChannels : @2,
                                       SDLRPCParameterNameHDChannel : @2,
                                       SDLRPCParameterNameSignalStrength : @54,
                                       SDLRPCParameterNameSignalChangeThreshold : @76,
                                       SDLRPCParameterNameRadioEnable : @YES,
                                       SDLRPCParameterNameState : SDLRadioStateNotFound,
                                       SDLRPCParameterNameHDRadioEnable : @NO,
                                       SDLRPCParameterNameSISData : testSISData
                                       };
        SDLRadioControlData *testStruct = [[SDLRadioControlData alloc] initWithDictionary:dict];

        expect(testStruct.frequencyInteger).to(equal(@101));
        expect(testStruct.frequencyFraction).to(equal(@7));
        expect(testStruct.band).to(equal(SDLRadioBandAM));
        expect(testStruct.rdsData).to(equal(someRdsData));
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testStruct.availableHDs).to(equal(@2));
#pragma clang diagnostic pop
        expect(testStruct.availableHDChannels).to(equal(@2));
        expect(testStruct.hdChannel).to(equal(@2));
        expect(testStruct.signalStrength).to(equal(@54));
        expect(testStruct.signalChangeThreshold).to(equal(@76));
        expect(testStruct.radioEnable).to(equal(@YES));
        expect(testStruct.state).to(equal(SDLRadioStateNotFound));
        expect(testStruct.hdRadioEnable).to(equal(@NO));
        expect(testStruct.sisData).to(equal(testSISData));
    });

    it(@"Should set and get correctly", ^{
        SDLRadioControlData* testStruct = [[SDLRadioControlData alloc] init];
        testStruct.frequencyInteger = @101;
        testStruct.frequencyFraction = @7;
        testStruct.band = SDLRadioBandAM;
        testStruct.rdsData = someRdsData;
        testStruct.availableHDs = @2;
        testStruct.availableHDChannels = @2;
        testStruct.hdChannel = @2;
        testStruct.signalStrength = @54;
        testStruct.signalChangeThreshold = @76;
        testStruct.radioEnable = @YES;
        testStruct.state = SDLRadioStateNotFound;
        testStruct.hdRadioEnable = @YES;
        testStruct.sisData = testSISData;

        expect(testStruct.frequencyInteger).to(equal(@101));
        expect(testStruct.frequencyFraction).to(equal(@7));
        expect(testStruct.band).to(equal(SDLRadioBandAM));
        expect(testStruct.rdsData).to(equal(someRdsData));
        expect(testStruct.availableHDs).to(equal(@2));
        expect(testStruct.availableHDChannels).to(equal(@2));
        expect(testStruct.hdChannel).to(equal(@2));
        expect(testStruct.signalStrength).to(equal(@54));
        expect(testStruct.signalChangeThreshold).to(equal(@76));
        expect(testStruct.radioEnable).to(equal(@YES));
        expect(testStruct.state).to(equal(SDLRadioStateNotFound));
        expect(testStruct.hdRadioEnable).to(equal(@YES));
        expect(testStruct.sisData).to(equal(testSISData));
    });
    
    it(@"Should get correctly when initialized with Module Name and other radio control capabilities parameters", ^ {
        SDLRadioControlData *testStruct = [[SDLRadioControlData alloc] initWithFrequencyInteger:@101 frequencyFraction:@7 band:SDLRadioBandAM hdChannel:@2 radioEnable:@YES hdRadioEnable:@YES];
        
        expect(testStruct.frequencyInteger).to(equal(@101));
        expect(testStruct.frequencyFraction).to(equal(@7));
        expect(testStruct.band).to(equal(SDLRadioBandAM));
        expect(testStruct.hdChannel).to(equal(@2));
        expect(testStruct.radioEnable).to(equal(@YES));
        expect(testStruct.hdRadioEnable).to(equal(@YES));
    });

    it(@"Should get correctly when initialized FM radio control capabilities parameters", ^ {
        SDLRadioControlData* testStruct = [[SDLRadioControlData alloc] initFMWithFrequencyInteger:@101 frequencyFraction:@7 hdChannel:@2];

        expect(testStruct.frequencyInteger).to(equal(@101));
        expect(testStruct.frequencyFraction).to(equal(@7));
        expect(testStruct.band).to(equal(SDLRadioBandFM));
        expect(testStruct.hdChannel).to(equal(@2));
    });

    it(@"Should get correctly when initialized AM radio control capabilities parameters", ^ {
        SDLRadioControlData* testStruct = [[SDLRadioControlData alloc] initAMWithFrequencyInteger:@101 hdChannel:@2];

        expect(testStruct.frequencyInteger).to(equal(@101));
        expect(testStruct.band).to(equal(SDLRadioBandAM));
        expect(testStruct.hdChannel).to(equal(@2));
    });

    it(@"Should get correctly when initialized XM radio control capabilities parameters", ^ {
        SDLRadioControlData* testStruct = [[SDLRadioControlData alloc] initXMWithFrequencyInteger:@101];

        expect(testStruct.frequencyInteger).to(equal(@101));
        expect(testStruct.band).to(equal(SDLRadioBandXM));
    });
});

QuickSpecEnd
