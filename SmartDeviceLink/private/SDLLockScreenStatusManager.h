//
//  SDLLockScreenManager.h
//  SmartDeviceLink
//

#import <Foundation/Foundation.h>

#import "SDLHMILevel.h"
#import "SDLLockScreenConstants.h"

@class SDLNotificationDispatcher;
@class SDLOnLockScreenStatus;

NS_ASSUME_NONNULL_BEGIN

static NSString *const SDLDidChangeLockScreenStatusNotification = @"com.sdl.notification.lockScreenStatus";


@interface SDLLockScreenStatusManager : NSObject

@property (assign, nonatomic) BOOL userSelected;
@property (assign, nonatomic) BOOL driverDistracted;
@property (nullable, strong, nonatomic) SDLHMILevel hmiLevel;
@property (assign, nonatomic, readonly) SDLLockScreenStatus lockScreenStatus;
@property (strong, nonatomic, readonly) SDLOnLockScreenStatus *lockScreenStatusNotification;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNotificationDispatcher:(id)dispatcher;

@end

NS_ASSUME_NONNULL_END