//  SDLTTSChunkFactory.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLTTSChunkFactory.h>

@implementation SDLTTSChunkFactory

+ (SDLTTSChunk *)buildTTSChunkForString:(NSString *)text type:(SDLSpeechCapabilities *)type {
	SDLTTSChunk *ret = [[SDLTTSChunk alloc] init];
	ret.text = text;
	ret.type = type;
	
	return ret;
}

+ (NSMutableArray *)buildTTSChunksFromSimple:(NSString *)simple {
	if (simple == nil)
        return nil;
    
	return [NSMutableArray arrayWithObject:[SDLTTSChunkFactory buildTTSChunkForString:simple type:[SDLSpeechCapabilities TEXT]]];
}

@end
