//  SDLCreateInteractionChoiceSetResponse.h
//
// 

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/**
 * SDLCreateInteractionChoiceSetResponse is sent, when SDLCreateInteractionChoiceSet
 * has been called
 *
 * Since <b>SmartDeviceLink 1.0</b>
 */
@interface SDLCreateInteractionChoiceSetResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
