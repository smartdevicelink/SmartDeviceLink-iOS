//  SDLSyncMsgVersion.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLSyncMsgVersion.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLSyncMsgVersion

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setMajorVersion:(NSNumber*) majorVersion {
    [store setOrRemoveObject:majorVersion forKey:NAMES_majorVersion];
}

-(NSNumber*) majorVersion {
    return [store objectForKey:NAMES_majorVersion];
}

-(void) setMinorVersion:(NSNumber*) minorVersion {
    [store setOrRemoveObject:minorVersion forKey:NAMES_minorVersion];
}

-(NSNumber*) minorVersion {
    return [store objectForKey:NAMES_minorVersion];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@.%@", self.majorVersion, self.minorVersion];
}
@end
