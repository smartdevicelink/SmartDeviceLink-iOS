//  SDLDeleteFile.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLDeleteFile.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLDeleteFile

-(id) init {
    if (self = [super initWithName:NAMES_DeleteFile]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setSyncFileName:(NSString *)syncFileName {
    [parameters setOrRemoveObject:syncFileName forKey:NAMES_syncFileName];
}

-(NSString*) syncFileName {
    return [parameters objectForKey:NAMES_syncFileName];
}

@end
