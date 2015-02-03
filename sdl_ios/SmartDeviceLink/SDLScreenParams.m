//  SDLScreenParams.m
//
//  

#import <SmartDeviceLink/SDLScreenParams.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLScreenParams

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setResolution:(SDLImageResolution*) resolution {
    if (resolution != nil) {
        [store setObject:resolution forKey:NAMES_resolution];
    } else {
        [store removeObjectForKey:NAMES_resolution];
    }
}

-(SDLImageResolution*) resolution {
    NSObject* obj = [store objectForKey:NAMES_resolution];
    if ([obj isKindOfClass:SDLImageResolution.class]) {
        return (SDLImageResolution*)obj;
    } else {
        return [[SDLImageResolution alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

-(void) setTouchEventAvailable:(SDLTouchEventCapabilities*) touchEventAvailable {
    if (touchEventAvailable != nil) {
        [store setObject:touchEventAvailable forKey:NAMES_touchEventAvailable];
    } else {
        [store removeObjectForKey:NAMES_touchEventAvailable];
    }
}

-(SDLTouchEventCapabilities*) touchEventAvailable {
    NSObject* obj = [store objectForKey:NAMES_touchEventAvailable];
    if ([obj isKindOfClass:SDLTouchEventCapabilities.class]) {
        return (SDLTouchEventCapabilities*)obj;
    } else {
        return [[SDLTouchEventCapabilities alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

@end
