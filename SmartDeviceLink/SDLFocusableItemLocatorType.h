//
//  SDLHapticInterface.h
//  SmartDeviceLink-iOS
//
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDLConnectionManagerType.h"

@class SDLManager;

NS_ASSUME_NONNULL_BEGIN

@protocol SDLFocusableItemLocatorType <NSObject>

/**
 Whether or not this will attempt to send haptic RPCs.

 @note Defaults to NO.
 */
@property (nonatomic, assign) BOOL enableHapticDataRequests;

/**
 The projection window associated with the Haptic Manager
 */
@property (nonatomic, weak) UIViewController *viewController;

/**
 Initializes haptic interface. After initializing the application must call updateInterfaceLayout to process the UIWindow. Application must update later view changes in the window by sending SDLDidUpdateProjectionView  notification.
 
  @param window UIWindow to be stored in haptic interface
  @param connectionManager Object of a class that implements ConnectionManagerType. This is used for RPC communication.
 */
- (instancetype)initWithWindow:(UIWindow *)window connectionManager:(id<SDLConnectionManagerType>)connectionManager __deprecated_msg("Use initWithViewController:connectionManager: instead");

- (instancetype)initWithViewController:(UIViewController *)viewController connectionManager:(id<SDLConnectionManagerType>)connectionManager;

/**
 updateInterfaceLayout crawls through the view hierarchy, updates and keep tracks of views to be reported through Haptic RPC. This function is automatically called when SDLDidUpdateProjectionView notification is sent by the application.
 */
- (void)updateInterfaceLayout;

@end

NS_ASSUME_NONNULL_END
