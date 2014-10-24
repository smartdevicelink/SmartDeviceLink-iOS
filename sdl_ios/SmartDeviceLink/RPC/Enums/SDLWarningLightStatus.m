//  SDLWarningLightStatus.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLWarningLightStatus.h>

SDLWarningLightStatus* SDLWarningLightStatus_OFF = nil;
SDLWarningLightStatus* SDLWarningLightStatus_ON = nil;
SDLWarningLightStatus* SDLWarningLightStatus_FLASH = nil;
SDLWarningLightStatus* SDLWarningLightStatus_NOT_USED = nil;

NSMutableArray* SDLWarningLightStatus_values = nil;

@implementation SDLWarningLightStatus

+(SDLWarningLightStatus*) valueOf:(NSString*) value {
    for (SDLWarningLightStatus* item in SDLWarningLightStatus.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+(NSMutableArray*) values {
    if (SDLWarningLightStatus_values == nil) {
        SDLWarningLightStatus_values = [[NSMutableArray alloc] initWithObjects:
                SDLWarningLightStatus.OFF,
                SDLWarningLightStatus.ON,
                SDLWarningLightStatus.FLASH,
                SDLWarningLightStatus.NOT_USED,
                nil];
    }
    return SDLWarningLightStatus_values;
}

+(SDLWarningLightStatus*) OFF {
    if (SDLWarningLightStatus_OFF == nil) {
        SDLWarningLightStatus_OFF = [[SDLWarningLightStatus alloc] initWithValue:@"OFF"];
    }
    return SDLWarningLightStatus_OFF;
}

+(SDLWarningLightStatus*) ON {
    if (SDLWarningLightStatus_ON == nil) {
        SDLWarningLightStatus_ON = [[SDLWarningLightStatus alloc] initWithValue:@"ON"];
    }
    return SDLWarningLightStatus_ON;
}

+(SDLWarningLightStatus*) FLASH {
    if (SDLWarningLightStatus_FLASH == nil) {
        SDLWarningLightStatus_FLASH = [[SDLWarningLightStatus alloc] initWithValue:@"FLASH"];
    }
    return SDLWarningLightStatus_FLASH;
}

+(SDLWarningLightStatus*) NOT_USED {
    if (SDLWarningLightStatus_NOT_USED == nil) {
        SDLWarningLightStatus_NOT_USED = [[SDLWarningLightStatus alloc] initWithValue:@"NOT_USED"];
    }
    return SDLWarningLightStatus_NOT_USED;
}

@end
