//  SDLDeleteInteractionChoiceSetResponse.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/**
 * SDLDeleteInteractionChoiceSetResponse is sent, when SDLDeleteInteractionChoiceSet has been called
 *
 * Since <b>SmartDeviceLink 1.0</b>
 */
@interface SDLDeleteInteractionChoiceSetResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
