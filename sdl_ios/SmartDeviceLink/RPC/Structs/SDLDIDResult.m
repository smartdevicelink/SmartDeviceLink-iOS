//  SDLDIDResult.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLDIDResult.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLDIDResult

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setResultCode:(SDLVehicleDataResultCode*) resultCode {
    if (resultCode != nil) {
        [store setObject:resultCode forKey:NAMES_resultCode];
    } else {
        [store removeObjectForKey:NAMES_resultCode];
    }
}

-(SDLVehicleDataResultCode*) resultCode {
    NSObject* obj = [store objectForKey:NAMES_resultCode];
    if ([obj isKindOfClass:SDLVehicleDataResultCode.class]) {
        return (SDLVehicleDataResultCode*)obj;
    } else {
        return [SDLVehicleDataResultCode valueOf:(NSString*)obj];
    }
}

-(void) setDidLocation:(NSNumber*) didLocation {
    if (didLocation != nil) {
        [store setObject:didLocation forKey:NAMES_didLocation];
    } else {
        [store removeObjectForKey:NAMES_didLocation];
    }
}

-(NSNumber*) didLocation {
    return [store objectForKey:NAMES_didLocation];
}

-(void) setData:(NSString*) data {
    if (data != nil) {
        [store setObject:data forKey:NAMES_data];
    } else {
        [store removeObjectForKey:NAMES_data];
    }
}

-(NSString*) data {
    return [store objectForKey:NAMES_data];
}

@end
