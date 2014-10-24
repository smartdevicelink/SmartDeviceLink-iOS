//  SDLSystemContext.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLSystemContext : SDLEnum {}

+(SDLSystemContext*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLSystemContext*) MAIN;
+(SDLSystemContext*) VRSESSION;
+(SDLSystemContext*) MENU;
+(SDLSystemContext*) HMI_OBSCURED;
+(SDLSystemContext*) ALERT;

@end
