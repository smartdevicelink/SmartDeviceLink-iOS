//
//  SDLIAPSession.m
//

#import "SDLIAPSession.h"
#import "SDLDebugTool.h"
#import "SDLStreamDelegate.h"
#import "SDLTimer.h"
#import "SDLMutableDataQueue.h"

NS_ASSUME_NONNULL_BEGIN
NSString *const ioStreamThreadName  = @ "com.smartdevicelink.iostream";
NSTimeInterval const streamThreadWaitSecs = 1.0;

@interface SDLIAPSession ()

@property (assign, nonatomic) BOOL isDataSession;
@property (nonatomic, strong, nullable) NSThread *ioStreamThread;
@property (nonatomic, strong, nullable) SDLMutableDataQueue *sendDataQueue;
@property (nonatomic, strong, nullable) dispatch_semaphore_t canceledSemaphore;

@end


@implementation SDLIAPSession

#pragma mark - Lifecycle

- (instancetype)initWithAccessory:(EAAccessory *)accessory forProtocol:(NSString *)protocol {
    NSString *logMessage = [NSString stringWithFormat:@"SDLIAPSession initWithAccessory:%@ forProtocol:%@", accessory, protocol];
    [SDLDebugTool logInfo:logMessage];

    self = [super init];
    if (self) {
        _isDataSession = [protocol isEqualToString:@"com.smartdevicelink.prot0"] ? NO : YES;
        _accessory = accessory;
        _protocol = protocol;
        _canceledSemaphore = dispatch_semaphore_create(0);
        _sendDataQueue = [[SDLMutableDataQueue alloc] init];
    }
    return self;
}


#pragma mark - Public Stream Lifecycle

- (BOOL)start {
    NSString *logMessage = [NSString stringWithFormat:@"Opening EASession withAccessory:%@ forProtocol:%@", _accessory.name, _protocol];
    [SDLDebugTool logInfo:logMessage];
    
    self.easession = [[EASession alloc] initWithAccessory:self.accessory forProtocol:self.protocol];
    
    if (!self.easession) {
        [SDLDebugTool logInfo:@"Error: Could Not Create Session Object"];
        return NO;
    }
    
    [SDLDebugTool logInfo:@"Created Session Object"];
    
    self.streamDelegate.streamErrorHandler = [self streamErroredHandler];
    self.streamDelegate.streamOpenHandler = [self streamOpenedHandler];
    if (!self.isDataSession) {
        [self startStream:self.easession.outputStream];
        [self startStream:self.easession.inputStream];
    } else {
        self.streamDelegate.streamHasSpaceHandler = [self streamHasSpaceHandler];
        // Start I/O event loop processing events in iAP channel
        self.ioStreamThread = [[NSThread alloc] initWithTarget:self selector:@selector(sdl_accessoryEventLoop) object:nil];
        [self.ioStreamThread setName:ioStreamThreadName];
        [self.ioStreamThread start];
    }
    
    return YES;
}

- (void)stop {

    if (!self.isDataSession) {
        [self stopStream:self.easession.outputStream];
        [self stopStream:self.easession.inputStream];
    } else {
        [self.ioStreamThread cancel];
        
        long lWait = dispatch_semaphore_wait(self.canceledSemaphore, dispatch_time(DISPATCH_TIME_NOW, streamThreadWaitSecs * NSEC_PER_SEC));
        if (lWait == 0) {
            [SDLDebugTool logInfo:@"Stream thread canceled"];
        } else{
           [SDLDebugTool logInfo:@"Error: failed to cancel stream thread"];
        }
        self.ioStreamThread = nil;
        self.isDataSession = NO;
    }
    self.easession = nil;
}

- (void)sendData:(NSData *)data{
    // Enqueue the data for transmission on the IO thread
    [self.sendDataQueue enqueueBuffer:data.mutableCopy];
}

- (BOOL)sdl_dequeueAndWriteToOutputStream:(NSError **)error{
    NSOutputStream *ostream = self.easession.outputStream;
    NSMutableData *remainder = [self.sendDataQueue frontBuffer];
    BOOL allDataWritten = NO;
    
    if (error != nil && remainder != nil && ostream.streamStatus == NSStreamStatusOpen) {
        NSInteger bytesRemaining = remainder.length;
        NSInteger bytesWritten = [ostream write:remainder.bytes maxLength:bytesRemaining];
        if (bytesWritten < 0) {
            *error = ostream.streamError;
        } else if (bytesWritten == bytesRemaining) {
                // Remove the data from the queue
                [self.sendDataQueue popBuffer];
                allDataWritten = YES;
            } else {
                // Cleave the sent bytes from the data, the remainder will sit at the head of the queue
                [remainder replaceBytesInRange:NSMakeRange(0, bytesWritten) withBytes:NULL length:0];
            }
    }

    return allDataWritten;
}

- (void)sdl_handleOutputStreamWriteError:(NSError *)error{
    NSString *errString = [NSString stringWithFormat:@"Output stream error: %@", error];
    [SDLDebugTool logInfo:errString];
    // REVIEW: We should look at the domain and the code as a tuple and decide
    // how to handle the error based on both values. For now, if the stream
    // is closed, we will flush the send queue and leave it as-is otherwise
    // so that temporary error conditions can be dealt with by retrying
    if (self.easession == nil ||
        self.easession.outputStream == nil ||
        self.easession.outputStream.streamStatus != NSStreamStatusOpen) {
        [self.sendDataQueue flush];
    }
}

- (void)sdl_accessoryEventLoop {
    @autoreleasepool {
        NSAssert(self.easession, @"_session must be assigned before calling");

        if (!self.easession) {
          return;
        }
        
        [self startStream:self.easession.inputStream];
        [self startStream:self.easession.outputStream];

        [SDLDebugTool logInfo:@"starting the event loop for accessory"];
        do {
            if (self.sendDataQueue.count > 0 && !self.sendDataQueue.frontDequeued) {
                NSError *sendErr = nil;
                if (![self sdl_dequeueAndWriteToOutputStream:&sendErr] && sendErr != nil) {
                    [self sdl_handleOutputStreamWriteError:sendErr];
                }
            }
            
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                     beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.25f]];
        } while (self.accessory != nil &&
                 self.accessory.connected &&
                 ![NSThread currentThread].cancelled);

        NSLog(@"closing accessory session");

        // Close I/O streams of the iAP session
        [self sdl_closeSession];
        _accessory = nil;
          dispatch_semaphore_signal(self.canceledSemaphore);
    }
}

// Must be called on accessoryEventLoop.
- (void)sdl_closeSession {
  if (self.easession) {
    NSLog(@"Close EASession: %tu", self.easession.accessory.connectionID);
    NSInputStream *inStream = [self.easession inputStream];
    NSOutputStream *outStream = [self.easession outputStream];
    
    [self stopStream:inStream];
    [self stopStream:outStream];
    self.easession = nil;
  }
}


#pragma mark - Private Stream Lifecycle Helpers

- (void)startStream:(NSStream *)stream {
    stream.delegate = self.streamDelegate;
    [stream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [stream open];
}

- (void)stopStream:(NSStream *)stream {
    // Verify stream is in a state that can be closed.
    // (N.B. Closing a stream that has not been opened has very, very bad effects.)

    // When you disconect the cable you get a stream end event and come here but stream is already in closed state.
    // Still need to remove from run loop.

    NSUInteger status1 = stream.streamStatus;
    if (status1 != NSStreamStatusNotOpen &&
        status1 != NSStreamStatusClosed) {
        [stream close];
    }

    [stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [stream setDelegate:nil];

    NSUInteger status2 = stream.streamStatus;
    if (status2 == NSStreamStatusClosed) {
        if (stream == [self.easession inputStream]) {
            [SDLDebugTool logInfo:@"Input Stream Closed"];
        } else if (stream == [self.easession outputStream]) {
            [SDLDebugTool logInfo:@"Output Stream Closed"];
        }
    }
}


#pragma mark - Stream Handlers

- (SDLStreamOpenHandler)streamOpenedHandler {
    __weak typeof(self) weakSelf = self;

    return ^(NSStream *stream) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        if (stream == [strongSelf.easession outputStream]) {
            [SDLDebugTool logInfo:@"Output Stream Opened"];
        } else if (stream == [strongSelf.easession inputStream]) {
            [SDLDebugTool logInfo:@"Input Stream Opened"];
        }

        // When both streams are open, session initialization is complete. Let the delegate know.
        if (strongSelf.easession.inputStream.streamStatus == NSStreamStatusOpen &&
            strongSelf.easession.outputStream.streamStatus == NSStreamStatusOpen) {
            [strongSelf.delegate onSessionInitializationCompleteForSession:weakSelf];
        }
    };
}

- (SDLStreamErrorHandler)streamErroredHandler {
    __weak typeof(self) weakSelf = self;

    return ^(NSStream *stream) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        [SDLDebugTool logInfo:@"Stream Error"];
        [strongSelf.delegate onSessionStreamsEnded:strongSelf];
    };
}

- (SDLStreamHasSpaceHandler)streamHasSpaceHandler {
    __weak typeof(self) weakSelf = self;
    
    return ^(NSStream *stream) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (strongSelf.isDataSession) {
            NSError *sendErr = nil;
            
            if (![strongSelf sdl_dequeueAndWriteToOutputStream:&sendErr] && sendErr != nil) {
                [strongSelf sdl_handleOutputStreamWriteError:sendErr];
            }
        }
    };
}

#pragma mark - Lifecycle Destruction

- (void)dealloc {
    self.sendDataQueue = nil;
    self.delegate = nil;
    self.accessory = nil;
    self.protocol = nil;
    self.streamDelegate = nil;
    self.easession = nil;
    self.ioStreamThread =  nil;
    self.canceledSemaphore = nil;
    [SDLDebugTool logInfo:@"SDLIAPSession Dealloc"];
}

@end

NS_ASSUME_NONNULL_END
