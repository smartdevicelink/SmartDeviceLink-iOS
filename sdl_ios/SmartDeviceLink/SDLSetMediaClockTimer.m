//  SDLSetMediaClockTimer.m
//
//  

#import <SmartDeviceLink/SDLSetMediaClockTimer.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLSetMediaClockTimer

-(id) init {
    if (self = [super initWithName:NAMES_SetMediaClockTimer]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setStartTime:(SDLStartTime*) startTime {
    if (startTime != nil) {
        [parameters setObject:startTime forKey:NAMES_startTime];
    } else {
        [parameters removeObjectForKey:NAMES_startTime];
    }
}

-(SDLStartTime*) startTime {
    NSObject* obj = [parameters objectForKey:NAMES_startTime];
    if ([obj isKindOfClass:SDLStartTime.class]) {
        return (SDLStartTime*)obj;
    } else {
        return [[SDLStartTime alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

-(void) setEndTime:(SDLStartTime*) endTime {
    if (endTime != nil) {
        [parameters setObject:endTime forKey:NAMES_endTime];
    } else {
        [parameters removeObjectForKey:NAMES_endTime];
    }
}

-(SDLStartTime*) endTime {
    NSObject* obj = [parameters objectForKey:NAMES_endTime];
    if ([obj isKindOfClass:SDLStartTime.class]) {
        return (SDLStartTime*)obj;
    } else {
        return [[SDLStartTime alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

-(void) setUpdateMode:(SDLUpdateMode*) updateMode {
    if (updateMode != nil) {
        [parameters setObject:updateMode forKey:NAMES_updateMode];
    } else {
        [parameters removeObjectForKey:NAMES_updateMode];
    }
}

-(SDLUpdateMode*) updateMode {
    NSObject* obj = [parameters objectForKey:NAMES_updateMode];
    if ([obj isKindOfClass:SDLUpdateMode.class]) {
        return (SDLUpdateMode*)obj;
    } else {
        return [SDLUpdateMode valueOf:(NSString*)obj];
    }
}

@end
