//  SDLAlertManeuverResponse.m
//
//  

#import <SmartDeviceLink/SDLAlertManeuverResponse.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLAlertManeuverResponse

-(id) init {
    if (self = [super initWithName:NAMES_AlertManeuver]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

@end
