//  SDLGetDTCs.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCRequest.h>

/**
 * This RPC allows to request diagnostic module trouble codes from a certain
 * vehicle module
 * <p>
 * Function Group: ProprietaryData
 * <p>
 * <b>HMILevel needs to be FULL, LIMITED or BACKGROUND</b>
 * <p>
 */
@interface SDLGetDTCs : SDLRPCRequest {}

/**
 * Constructs a new SDLGetDTCs object
 */
-(id) init;
/**
 * Constructs a new SDLGetDTCs object indicated by the NSMutableDictionary parameter
 * <p>
 *
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

/**
 * @abstract a name of the module to receive the DTC form
 * @discussion an NSNumber value representing a name of the module to receive
 *            the DTC form
 *            <p>
 *            <b>Notes: </b>Minvalue:0; Maxvalue:65535
 */
@property(strong) NSNumber* ecuName;
/**
 * @abstract  DTC Mask Byte to be sent in diagnostic request to module. NSNumber* dtcMask Minvalue:0; Maxvalue:255
 */
@property(strong) NSNumber* dtcMask;

@end
