//  SDLAudioPassThruCapabilities.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

#import <SmartDeviceLink/SDLSamplingRate.h>
#import <SmartDeviceLink/SDLBitsPerSample.h>
#import <SmartDeviceLink/SDLAudioType.h>

/**
 * Describes different audio type configurations for SDLPerformAudioPassThru, e.g. {8kHz,8-bit,PCM}
 * <p><b>Parameter List</b>
 * <table border="1" rules="all">
 * 		<tr>
 * 			<th>Name</th>
 * 			<th>Type</th>
 * 			<th>Description</th>
 * 			<th>SmartDeviceLink Ver. Available</th>
 * 		</tr>
 * 		<tr>
 * 			<td>samplingRate</td>
 * 			<td>SDLSamplingRate * </td>
 * 			<td>Describes the sampling rate for AudioPassThru
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>bitsPerSample</td>
 * 			<td>SDLBitsPerSample * </td>
 * 			<td>Describes the sample depth in bit for AudioPassThru
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>audioType</td>
 * 			<td>SDLAudioType * </td>
 * 			<td>Describes the audiotype for AudioPassThru
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 *  </table>
 * Since <b>SmartDeviceLink 2.0</b>
 */
@interface SDLAudioPassThruCapabilities : SDLRPCStruct {}

/**
 * Constructs a newly allocated SDLAudioPassThruCapabilities object
 */
-(id) init;
/**
 * Constructs a newly allocated SDLAudioPassThruCapabilities object indicated by the Hashtable parameter
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

/**
 * @abstract The sampling rate for AudioPassThru<br>
 *
 */
@property(strong) SDLSamplingRate* samplingRate;
/**
 * @abstract The sample depth in bit for AudioPassThru<br>
 *
 */
@property(strong) SDLBitsPerSample* bitsPerSample;
/**
 * @abstract The audiotype for AudioPassThru<br>
 *
 */
@property(strong) SDLAudioType* audioType;

@end
