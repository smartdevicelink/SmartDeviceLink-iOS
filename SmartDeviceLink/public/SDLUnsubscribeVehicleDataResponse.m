//  SDLUnsubscribeVehicleDataResponse.m
//


#import "SDLUnsubscribeVehicleDataResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLVehicleDataResult.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLUnsubscribeVehicleDataResponse

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    self = [super initWithName:SDLRPCFunctionNameUnsubscribeVehicleData];
    if (!self) {
        return nil;
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithGps:(nullable SDLVehicleDataResult *)gps speed:(nullable SDLVehicleDataResult *)speed rpm:(nullable SDLVehicleDataResult *)rpm instantFuelConsumption:(nullable SDLVehicleDataResult *)instantFuelConsumption fuelRange:(nullable SDLVehicleDataResult *)fuelRange externalTemperature:(nullable SDLVehicleDataResult *)externalTemperature turnSignal:(nullable SDLVehicleDataResult *)turnSignal gearStatus:(nullable SDLVehicleDataResult *)gearStatus tirePressure:(nullable SDLVehicleDataResult *)tirePressure odometer:(nullable SDLVehicleDataResult *)odometer beltStatus:(nullable SDLVehicleDataResult *)beltStatus bodyInformation:(nullable SDLVehicleDataResult *)bodyInformation deviceStatus:(nullable SDLVehicleDataResult *)deviceStatus driverBraking:(nullable SDLVehicleDataResult *)driverBraking wiperStatus:(nullable SDLVehicleDataResult *)wiperStatus headLampStatus:(nullable SDLVehicleDataResult *)headLampStatus engineTorque:(nullable SDLVehicleDataResult *)engineTorque accPedalPosition:(nullable SDLVehicleDataResult *)accPedalPosition steeringWheelAngle:(nullable SDLVehicleDataResult *)steeringWheelAngle engineOilLife:(nullable SDLVehicleDataResult *)engineOilLife electronicParkBrakeStatus:(nullable SDLVehicleDataResult *)electronicParkBrakeStatus cloudAppVehicleID:(nullable SDLVehicleDataResult *)cloudAppVehicleID stabilityControlsStatus:(nullable SDLVehicleDataResult *)stabilityControlsStatus eCallInfo:(nullable SDLVehicleDataResult *)eCallInfo airbagStatus:(nullable SDLVehicleDataResult *)airbagStatus emergencyEvent:(nullable SDLVehicleDataResult *)emergencyEvent clusterModes:(nullable SDLVehicleDataResult *)clusterModes myKey:(nullable SDLVehicleDataResult *)myKey handsOffSteering:(nullable SDLVehicleDataResult *)handsOffSteering windowStatus:(nullable SDLVehicleDataResult *)windowStatus {
    self = [self initWithGps:gps speed:speed rpm:rpm instantFuelConsumption:instantFuelConsumption fuelRange:fuelRange climateData:nil turnSignal:turnSignal gearStatus:gearStatus tirePressure:tirePressure odometer:odometer beltStatus:beltStatus bodyInformation:bodyInformation deviceStatus:deviceStatus driverBraking:driverBraking wiperStatus:wiperStatus headLampStatus:headLampStatus engineTorque:engineTorque accPedalPosition:accPedalPosition steeringWheelAngle:steeringWheelAngle engineOilLife:engineOilLife electronicParkBrakeStatus:electronicParkBrakeStatus cloudAppVehicleID:cloudAppVehicleID stabilityControlsStatus:stabilityControlsStatus eCallInfo:eCallInfo airbagStatus:airbagStatus emergencyEvent:emergencyEvent clusterModes:clusterModes myKey:myKey windowStatus:windowStatus handsOffSteering:handsOffSteering seatOccupancy:nil];
    if (self) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        self.externalTemperature = externalTemperature;
#pragma clang diagnostic pop
    }
    return self;
}

- (instancetype)initWithGps:(nullable SDLVehicleDataResult *)gps speed:(nullable SDLVehicleDataResult *)speed rpm:(nullable SDLVehicleDataResult *)rpm instantFuelConsumption:(nullable SDLVehicleDataResult *)instantFuelConsumption fuelRange:(nullable SDLVehicleDataResult *)fuelRange climateData:(nullable SDLVehicleDataResult *)climateData turnSignal:(nullable SDLVehicleDataResult *)turnSignal gearStatus:(nullable SDLVehicleDataResult *)gearStatus tirePressure:(nullable SDLVehicleDataResult *)tirePressure odometer:(nullable SDLVehicleDataResult *)odometer beltStatus:(nullable SDLVehicleDataResult *)beltStatus bodyInformation:(nullable SDLVehicleDataResult *)bodyInformation deviceStatus:(nullable SDLVehicleDataResult *)deviceStatus driverBraking:(nullable SDLVehicleDataResult *)driverBraking wiperStatus:(nullable SDLVehicleDataResult *)wiperStatus headLampStatus:(nullable SDLVehicleDataResult *)headLampStatus engineTorque:(nullable SDLVehicleDataResult *)engineTorque accPedalPosition:(nullable SDLVehicleDataResult *)accPedalPosition steeringWheelAngle:(nullable SDLVehicleDataResult *)steeringWheelAngle engineOilLife:(nullable SDLVehicleDataResult *)engineOilLife electronicParkBrakeStatus:(nullable SDLVehicleDataResult *)electronicParkBrakeStatus cloudAppVehicleID:(nullable SDLVehicleDataResult *)cloudAppVehicleID stabilityControlsStatus:(nullable SDLVehicleDataResult *)stabilityControlsStatus eCallInfo:(nullable SDLVehicleDataResult *)eCallInfo airbagStatus:(nullable SDLVehicleDataResult *)airbagStatus emergencyEvent:(nullable SDLVehicleDataResult *)emergencyEvent clusterModes:(nullable SDLVehicleDataResult *)clusterModes myKey:(nullable SDLVehicleDataResult *)myKey windowStatus:(nullable SDLVehicleDataResult *)windowStatus handsOffSteering:(nullable SDLVehicleDataResult *)handsOffSteering seatOccupancy:(nullable SDLVehicleDataResult *)seatOccupancy {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.gps = gps;
    self.speed = speed;
    self.rpm = rpm;
    self.instantFuelConsumption = instantFuelConsumption;
    self.fuelRange = fuelRange;
    self.climateData = climateData;
    self.turnSignal = turnSignal;
    self.gearStatus = gearStatus;
    self.tirePressure = tirePressure;
    self.odometer = odometer;
    self.beltStatus = beltStatus;
    self.bodyInformation = bodyInformation;
    self.deviceStatus = deviceStatus;
    self.driverBraking = driverBraking;
    self.wiperStatus = wiperStatus;
    self.headLampStatus = headLampStatus;
    self.engineTorque = engineTorque;
    self.accPedalPosition = accPedalPosition;
    self.steeringWheelAngle = steeringWheelAngle;
    self.engineOilLife = engineOilLife;
    self.electronicParkBrakeStatus = electronicParkBrakeStatus;
    self.cloudAppVehicleID = cloudAppVehicleID;
    self.stabilityControlsStatus = stabilityControlsStatus;
    self.eCallInfo = eCallInfo;
    self.airbagStatus = airbagStatus;
    self.emergencyEvent = emergencyEvent;
    self.clusterModes = clusterModes;
    self.myKey = myKey;
    self.windowStatus = windowStatus;
    self.handsOffSteering = handsOffSteering;
    self.seatOccupancy = seatOccupancy;
    return self;
}

- (void)setGearStatus:(nullable SDLVehicleDataResult *)gearStatus {
    [self.parameters sdl_setObject:gearStatus forName:SDLRPCParameterNameGearStatus];
}

- (nullable SDLVehicleDataResult *)gearStatus {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameGearStatus ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setGps:(nullable SDLVehicleDataResult *)gps {
    [self.parameters sdl_setObject:gps forName:SDLRPCParameterNameGPS];
}

- (nullable SDLVehicleDataResult *)gps {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameGPS ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setSpeed:(nullable SDLVehicleDataResult *)speed {
    [self.parameters sdl_setObject:speed forName:SDLRPCParameterNameSpeed];
}

- (nullable SDLVehicleDataResult *)speed {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSpeed ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setRpm:(nullable SDLVehicleDataResult *)rpm {
    [self.parameters sdl_setObject:rpm forName:SDLRPCParameterNameRPM];
}

- (nullable SDLVehicleDataResult *)rpm {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameRPM ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setFuelLevel:(nullable SDLVehicleDataResult *)fuelLevel {
    [self.parameters sdl_setObject:fuelLevel forName:SDLRPCParameterNameFuelLevel];
}

- (nullable SDLVehicleDataResult *)fuelLevel {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameFuelLevel ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setFuelLevel_State:(nullable SDLVehicleDataResult *)fuelLevel_State {
    [self.parameters sdl_setObject:fuelLevel_State forName:SDLRPCParameterNameFuelLevelState];
}

- (nullable SDLVehicleDataResult *)fuelLevel_State {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameFuelLevelState ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setFuelRange:(nullable SDLVehicleDataResult *)fuelRange {
    [self.parameters sdl_setObject:fuelRange forName:SDLRPCParameterNameFuelRange];
}

- (nullable SDLVehicleDataResult *)fuelRange {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameFuelRange ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setInstantFuelConsumption:(nullable SDLVehicleDataResult *)instantFuelConsumption {
    [self.parameters sdl_setObject:instantFuelConsumption forName:SDLRPCParameterNameInstantFuelConsumption];
}

- (nullable SDLVehicleDataResult *)instantFuelConsumption {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameInstantFuelConsumption ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setClimateData:(nullable SDLVehicleDataResult *)climateData {
    [self.parameters sdl_setObject:climateData forName:SDLRPCParameterNameClimateData];
}

- (nullable SDLVehicleDataResult *)climateData {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameClimateData ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setExternalTemperature:(nullable SDLVehicleDataResult *)externalTemperature {
    [self.parameters sdl_setObject:externalTemperature forName:SDLRPCParameterNameExternalTemperature];
}

- (nullable SDLVehicleDataResult *)externalTemperature {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameExternalTemperature ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setPrndl:(nullable SDLVehicleDataResult *)prndl {
    [self.parameters sdl_setObject:prndl forName:SDLRPCParameterNamePRNDL];
}

- (nullable SDLVehicleDataResult *)prndl {
    return [self.parameters sdl_objectForName:SDLRPCParameterNamePRNDL ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setTirePressure:(nullable SDLVehicleDataResult *)tirePressure {
    [self.parameters sdl_setObject:tirePressure forName:SDLRPCParameterNameTirePressure];
}

- (nullable SDLVehicleDataResult *)tirePressure {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameTirePressure ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setOdometer:(nullable SDLVehicleDataResult *)odometer {
    [self.parameters sdl_setObject:odometer forName:SDLRPCParameterNameOdometer];
}

- (nullable SDLVehicleDataResult *)odometer {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameOdometer ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setBeltStatus:(nullable SDLVehicleDataResult *)beltStatus {
    [self.parameters sdl_setObject:beltStatus forName:SDLRPCParameterNameBeltStatus];
}

- (nullable SDLVehicleDataResult *)beltStatus {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameBeltStatus ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setBodyInformation:(nullable SDLVehicleDataResult *)bodyInformation {
    [self.parameters sdl_setObject:bodyInformation forName:SDLRPCParameterNameBodyInformation];
}

- (nullable SDLVehicleDataResult *)bodyInformation {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameBodyInformation ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setDeviceStatus:(nullable SDLVehicleDataResult *)deviceStatus {
    [self.parameters sdl_setObject:deviceStatus forName:SDLRPCParameterNameDeviceStatus];
}

- (nullable SDLVehicleDataResult *)deviceStatus {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameDeviceStatus ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setDriverBraking:(nullable SDLVehicleDataResult *)driverBraking {
    [self.parameters sdl_setObject:driverBraking forName:SDLRPCParameterNameDriverBraking];
}

- (nullable SDLVehicleDataResult *)driverBraking {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameDriverBraking ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setWindowStatus:(nullable SDLVehicleDataResult *)windowStatus {
    [self.parameters sdl_setObject:windowStatus forName:SDLRPCParameterNameWindowStatus];
}

- (nullable SDLVehicleDataResult *)windowStatus {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameWindowStatus ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setWiperStatus:(nullable SDLVehicleDataResult *)wiperStatus {
    [self.parameters sdl_setObject:wiperStatus forName:SDLRPCParameterNameWiperStatus];
}

- (nullable SDLVehicleDataResult *)wiperStatus {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameWiperStatus ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setHandsOffSteering:(nullable SDLVehicleDataResult *)handsOffSteering {
    [self.parameters sdl_setObject:handsOffSteering forName:SDLRPCParameterNameHandsOffSteering];
}

- (nullable SDLVehicleDataResult *)handsOffSteering {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameHandsOffSteering ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setHeadLampStatus:(nullable SDLVehicleDataResult *)headLampStatus {
    [self.parameters sdl_setObject:headLampStatus forName:SDLRPCParameterNameHeadLampStatus];
}

- (nullable SDLVehicleDataResult *)headLampStatus {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameHeadLampStatus ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setEngineOilLife:(nullable SDLVehicleDataResult *)engineOilLife {
    [self.parameters sdl_setObject:engineOilLife forName:SDLRPCParameterNameEngineOilLife];
}

- (nullable SDLVehicleDataResult *)engineOilLife {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameEngineOilLife ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setEngineTorque:(nullable SDLVehicleDataResult *)engineTorque {
    [self.parameters sdl_setObject:engineTorque forName:SDLRPCParameterNameEngineTorque];
}

- (nullable SDLVehicleDataResult *)engineTorque {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameEngineTorque ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setAccPedalPosition:(nullable SDLVehicleDataResult *)accPedalPosition {
    [self.parameters sdl_setObject:accPedalPosition forName:SDLRPCParameterNameAccelerationPedalPosition];
}

- (nullable SDLVehicleDataResult *)accPedalPosition {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAccelerationPedalPosition ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setSteeringWheelAngle:(nullable SDLVehicleDataResult *)steeringWheelAngle {
    [self.parameters sdl_setObject:steeringWheelAngle forName:SDLRPCParameterNameSteeringWheelAngle];
}

- (nullable SDLVehicleDataResult *)steeringWheelAngle {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSteeringWheelAngle ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setECallInfo:(nullable SDLVehicleDataResult *)eCallInfo {
    [self.parameters sdl_setObject:eCallInfo forName:SDLRPCParameterNameECallInfo];
}

- (nullable SDLVehicleDataResult *)eCallInfo {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameECallInfo ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setAirbagStatus:(nullable SDLVehicleDataResult *)airbagStatus {
    [self.parameters sdl_setObject:airbagStatus forName:SDLRPCParameterNameAirbagStatus];
}

- (nullable SDLVehicleDataResult *)airbagStatus {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAirbagStatus ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setEmergencyEvent:(nullable SDLVehicleDataResult *)emergencyEvent {
    [self.parameters sdl_setObject:emergencyEvent forName:SDLRPCParameterNameEmergencyEvent];
}

- (nullable SDLVehicleDataResult *)emergencyEvent {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameEmergencyEvent ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setClusterModes:(nullable SDLVehicleDataResult *)clusterModes {
    [self.parameters sdl_setObject:clusterModes forName:SDLRPCParameterNameClusterModes];
}

- (nullable SDLVehicleDataResult *)clusterModes {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameClusterModes ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setMyKey:(nullable SDLVehicleDataResult *)myKey {
    [self.parameters sdl_setObject:myKey forName:SDLRPCParameterNameMyKey];
}

- (nullable SDLVehicleDataResult *)myKey {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameMyKey ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setElectronicParkBrakeStatus:(nullable SDLVehicleDataResult *)electronicParkBrakeStatus {
    [self.parameters sdl_setObject:electronicParkBrakeStatus forName:SDLRPCParameterNameElectronicParkBrakeStatus];
}

- (nullable SDLVehicleDataResult *)electronicParkBrakeStatus {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameElectronicParkBrakeStatus ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setTurnSignal:(nullable SDLVehicleDataResult *)turnSignal {
    [self.parameters sdl_setObject:turnSignal forName:SDLRPCParameterNameTurnSignal];
}

- (nullable SDLVehicleDataResult *)turnSignal {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameTurnSignal ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setCloudAppVehicleID:(nullable SDLVehicleDataResult *)cloudAppVehicleID {
    [self.parameters sdl_setObject:cloudAppVehicleID forName:SDLRPCParameterNameCloudAppVehicleID];
}

- (nullable SDLVehicleDataResult *)cloudAppVehicleID {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameCloudAppVehicleID ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setStabilityControlsStatus:(nullable SDLVehicleDataResult *)stabilityControlsStatus {
    [self.parameters sdl_setObject:stabilityControlsStatus forName:SDLRPCParameterNameStabilityControlsStatus];
}

- (nullable SDLVehicleDataResult *)stabilityControlsStatus {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameStabilityControlsStatus ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setOEMCustomVehicleData:(NSString *)vehicleDataName withVehicleDataState:(SDLVehicleDataResult *)vehicleDataState {
    [self.parameters sdl_setObject:vehicleDataState forName:vehicleDataName];
}

- (nullable SDLVehicleDataResult *)getOEMCustomVehicleData:(NSString *)vehicleDataName {
    return [self.parameters sdl_objectForName:vehicleDataName ofClass:SDLVehicleDataResult.class error:nil];
}

- (void)setSeatOccupancy:(nullable SDLVehicleDataResult *)seatOccupancy {
    [self.parameters sdl_setObject:seatOccupancy forName:SDLRPCParameterNameSeatOccupancy];
}

- (nullable SDLVehicleDataResult *)seatOccupancy {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSeatOccupancy ofClass:SDLVehicleDataResult.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
