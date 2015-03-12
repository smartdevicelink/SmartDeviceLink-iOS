//  SDLTransport.h
//


@import Foundation;

#import "SDLTransportDelegate.h"

@protocol SDLTransport

@property (weak) id<SDLTransportDelegate> delegate;

- (void)connect;
- (void)disconnect;
- (void)sendData:(NSData *)dataToSend;
- (void)unregister;

@end
