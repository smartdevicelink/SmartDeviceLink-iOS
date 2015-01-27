//  SDLOnSyncPData.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCNotification.h"

@interface SDLOnSyncPData : SDLRPCNotification {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSString* URL;
@property(strong) NSNumber* Timeout;

@end
