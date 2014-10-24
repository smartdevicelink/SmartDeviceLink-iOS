//  SDLSystemAction.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLSystemAction : SDLEnum {}

+(SDLSystemAction*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLSystemAction*) DEFAULT_ACTION;
+(SDLSystemAction*) STEAL_FOCUS;
+(SDLSystemAction*) KEEP_CONTEXT;

@end
