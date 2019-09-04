//
//  SDLGetInteriorVehicleData.h
//

#import "SDLRPCRequest.h"
#import "SDLModuleType.h"
#import "SDLModuleInfo.h"

/**
 * Reads the current status value of specified remote control module (type).
 * When subscribe is true, subscribes for specific remote control module data items.
 * When subscribe is false, unsubscribes for specific remote control module data items.
 * Once subscribed, the application will be notified by the onInteriorVehicleData RPC notification
 * whenever new data is available for the module.
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLGetInteriorVehicleData : SDLRPCRequest

- (instancetype)initWithModuleType:(SDLModuleType)moduleType moduleId:(NSString *)moduleId;

- (instancetype)initAndSubscribeToModuleType:(SDLModuleType)moduleType moduleId:(NSString *)moduleId;

- (instancetype)initAndUnsubscribeToModuleType:(SDLModuleType)moduleType moduleId:(NSString *)moduleId;

- (instancetype)initWithModuleType:(SDLModuleType)moduleType __deprecated_msg("Use initWithModuleType:moduleId: instead");

- (instancetype)initAndSubscribeToModuleType:(SDLModuleType)moduleType __deprecated_msg("Use initAndSubscribeToModuleType:moduleId: instead");

- (instancetype)initAndUnsubscribeToModuleType:(SDLModuleType)moduleType __deprecated_msg("Use initAndUnsubscribeToModuleType:moduleId:");

/**
 * The type of a RC module to retrieve module data from the vehicle.
 *
 */
@property (strong, nonatomic) SDLModuleType moduleType;

/**
 *  Id of a module, published by System Capability.
 *
 *  Optional
 */
@property (nullable, strong, nonatomic) NSString *moduleId;

/**
 * If subscribe is true, the head unit will register OnInteriorVehicleData notifications for the requested module (moduleId and moduleType).
 * If subscribe is false, the head unit will unregister OnInteriorVehicleData notifications for the requested module (moduleId and moduleType).
 * If subscribe is not included, the subscription status of the app for the requested module (moduleId and moduleType) will remain unchanged.
 *
 * optional, Boolean, default Value = false
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *subscribe;

@end

NS_ASSUME_NONNULL_END
