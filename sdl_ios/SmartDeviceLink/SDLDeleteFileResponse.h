//  SDLDeleteFileResponse.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/**
 * Delete File Response is sent, when DeleteFile has been called
 *
 * Since <b>SmartDeviceLink 2.0</b><br>
 */
@interface SDLDeleteFileResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* spaceAvailable;

@end
