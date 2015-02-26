//  SDLImageFieldName.h
//
//

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

/** The name that identifies the filed.
 *
 *
 * @since SmartDeviceLink 3.0
 *
 */
@interface SDLImageFieldName : SDLEnum {}

+(SDLImageFieldName*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

/** The image field for SoftButton
 *
 */
+(SDLImageFieldName*) softButtonImage;

/** The first image field for Choice.
 *
 */
+(SDLImageFieldName*) choiceImage;

/** The scondary image field for Choice.
 *
 */
+(SDLImageFieldName*) choiceSecondaryImage;

/** The image field for vrHelpItem.
 *
 */
+(SDLImageFieldName*) vrHelpItem;

/** The image field for Turn.
 *
 */

+(SDLImageFieldName*) turnIcon;

/** The image field for the menu icon in SetGlobalProperties.
 *
 */
+(SDLImageFieldName*) menuIcon;

/** The image filed for AddCommand.
 *
 */

+(SDLImageFieldName*) cmdIcon;

/** The iamage field for the app icon ( set by setAppIcon).
 *
 */
+(SDLImageFieldName*) appIcon;

/** The image filed for Show.
 *
 */
+(SDLImageFieldName*) graphic;

/** The primary image field for ShowConstant TBT.
 *
 */
+(SDLImageFieldName*) showConstantTBTIcon;

/** The secondary image field for ShowConstant TBT.
 *
 */
+(SDLImageFieldName*) showConstantTBTNextTurnIcon;

@end
