//  SDLChoice.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCMessage.h"

#import "SDLImage.h"

@interface SDLChoice : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* choiceID;
@property(strong) NSString* menuName;
@property(strong) NSMutableArray* vrCommands;
@property(strong) SDLImage* image;
@property(strong) NSString* secondaryText;
@property(strong) NSString* tertiaryText;
@property(strong) SDLImage* secondaryImage;

@end
