//  SDLTimerMode.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLTimerMode : SDLEnum {}

+(SDLTimerMode*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLTimerMode*) UP;
+(SDLTimerMode*) DOWN;
+(SDLTimerMode*) NONE;

@end
