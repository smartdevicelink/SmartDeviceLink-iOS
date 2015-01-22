//  SDLUpdateTurnList.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLUpdateTurnList.h>

#import <SmartDeviceLink/SDLNames.h>
#import <SmartDeviceLink/SDLTurn.h>
#import <SmartDeviceLink/SDLSoftButton.h>

@implementation SDLUpdateTurnList

-(id) init {
    if (self = [super initWithName:NAMES_UpdateTurnList]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setTurnList:(NSMutableArray *)turnList {
    [parameters setOrRemoveObject:turnList forKey:NAMES_turnList];
}

-(NSMutableArray*) turnList {
    NSMutableArray* array = [parameters objectForKey:NAMES_turnList];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTurn.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary* dict in array) {
            [newList addObject:[[SDLTurn alloc] initWithDictionary:(NSMutableDictionary*)dict]];
        }
        return newList;
    }
}

- (void)setSoftButtons:(NSMutableArray *)softButtons {
    [parameters setOrRemoveObject:softButtons forKey:NAMES_softButtons];
}

-(NSMutableArray*) softButtons {
    NSMutableArray* array = [parameters objectForKey:NAMES_softButtons];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLSoftButton.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary* dict in array) {
            [newList addObject:[[SDLSoftButton alloc] initWithDictionary:(NSMutableDictionary*)dict]];
        }
        return newList;
    }
}

@end
