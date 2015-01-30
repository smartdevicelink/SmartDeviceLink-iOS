//  SDLDeleteInteractionChoiceSet.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLDeleteInteractionChoiceSet.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLDeleteInteractionChoiceSet

-(id) init {
    if (self = [super initWithName:NAMES_DeleteInteractionChoiceSet]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setInteractionChoiceSetID:(NSNumber *)interactionChoiceSetID {
    [parameters setOrRemoveObject:interactionChoiceSetID forKey:NAMES_interactionChoiceSetID];
}

-(NSNumber*) interactionChoiceSetID {
    return [parameters objectForKey:NAMES_interactionChoiceSetID];
}

@end
