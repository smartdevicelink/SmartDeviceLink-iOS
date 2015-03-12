//  SDLIAPTransport.h
//



#import <ExternalAccessory/ExternalAccessory.h>
#import "SDLAbstractTransport.h"
#import "SDLIAPSession.h"

@interface SDLIAPTransport : SDLAbstractTransport<SDLIAPSessionDelegate>

@property (strong, atomic) SDLIAPSession *controlSession;
@property (strong, atomic) SDLIAPSession *session;

- (instancetype)init;

@end
