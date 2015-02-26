//  SDLUpdateTurnListResponse.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/** SDLUpdateTurnListResponse is sent, when SDLUpdateTurnList has been called.
 * Since<b>SmartDeviceLink 2.0</b>
 */
@interface SDLUpdateTurnListResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
