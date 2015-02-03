//  SDLMyKey.m
//
//  

#import <SmartDeviceLink/SDLMyKey.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLMyKey

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setE911Override:(SDLVehicleDataStatus*) e911Override {
    if (e911Override != nil) {
        [store setObject:e911Override forKey:NAMES_e911Override];
    } else {
        [store removeObjectForKey:NAMES_e911Override];
    }
}

-(SDLVehicleDataStatus*) e911Override {
    NSObject* obj = [store objectForKey:NAMES_e911Override];
    if ([obj isKindOfClass:SDLVehicleDataStatus.class]) {
        return (SDLVehicleDataStatus*)obj;
    } else {
        return [SDLVehicleDataStatus valueOf:(NSString*)obj];
    }
}

@end
