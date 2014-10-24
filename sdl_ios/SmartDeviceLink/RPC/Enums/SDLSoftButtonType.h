//  SDLSoftButtonType.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLSoftButtonType : SDLEnum {}

+(SDLSoftButtonType*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLSoftButtonType*) TEXT;
+(SDLSoftButtonType*) IMAGE;
+(SDLSoftButtonType*) BOTH;

@end
