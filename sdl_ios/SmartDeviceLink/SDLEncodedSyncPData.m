//  SDLEncodedSyncPData.m
//
//  

#import <SmartDeviceLink/SDLEncodedSyncPData.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLEncodedSyncPData

-(id) init {
    if (self = [super initWithName:NAMES_EncodedSyncPData]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setData:(NSMutableArray*) data {
    if (data != nil) {
        [parameters setObject:data forKey:NAMES_data];
    } else {
        [parameters removeObjectForKey:NAMES_data];
    }
}

-(NSMutableArray*) data {
    return [parameters objectForKey:NAMES_data];
}

@end
