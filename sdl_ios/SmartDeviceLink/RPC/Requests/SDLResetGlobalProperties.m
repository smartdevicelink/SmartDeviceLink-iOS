//  SDLResetGlobalProperties.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLResetGlobalProperties.h>

#import <SmartDeviceLink/SDLNames.h>
#import <SmartDeviceLink/SDLGlobalProperty.h>

@implementation SDLResetGlobalProperties

-(id) init {
    if (self = [super initWithName:NAMES_ResetGlobalProperties]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setProperties:(NSMutableArray*) properties {
    if (properties != nil) {
        [parameters setObject:properties forKey:NAMES_properties];
    } else {
        [parameters removeObjectForKey:NAMES_properties];
    }
}

-(NSMutableArray*) properties {
    NSMutableArray* array = [parameters objectForKey:NAMES_properties];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLGlobalProperty.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString* enumString in array) {
            [newList addObject:[SDLGlobalProperty valueOf:enumString]];
        }
        return newList;
    }
}

@end
