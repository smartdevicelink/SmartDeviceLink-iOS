//  SDLScrollableMessage.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLScrollableMessage.h>

#import <SmartDeviceLink/SDLNames.h>
#import <SmartDeviceLink/SDLSoftButton.h>

@implementation SDLScrollableMessage

-(id) init {
    if (self = [super initWithName:NAMES_ScrollableMessage]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setScrollableMessageBody:(NSString *)scrollableMessageBody {
    [parameters setOrRemoveObject:scrollableMessageBody forKey:NAMES_scrollableMessageBody];
}

-(NSString*) scrollableMessageBody {
    return [parameters objectForKey:NAMES_scrollableMessageBody];
}

- (void)setTimeout:(NSNumber *)timeout {
    [parameters setOrRemoveObject:timeout forKey:NAMES_timeout];
}

-(NSNumber*) timeout {
    return [parameters objectForKey:NAMES_timeout];
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
