//  SDLECallInfo.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

#import <SmartDeviceLink/SDLVehicleDataNotificationStatus.h>
#import <SmartDeviceLink/SDLECallConfirmationStatus.h>

@interface SDLECallInfo : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLVehicleDataNotificationStatus* eCallNotificationStatus;
@property(strong) SDLVehicleDataNotificationStatus* auxECallNotificationStatus;
@property(strong) SDLECallConfirmationStatus* eCallConfirmationStatus;

@end
