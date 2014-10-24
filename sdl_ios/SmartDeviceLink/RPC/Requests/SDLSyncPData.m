//  SDLSyncPData.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLSyncPData.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLSyncPData

-(id) init {
    if (self = [super initWithName:NAMES_SyncPData]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

@end
