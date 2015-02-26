//  SDLOnSyncPData.m
//
//  

#import <SmartDeviceLink/SDLOnSyncPData.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLOnSyncPData

-(id) init {
    if (self = [super initWithName:NAMES_OnSyncPData]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setURL:(NSString*) URL {
    if (URL != nil) {
        [parameters setObject:URL forKey:NAMES_URL];
    } else {
        [parameters removeObjectForKey:NAMES_URL];
    }
}

-(NSString*) URL {
    return [parameters objectForKey:NAMES_URL];
}

-(void) setTimeout:(NSNumber*) Timeout {
    if (Timeout != nil) {
        [parameters setObject:Timeout forKey:NAMES_Timeout];
    } else {
        [parameters removeObjectForKey:NAMES_Timeout];
    }
}

-(NSNumber*) Timeout {
    return [parameters objectForKey:NAMES_Timeout];
}

@end
