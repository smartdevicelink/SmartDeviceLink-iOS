//  SDLGetVehicleData.h
//


#import "SDLRPCRequest.h"

/**
 *  Requests current values of specific published vehicle data items.
 *
 *  Function Group: Location, VehicleInfo and DrivingChara
 *  HMILevel needs to be FULL, LIMITED or BACKGROUND
 *  Since SmartDeviceLink 2.0
 *  See SDLSubscribeVehicleData, SDLUnsubscribeVehicleData
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLGetVehicleData : SDLRPCRequest

/**
 *  Convenience init for getting data for all possible vehicle data items.
 *
 *  @param accelerationPedalPosition   Get accelerationPedalPosition data
 *  @param airbagStatus                Get airbagStatus data
 *  @param beltStatus                  Get beltStatus data
 *  @param bodyInformation             Get bodyInformation data
 *  @param cloudAppVehicleID           Get cloudAppVehicleID data
 *  @param clusterModeStatus           Get clusterModeStatus data
 *  @param deviceStatus                Get deviceStatus data
 *  @param driverBraking               Get driverBraking data
 *  @param eCallInfo                   Get eCallInfo data
 *  @param electronicParkBrakeStatus   Get electronicParkBrakeStatus data
 *  @param emergencyEvent              Get emergencyEvent data
 *  @param engineOilLife               Get engineOilLife data
 *  @param engineTorque                Get engineTorque data
 *  @param externalTemperature         Get externalTemperature data
 *  @param fuelLevel                   Get fuelLevel data
 *  @param fuelLevelState              Get fuelLevelState data
 *  @param fuelRange                   Get fuelRange data
 *  @param gps                         Get gps data
 *  @param headLampStatus              Get headLampStatus data
 *  @param instantFuelConsumption      Get instantFuelConsumption data
 *  @param myKey                       Get myKey data
 *  @param odometer                    Get odometer data
 *  @param prndl                       Get prndl data
 *  @param rpm                         Get rpm data
 *  @param speed                       Get speed data
 *  @param steeringWheelAngle          Get steeringWheelAngle data
 *  @param tirePressure                Get tirePressure data
 *  @param turnSignal                  Get turnSignal data
 *  @param vin                         Get vin data
 *  @param wiperStatus                 Get wiperStatus data
 *  @return                            A SDLGetVehicleData object
 */
- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation cloudAppVehicleID:(BOOL)cloudAppVehicleID clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo electronicParkBrakeStatus:(BOOL)electronicParkBrakeStatus emergencyEvent:(BOOL)emergencyEvent engineOilLife:(BOOL)engineOilLife engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState fuelRange:(BOOL)fuelRange gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure turnSignal:(BOOL)turnSignal vin:(BOOL)vin wiperStatus:(BOOL)wiperStatus __deprecated_msg("Use initWithGps:speed:rpm:instantFuelConsumption:fuelRange:climateData:turnSignal:vin:gearStatus:tirePressure:odometer:beltStatus:bodyInformation:deviceStatus:driverBraking:wiperStatus:headLampStatus:engineTorque:accPedalPosition:steeringWheelAngle:engineOilLife:electronicParkBrakeStatus:cloudAppVehicleID:stabilityControlsStatus:eCallInfo:airbagStatus:emergencyEvent:clusterModeStatus:myKey:windowStatus:handsOffSteering:seatOccupancy: instead");

/**
 * Convenience init for getting data for all possible vehicle data items.
 *
 * @param gps - gps
 * @param speed - speed
 * @param rpm - rpm
 * @param instantFuelConsumption - instantFuelConsumption
 * @param fuelRange - fuelRange
 * @param externalTemperature - externalTemperature
 * @param turnSignal - turnSignal
 * @param vin - vin
 * @param gearStatus - gearStatus
 * @param tirePressure - tirePressure
 * @param odometer - odometer
 * @param beltStatus - beltStatus
 * @param bodyInformation - bodyInformation
 * @param deviceStatus - deviceStatus
 * @param driverBraking - driverBraking
 * @param wiperStatus - wiperStatus
 * @param headLampStatus - headLampStatus
 * @param engineTorque - engineTorque
 * @param accPedalPosition - accPedalPosition
 * @param steeringWheelAngle - steeringWheelAngle
 * @param engineOilLife - engineOilLife
 * @param electronicParkBrakeStatus - electronicParkBrakeStatus
 * @param cloudAppVehicleID - cloudAppVehicleID
 * @param stabilityControlsStatus - stabilityControlsStatus
 * @param eCallInfo - eCallInfo
 * @param airbagStatus - airbagStatus
 * @param emergencyEvent - emergencyEvent
 * @param clusterModeStatus - clusterModeStatus
 * @param myKey - myKey
 * @param handsOffSteering - handsOffSteering
 * @param windowStatus - windowStatus
 * @return A SDLGetVehicleData object
 */
- (instancetype)initWithGps:(nullable NSNumber<SDLBool> *)gps speed:(nullable NSNumber<SDLBool> *)speed rpm:(nullable NSNumber<SDLBool> *)rpm instantFuelConsumption:(nullable NSNumber<SDLBool> *)instantFuelConsumption fuelRange:(nullable NSNumber<SDLBool> *)fuelRange externalTemperature:(nullable NSNumber<SDLBool> *)externalTemperature turnSignal:(nullable NSNumber<SDLBool> *)turnSignal vin:(nullable NSNumber<SDLBool> *)vin gearStatus:(nullable NSNumber<SDLBool> *)gearStatus tirePressure:(nullable NSNumber<SDLBool> *)tirePressure odometer:(nullable NSNumber<SDLBool> *)odometer beltStatus:(nullable NSNumber<SDLBool> *)beltStatus bodyInformation:(nullable NSNumber<SDLBool> *)bodyInformation deviceStatus:(nullable NSNumber<SDLBool> *)deviceStatus driverBraking:(nullable NSNumber<SDLBool> *)driverBraking wiperStatus:(nullable NSNumber<SDLBool> *)wiperStatus headLampStatus:(nullable NSNumber<SDLBool> *)headLampStatus engineTorque:(nullable NSNumber<SDLBool> *)engineTorque accPedalPosition:(nullable NSNumber<SDLBool> *)accPedalPosition steeringWheelAngle:(nullable NSNumber<SDLBool> *)steeringWheelAngle engineOilLife:(nullable NSNumber<SDLBool> *)engineOilLife electronicParkBrakeStatus:(nullable NSNumber<SDLBool> *)electronicParkBrakeStatus cloudAppVehicleID:(nullable NSNumber<SDLBool> *)cloudAppVehicleID stabilityControlsStatus:(nullable NSNumber<SDLBool> *)stabilityControlsStatus eCallInfo:(nullable NSNumber<SDLBool> *)eCallInfo airbagStatus:(nullable NSNumber<SDLBool> *)airbagStatus emergencyEvent:(nullable NSNumber<SDLBool> *)emergencyEvent clusterModeStatus:(nullable NSNumber<SDLBool> *)clusterModeStatus myKey:(nullable NSNumber<SDLBool> *)myKey handsOffSteering:(nullable NSNumber<SDLBool> *)handsOffSteering windowStatus:(nullable NSNumber<SDLBool> *)windowStatus __deprecated_msg("Use initWithGps:speed:rpm:instantFuelConsumption:fuelRange:climateData:turnSignal:vin:gearStatus:tirePressure:odometer:beltStatus:bodyInformation:deviceStatus:driverBraking:wiperStatus:headLampStatus:engineTorque:accPedalPosition:steeringWheelAngle:engineOilLife:electronicParkBrakeStatus:cloudAppVehicleID:stabilityControlsStatus:eCallInfo:airbagStatus:emergencyEvent:clusterModeStatus:myKey:windowStatus:handsOffSteering:seatOccupancy: instead");

/**
 * Convenience init for getting data for all possible vehicle data items.
 *
 * @param gps - gps
 * @param speed - speed
 * @param rpm - rpm
 * @param instantFuelConsumption - instantFuelConsumption
 * @param fuelRange - fuelRange
 * @param climateData - climateData
 * @param turnSignal - turnSignal
 * @param vin - vin
 * @param gearStatus - gearStatus
 * @param tirePressure - tirePressure
 * @param odometer - odometer
 * @param beltStatus - beltStatus
 * @param bodyInformation - bodyInformation
 * @param deviceStatus - deviceStatus
 * @param driverBraking - driverBraking
 * @param wiperStatus - wiperStatus
 * @param headLampStatus - headLampStatus
 * @param engineTorque - engineTorque
 * @param accPedalPosition - accPedalPosition
 * @param steeringWheelAngle - steeringWheelAngle
 * @param engineOilLife - engineOilLife
 * @param electronicParkBrakeStatus - electronicParkBrakeStatus
 * @param cloudAppVehicleID - cloudAppVehicleID
 * @param stabilityControlsStatus - stabilityControlsStatus
 * @param eCallInfo - eCallInfo
 * @param airbagStatus - airbagStatus
 * @param emergencyEvent - emergencyEvent
 * @param clusterModeStatus - clusterModeStatus
 * @param myKey - myKey
 * @param handsOffSteering - handsOffSteering
 * @param windowStatus - windowStatus
 * @param seatOccupancy - seatOccupancy
 */
- (instancetype)initWithGps:(nullable NSNumber<SDLBool> *)gps speed:(nullable NSNumber<SDLBool> *)speed rpm:(nullable NSNumber<SDLBool> *)rpm instantFuelConsumption:(nullable NSNumber<SDLBool> *)instantFuelConsumption fuelRange:(nullable NSNumber<SDLBool> *)fuelRange climateData:(nullable NSNumber<SDLBool> *)climateData turnSignal:(nullable NSNumber<SDLBool> *)turnSignal vin:(nullable NSNumber<SDLBool> *)vin gearStatus:(nullable NSNumber<SDLBool> *)gearStatus tirePressure:(nullable NSNumber<SDLBool> *)tirePressure odometer:(nullable NSNumber<SDLBool> *)odometer beltStatus:(nullable NSNumber<SDLBool> *)beltStatus bodyInformation:(nullable NSNumber<SDLBool> *)bodyInformation deviceStatus:(nullable NSNumber<SDLBool> *)deviceStatus driverBraking:(nullable NSNumber<SDLBool> *)driverBraking wiperStatus:(nullable NSNumber<SDLBool> *)wiperStatus headLampStatus:(nullable NSNumber<SDLBool> *)headLampStatus engineTorque:(nullable NSNumber<SDLBool> *)engineTorque accPedalPosition:(nullable NSNumber<SDLBool> *)accPedalPosition steeringWheelAngle:(nullable NSNumber<SDLBool> *)steeringWheelAngle engineOilLife:(nullable NSNumber<SDLBool> *)engineOilLife electronicParkBrakeStatus:(nullable NSNumber<SDLBool> *)electronicParkBrakeStatus cloudAppVehicleID:(nullable NSNumber<SDLBool> *)cloudAppVehicleID stabilityControlsStatus:(nullable NSNumber<SDLBool> *)stabilityControlsStatus eCallInfo:(nullable NSNumber<SDLBool> *)eCallInfo airbagStatus:(nullable NSNumber<SDLBool> *)airbagStatus emergencyEvent:(nullable NSNumber<SDLBool> *)emergencyEvent clusterModeStatus:(nullable NSNumber<SDLBool> *)clusterModeStatus myKey:(nullable NSNumber<SDLBool> *)myKey windowStatus:(nullable NSNumber<SDLBool> *)windowStatus handsOffSteering:(nullable NSNumber<SDLBool> *)handsOffSteering seatOccupancy:(nullable NSNumber<SDLBool> *)seatOccupancy;

/**
 * See GearStatus
 *
 * @since SDL 7.0
*/
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *gearStatus;

/**
 * A boolean value. If true, requests GPS data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *gps;

/**
 * A boolean value. If true, requests Speed data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *speed;

/**
 * A boolean value. If true, requests RPM data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *rpm;

/**
 * A boolean value. If true, requests Fuel Level data.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *fuelLevel __deprecated_msg("use fuelRange instead on 7.0+ RPC version connections");

/**
 * A boolean value. If true, requests Fuel Level State data.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *fuelLevel_State __deprecated_msg("use fuelRange instead on 7.0+ RPC version connections");

/**
 * A boolean value. If true, requests Fuel Range data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *fuelRange;

/**
 * A boolean value. If true, requests Instant Fuel Consumption data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *instantFuelConsumption;

/**
 * See ClimateData
 *
 * @added in SmartDeviceLink 7.1.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *climateData;

/**
 * The external temperature in degrees celsius. This parameter is deprecated starting RPC Spec 7.1, please see climateData.
 *
 * @deprecated in SmartDeviceLink 7.1.0
 * @added in SmartDeviceLink 2.0.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *externalTemperature __deprecated_msg("Use climateData instead on 7.1+ RPC version connections");

/**
 * A boolean value. If true, requests the Vehicle Identification Number.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *vin;

/**
 * See PRNDL. This parameter is deprecated and it is now covered in `gearStatus`
 *
 * @deprecated
 * @since SDL 7.0
*/
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *prndl __deprecated_msg("use gearStatus instead on 7.0+ RPC version connections");

/**
 * A boolean value. If true, requests Tire Pressure data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *tirePressure;

/**
 * A boolean value. If true, requests Odometer data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *odometer;

/**
 * A boolean value. If true, requests Belt Status data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *beltStatus;

/**
 * A boolean value. If true, requests Body Information data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *bodyInformation;

/**
 * A boolean value. If true, requests Device Status data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *deviceStatus;

/**
 * A boolean value. If true, requests Driver Braking data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *driverBraking;

/**
 * See WindowStatus
 *
 * @since SDL 7.0
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *windowStatus;

/**
 * A boolean value. If true, requests Wiper Status data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *wiperStatus;

/**
 * To indicate whether driver hands are off the steering wheel
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *handsOffSteering;

/**
 * A boolean value. If true, requests Head Lamp Status data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *headLampStatus;

/**
 * A boolean value. If true, requests Engine Oil Life data.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *engineOilLife;

/**
 * A boolean value. If true, requests Engine Torque data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *engineTorque;

/**
 * A boolean value. If true, requests Acc Pedal Position data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *accPedalPosition;

/**
 * A boolean value. If true, requests Steering Wheel Angle data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *steeringWheelAngle;

/**
 * A boolean value. If true, requests Emergency Call Info data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *eCallInfo;

/**
 * A boolean value. If true, requests Air Bag Status data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *airbagStatus;

/**
 * A boolean value. If true, requests Emergency Event (if it occurred) data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *emergencyEvent;

/**
 * A boolean value. If true, requests Cluster Mode Status data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *clusterModeStatus;

/**
 * A boolean value. If true, requests MyKey data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *myKey;

/**
 A boolean value. If true, requests Electronic Parking Brake status data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *electronicParkBrakeStatus;

/**
 A boolean value. If true, requests Turn Signal data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *turnSignal;

/**
 A boolean value. If true, requests the Cloud App Vehicle ID.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *cloudAppVehicleID;

/**
 A boolean value. If true, requests StabilityControlsStatus data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *stabilityControlsStatus;

/**
 Sets the OEM custom vehicle data state for any given OEM custom vehicle data name.

 @param vehicleDataName The name of the OEM custom vehicle data item.
 @param vehicleDataState A boolean value.  If true, requests the OEM custom vehicle data item.

  Added in SmartDeviceLink 6.0
 */
- (void)setOEMCustomVehicleData:(NSString *)vehicleDataName withVehicleDataState:(BOOL)vehicleDataState NS_SWIFT_NAME(setOEMCustomVehicleData(name:state:));

/**
 Gets the OEM custom vehicle data value for any given OEM custom vehicle data name.
 
 @param vehicleDataName The name of the OEM custom vehicle data item.
 @return The state of an OEM custom vehicle data item for the given vehicle data name.

  Added in SmartDeviceLink 6.0
 */
- (nullable NSNumber<SDLBool> *)getOEMCustomVehicleData:(NSString *)vehicleDataName;

/**
 * See SeatOccupancy
 *
 * @added in SmartDeviceLink 7.1.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *seatOccupancy;

@end

NS_ASSUME_NONNULL_END
