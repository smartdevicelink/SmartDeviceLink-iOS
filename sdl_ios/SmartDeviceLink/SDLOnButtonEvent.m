//  SDLOnButtonEvent.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLOnButtonEvent.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLOnButtonEvent

-(id) init {
    if (self = [super initWithName:NAMES_OnButtonEvent]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setButtonName:(SDLButtonName *)buttonName {
    [parameters setOrRemoveObject:buttonName forKey:NAMES_buttonName];
}

-(SDLButtonName*) buttonName {
    NSObject* obj = [parameters objectForKey:NAMES_buttonName];
    if ([obj isKindOfClass:SDLButtonName.class]) {
        return (SDLButtonName*)obj;
    } else {
        return [SDLButtonName valueOf:(NSString*)obj];
    }
}

- (void)setButtonEventMode:(SDLButtonEventMode *)buttonEventMode {
    [parameters setOrRemoveObject:buttonEventMode forKey:NAMES_buttonEventMode];
}

-(SDLButtonEventMode*) buttonEventMode {
    NSObject* obj = [parameters objectForKey:NAMES_buttonEventMode];
    if ([obj isKindOfClass:SDLButtonEventMode.class]) {
        return (SDLButtonEventMode*)obj;
    } else {
        return [SDLButtonEventMode valueOf:(NSString*)obj];
    }
}

- (void)setCustomButtonID:(NSNumber *)customButtonID {
    [parameters setOrRemoveObject:customButtonID forKey:NAMES_customButtonID];
}

-(NSNumber*) customButtonID {
    return [parameters objectForKey:NAMES_customButtonID];
}

@end
