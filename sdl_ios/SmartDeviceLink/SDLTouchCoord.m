//  SDLTouchCoord.m
//
//  

#import <SmartDeviceLink/SDLTouchCoord.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLTouchCoord

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setX:(NSNumber*) x {
    if (x != nil) {
        [store setObject:x forKey:NAMES_x];
    } else {
        [store removeObjectForKey:NAMES_x];
    }
}

-(NSNumber*) x {
    return [store objectForKey:NAMES_x];
}

-(void) setY:(NSNumber*) y {
    if (y != nil) {
        [store setObject:y forKey:NAMES_y];
    } else {
        [store removeObjectForKey:NAMES_y];
    }
}

-(NSNumber*) y {
    return [store objectForKey:NAMES_y];
}

@end
