//
//  SDLIAPSession.h
//

#import "SDLIAPSessionDelegate.h"
#import <ExternalAccessory/ExternalAccessory.h>
#import <Foundation/Foundation.h>

@class SDLStreamDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface SDLIAPSession : NSObject

@property (nullable, strong, nonatomic) EAAccessory *accessory;
@property (nullable, strong, nonatomic) NSString *protocol;
@property (nullable, strong, nonatomic) EASession *easession;
@property (nullable, weak, nonatomic) id<SDLIAPSessionDelegate> delegate;
@property (nullable, strong, nonatomic) SDLStreamDelegate *streamDelegate;

- (instancetype)initWithAccessory:(EAAccessory *)accessory
                      forProtocol:(NSString *)protocol;

- (BOOL)start;
- (void)stop;
- (void)sendData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
