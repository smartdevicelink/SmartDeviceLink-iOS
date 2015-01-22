//  SDLScrollableMessageResponse.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/**
 * Scrollable Message Response is sent, when SDLScrollableMessage has been called
 *
 * Since SmartDeviceLink 2.0
 */
@interface SDLScrollableMessageResponse : SDLRPCResponse {}

/**
 * @abstract Constructs a new SDLScrollableMessageResponse object
 */
-(id) init;
/**
 * @abstract Constructs a new SDLScrollableMessageResponse object indicated by the NSMutableDictionary
 * parameter
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
