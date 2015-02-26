//  SDLImageResolution.m
//
//  

#import <SmartDeviceLink/SDLImageResolution.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLImageResolution

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setResolutionWidth:(NSNumber*) resolutionWidth {
    if (resolutionWidth != nil) {
        [store setObject:resolutionWidth forKey:NAMES_resolutionWidth];
    } else {
        [store removeObjectForKey:NAMES_resolutionWidth];
    }
}

-(NSNumber*) resolutionWidth {
    return [store objectForKey:NAMES_resolutionWidth];
}

-(void) setResolutionHeight:(NSNumber*) resolutionHeight {
    if (resolutionHeight != nil) {
        [store setObject:resolutionHeight forKey:NAMES_resolutionHeight];
    } else {
        [store removeObjectForKey:NAMES_resolutionHeight];
    }
}

-(NSNumber*) resolutionHeight {
    return [store objectForKey:NAMES_resolutionHeight];
}

@end
