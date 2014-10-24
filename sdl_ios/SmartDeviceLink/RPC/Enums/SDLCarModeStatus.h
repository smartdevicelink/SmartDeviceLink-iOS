//  SDLCarModeStatus.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLCarModeStatus : SDLEnum {}

+(SDLCarModeStatus*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLCarModeStatus*) NORMAL;
+(SDLCarModeStatus*) FACTORY;
+(SDLCarModeStatus*) TRANSPORT;
+(SDLCarModeStatus*) CRASH;

@end
