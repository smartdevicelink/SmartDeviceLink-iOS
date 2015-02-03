//  SDLShowConstantTBTResponse.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/** SDLShowConstantTBTResponse is sent, when SDLShowConstantTBT has been called.
 * Since<b>SmartDeviceLink 2.0</b>
 */
@interface SDLShowConstantTBTResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
