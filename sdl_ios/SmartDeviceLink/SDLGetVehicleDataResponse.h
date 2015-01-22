//  SDLGetVehicleDataResponse.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

#import <SmartDeviceLink/SDLGPSData.h>
#import <SmartDeviceLink/SDLComponentVolumeStatus.h>
#import <SmartDeviceLink/SDLPRNDL.h>
#import <SmartDeviceLink/SDLTireStatus.h>
#import <SmartDeviceLink/SDLBeltStatus.h>
#import <SmartDeviceLink/SDLBodyInformation.h>
#import <SmartDeviceLink/SDLDeviceStatus.h>
#import <SmartDeviceLink/SDLVehicleDataEventStatus.h>
#import <SmartDeviceLink/SDLWiperStatus.h>
#import <SmartDeviceLink/SDLHeadLampStatus.h>
#import <SmartDeviceLink/SDLECallInfo.h>
#import <SmartDeviceLink/SDLAirbagStatus.h>
#import <SmartDeviceLink/SDLEmergencyEvent.h>
#import <SmartDeviceLink/SDLClusterModeStatus.h>
#import <SmartDeviceLink/SDLMyKey.h>

/**
 * Get Vehicle Data Response is sent, when SDLGetVehicleData has been called
 *
 * Since SmartDeviceLink 2.0
 */
@interface SDLGetVehicleDataResponse : SDLRPCResponse {}


/**
 * @abstract Constructs a new SDLGetVehicleDataResponse object
 */
-(id) init;

/**
 * @abstract Constructs a new SDLGetVehicleDataResponse object indicated by the NSMutableDictionary
 * parameter
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;


/**
 * @abstract A SDLGPSData* value. See GPSData.
 */
@property(strong) SDLGPSData* gps;

/**
 * @abstract The vehicle speed in kilometers per hour.
 */
@property(strong) NSNumber* speed;

/**
 * @abstract The number of revolutions per minute of the engine.
 */
@property(strong) NSNumber* rpm;

/**
 * @abstract The fuel level in the tank (percentage)
 */
@property(strong) NSNumber* fuelLevel;

/**
 * @abstract A SDLComponentVolumeStatus* value. The fuel level state.
 */
@property(strong) SDLComponentVolumeStatus* fuelLevel_State;

/**
 * @abstract The instantaneous fuel consumption in microlitres.
 */
@property(strong) NSNumber* instantFuelConsumption;

/**
 * @abstract The external temperature in degrees celsius.
 */
@property(strong) NSNumber* externalTemperature;

/**
 * @abstract The Vehicle Identification Number
 */
@property(strong) NSString* vin;

/**
 * @abstract See PRNDL.
 */
@property(strong) SDLPRNDL* prndl;

/**
 * @abstract A SDLTireStatus* value. See TireStatus.
 */
@property(strong) SDLTireStatus* tirePressure;

/**
 * @abstract Odometer reading in km.
 */
@property(strong) NSNumber* odometer;

/**
 * @abstract A SDLBeltStatus* value. The status of the seat belts.
 */
@property(strong) SDLBeltStatus* beltStatus;

/**
 * @abstract A SDLBodyInformation* value. The body information including power modes.
 */
@property(strong) SDLBodyInformation* bodyInformation;

/**
 * @abstract A SDLDeviceStatus* value. The device status including signal and battery strength.
 */
@property(strong) SDLDeviceStatus* deviceStatus;

/**
 * @abstract A SDLVehicleDataResult* value. The status of the brake pedal.
 */
@property(strong) SDLVehicleDataEventStatus* driverBraking;

/**
 * @abstract A SDLWiperStatus* value. The status of the wipers.
 */
@property(strong) SDLWiperStatus* wiperStatus;

/**
 * @abstract A SDLHeadLampStatus* value. Status of the head lamps.
 */
@property(strong) SDLHeadLampStatus* headLampStatus;

/**
 * @abstract Torque value for engine (in Nm) on non-diesel variants.
 */
@property(strong) NSNumber* engineTorque;

/**
 * @abstract Accelerator pedal position (percentage depressed)
 */
@property(strong) NSNumber* accPedalPosition;

/**
 * @abstract Current angle of the steering wheel (in deg)
 */
@property(strong) NSNumber* steeringWheelAngle;
@property(strong) SDLECallInfo* eCallInfo;
@property(strong) SDLAirbagStatus* airbagStatus;
@property(strong) SDLEmergencyEvent* emergencyEvent;
@property(strong) SDLClusterModeStatus* clusterModeStatus;
@property(strong) SDLMyKey* myKey;

@end
