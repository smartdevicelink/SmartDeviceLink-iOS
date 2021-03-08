//
//  SDLConfiguration.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/13/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLFileManagerConfiguration;
@class SDLLifecycleConfiguration;
@class SDLLockScreenConfiguration;
@class SDLLogConfiguration;
@class SDLStreamingMediaConfiguration;
@class SDLEncryptionConfiguration;

NS_ASSUME_NONNULL_BEGIN

/// Contains information about the app's configuration, such as lifecycle, lockscreen, encryption, etc.
@interface SDLConfiguration : NSObject <NSCopying>

/**
 *  The lifecycle configuration.
 */
@property (copy, nonatomic, readonly) SDLLifecycleConfiguration *lifecycleConfig;

/**
 *  The lock screen configuration.
 */
@property (copy, nonatomic, readonly) SDLLockScreenConfiguration *lockScreenConfig;

/**
 *  The log configuration.
 */
@property (copy, nonatomic, readonly) SDLLogConfiguration *loggingConfig;

/**
 *  The streaming media configuration.
 */
@property (copy, nonatomic, readonly, nullable) SDLStreamingMediaConfiguration *streamingMediaConfig;

/**
 *  The file manager configuration.
 */
@property (copy, nonatomic, readonly) SDLFileManagerConfiguration *fileManagerConfig;

/**
 *  The encryption configuration.
 */
@property (copy, nonatomic, readonly) SDLEncryptionConfiguration *encryptionConfig;

/**
 *  Creates a new configuration to be passed to the SDLManager with custom lifecycle, lock screen, logging, file manager and encryption configurations.
 *
 *  @param lifecycleConfig      The lifecycle configuration to be used.
 *  @param lockScreenConfig     The lockscreen configuration to be used. If nil, the `enabledConfiguration` will be used.
 *  @param logConfig            The logging configuration to be used. If nil, the `defaultConfiguration` will be used.
 *  @param fileManagerConfig    The file manager configuration to be used or `defaultConfiguration` if nil.
 *  @param encryptionConfig     The encryption configuration to be used. If nil, the `defaultConfiguration` will be used.
 *  @return                     The configuration
 */
- (instancetype)initWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig logging:(nullable SDLLogConfiguration *)logConfig fileManager:(nullable SDLFileManagerConfiguration *)fileManagerConfig encryption:(nullable SDLEncryptionConfiguration *)encryptionConfig;

/**
 *  Creates a new configuration to be passed to the SDLManager with custom lifecycle, lock screen, logging, streaming media, file manager and encryption configurations.
 *
 *  @param lifecycleConfig      The lifecycle configuration to be used.
 *  @param lockScreenConfig     The lockscreen configuration to be used. If nil, the `enabledConfiguration` will be used.
 *  @param logConfig            The logging configuration to be used. If nil, the `defaultConfiguration` will be used.
 *  @param streamingMediaConfig The streaming media configuration to be used or nil if not used.
 *  @param fileManagerConfig    The file manager configuration to be used or `defaultConfiguration` if nil.
 *  @param encryptionConfig     The encryption configuration to be used. If nil, the `defaultConfiguration` will be used.
 *  @return                     The configuration
 */
- (instancetype)initWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig logging:(nullable SDLLogConfiguration *)logConfig streamingMedia:(nullable SDLStreamingMediaConfiguration *)streamingMediaConfig fileManager:(nullable SDLFileManagerConfiguration *)fileManagerConfig encryption:(nullable SDLEncryptionConfiguration *)encryptionConfig;

@end

NS_ASSUME_NONNULL_END
