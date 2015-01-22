//  SDLAlertResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLAlertResponse.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLAlertResponse

-(id) init {
    if (self = [super initWithName:NAMES_Alert]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setTryAgainTime:(NSNumber *)tryAgainTime {
    [parameters setOrRemoveObject:tryAgainTime forKey:NAMES_tryAgainTime];
}

-(NSNumber*) tryAgainTime {
    return [parameters objectForKey:NAMES_tryAgainTime];
}

@end
