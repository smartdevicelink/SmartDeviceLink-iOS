//  SDLIgnitionStatus.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLIgnitionStatus : SDLEnum {}

+(SDLIgnitionStatus*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLIgnitionStatus*) UNKNOWN;
+(SDLIgnitionStatus*) OFF;
+(SDLIgnitionStatus*) ACCESSORY;
+(SDLIgnitionStatus*) RUN;
+(SDLIgnitionStatus*) START;
+(SDLIgnitionStatus*) INVALID;

@end
