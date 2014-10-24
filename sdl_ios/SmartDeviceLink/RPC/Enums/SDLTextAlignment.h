//  SDLTextAlignment.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLTextAlignment : SDLEnum {}

+(SDLTextAlignment*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLTextAlignment*) LEFT_ALIGNED;
+(SDLTextAlignment*) RIGHT_ALIGNED;
+(SDLTextAlignment*) CENTERED;

@end
