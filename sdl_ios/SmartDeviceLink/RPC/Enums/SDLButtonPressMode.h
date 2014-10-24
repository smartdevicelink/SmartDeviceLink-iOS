//  SDLButtonPressMode.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLButtonPressMode : SDLEnum {}

+(SDLButtonPressMode*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLButtonPressMode*) LONG;
+(SDLButtonPressMode*) SHORT;

@end
