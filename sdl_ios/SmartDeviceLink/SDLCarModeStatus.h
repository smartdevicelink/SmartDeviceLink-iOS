//  SDLCarModeStatus.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>
/** Describes the carmode the vehicle is in.
 * <b>Since</b> SmartDeviceLink 2.0
 */
@interface SDLCarModeStatus : SDLEnum {}

+(SDLCarModeStatus*) valueOf:(NSString*) value;
+(NSMutableArray*) values;
/** Provides carmode NORMAL to each module.
 */
+(SDLCarModeStatus*) NORMAL;

/** Provides carmode FACTORY to each module.
 */
+(SDLCarModeStatus*) FACTORY;

/** Provides carmode TRANSPORT to each module.
 */
+(SDLCarModeStatus*) TRANSPORT;

/** Provides carmode CRASH to each module.
 */
+(SDLCarModeStatus*) CRASH;

@end
