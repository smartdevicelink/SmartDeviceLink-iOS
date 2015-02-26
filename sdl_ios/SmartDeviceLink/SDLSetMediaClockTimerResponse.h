//  SDLSetMediaClockTimerResponse.h
//
// 

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/**
 * Set Media Clock Timer Response is sent, when SDLSetMediaClockTimer has been called
 *
 * Since SmartDeviceLink 1.0
 */
@interface SDLSetMediaClockTimerResponse : SDLRPCResponse {}

/**
 * @abstract Constructs a new SDLSetMediaClockTimerResponse object
 */
-(id) init;
/**
 * @abstract Constructs a new SDLSetMediaClockTimerResponse object indicated by the NSMutableDictionary
 * parameter
 * <p>
 *
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
