//  SDLSystemRequest.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLSystemRequest.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLSystemRequest

-(id) init {
    if (self = [super initWithName:NAMES_SystemRequest]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setRequestType:(SDLRequestType*) requestType {
    if (requestType != nil) {
        [parameters setObject:requestType forKey:NAMES_requestType];
    } else {
        [parameters removeObjectForKey:NAMES_requestType];
    }
}

-(SDLRequestType*) requestType {
    NSObject* obj = [parameters objectForKey:NAMES_requestType];
    if ([obj isKindOfClass:SDLRequestType.class]) {
        return (SDLRequestType*)obj;
    } else {
        return [SDLRequestType valueOf:(NSString*)obj];
    }
}

-(void) setFileName:(NSString*) fileName {
    if (fileName != nil) {
        [parameters setObject:fileName forKey:NAMES_fileName];
    } else {
        [parameters removeObjectForKey:NAMES_fileName];
    }
}

-(NSString*) fileName {
    return [parameters objectForKey:NAMES_fileName];
}

@end
