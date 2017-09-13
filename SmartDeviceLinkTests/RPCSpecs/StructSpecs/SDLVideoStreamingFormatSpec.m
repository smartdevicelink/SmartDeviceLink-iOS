//
//  SDLVideoStreamingFormatSpec.m
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 7/28/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLNames.h"
#import "SDLVideoStreamingCodec.h"
#import "SDLVideoStreamingFormat.h"
#import "SDLVideoStreamingProtocol.h"

QuickSpecBegin(SDLVideoStreamingFormatSpec)

describe(@"Initialization tests", ^{
    it(@"Should get correctly when initialized with a dictionary", ^ {
        NSMutableDictionary* dict = [@{NAMES_videoProtocol: [SDLVideoStreamingProtocol RAW],
                                       NAMES_videoCodec: [SDLVideoStreamingCodec H264]} mutableCopy];
        SDLVideoStreamingFormat* testStruct = [[SDLVideoStreamingFormat alloc] initWithDictionary:dict];

        expect(testStruct.protocol).to(equal([SDLVideoStreamingProtocol RAW]));
        expect(testStruct.codec).to(equal([SDLVideoStreamingCodec H264]));
    });

    it(@"Should return nil if not set", ^ {
        SDLVideoStreamingFormat* testStruct = [[SDLVideoStreamingFormat alloc] init];

        expect(testStruct.protocol).to(beNil());
        expect(testStruct.codec).to(beNil());
    });
});

QuickSpecEnd
