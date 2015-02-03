//  SDLSystemAction.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

/**
 *
 * Enumeration that describes system actions that can be triggered.
 */
@interface SDLSystemAction : SDLEnum {}

/**
 * Convert String to SDLSystemAction
 * @param value String
 * @return SDLSystemAction
 */
+(SDLSystemAction*) valueOf:(NSString*) value;
/*!
 @abstract Store the enumeration of all possible SDLSystemAction
 @result return an array that store all possible SDLSystemAction
 */
+(NSMutableArray*) values;

/*!
 @abstract Default_Action
 */
+(SDLSystemAction*) DEFAULT_ACTION;
/*!
 @abstract Steal_Focus
 */
+(SDLSystemAction*) STEAL_FOCUS;
/*!
 @abstract Keep_Context
 */
+(SDLSystemAction*) KEEP_CONTEXT;

@end
