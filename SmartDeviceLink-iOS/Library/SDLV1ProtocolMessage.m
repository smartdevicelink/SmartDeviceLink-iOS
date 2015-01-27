//  SDLSmartDeviceLinkV1ProtocolMessage.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLV1ProtocolMessage.h"
#import "SDLJsonDecoder.h"

@implementation SDLV1ProtocolMessage

- (id)initWithHeader:(SDLProtocolHeader*)header andPayload:(NSData *)payload {
	if (self = [self init]) {
        self.header = header;
        self.payload = payload;
	}
	return self;
}

- (NSDictionary *)rpcDictionary {
    NSDictionary* rpcMessageAsDictionary = [[SDLJsonDecoder instance] decode:self.payload];
    return rpcMessageAsDictionary;
}

@end
