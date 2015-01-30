//  SDLAlert.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLAlert.h>

#import <SmartDeviceLink/SDLNames.h>
#import <SmartDeviceLink/SDLTTSChunk.h>
#import <SmartDeviceLink/SDLSoftButton.h>

@implementation SDLAlert

-(id) init {
    if (self = [super initWithName:NAMES_Alert]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setAlertText1:(NSString *)alertText1 {
    [parameters setOrRemoveObject:alertText1 forKey:NAMES_alertText1];
}

-(NSString*) alertText1 {
    return [parameters objectForKey:NAMES_alertText1];
}

- (void)setAlertText2:(NSString *)alertText2 {
    [parameters setOrRemoveObject:alertText2 forKey:NAMES_alertText2];
}

-(NSString*) alertText2 {
    return [parameters objectForKey:NAMES_alertText2];
}

- (void)setAlertText3:(NSString *)alertText3 {
    [parameters setOrRemoveObject:alertText3 forKey:NAMES_alertText3];
}

-(NSString*) alertText3 {
    return [parameters objectForKey:NAMES_alertText3];
}

- (void)setTtsChunks:(NSMutableArray *)ttsChunks {
    [parameters setOrRemoveObject:ttsChunks forKey:NAMES_ttsChunks];
}

-(NSMutableArray*) ttsChunks {
    NSMutableArray* array = [parameters objectForKey:NAMES_ttsChunks];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTTSChunk.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary* dict in array) {
            [newList addObject:[[SDLTTSChunk alloc] initWithDictionary:(NSMutableDictionary*)dict]];
        }
        return newList;
    }
}

- (void)setDuration:(NSNumber *)duration {
    [parameters setOrRemoveObject:duration forKey:NAMES_duration];
}

-(NSNumber*) duration {
    return [parameters objectForKey:NAMES_duration];
}

- (void)setPlayTone:(NSNumber *)playTone {
    [parameters setOrRemoveObject:playTone forKey:NAMES_playTone];
}

-(NSNumber*) playTone {
    return [parameters objectForKey:NAMES_playTone];
}

- (void)setProgressIndicator:(NSNumber *)progressIndicator {
    [parameters setOrRemoveObject:progressIndicator forKey:NAMES_progressIndicator];
}

-(NSNumber*) progressIndicator {
    return [parameters objectForKey:NAMES_progressIndicator];
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
