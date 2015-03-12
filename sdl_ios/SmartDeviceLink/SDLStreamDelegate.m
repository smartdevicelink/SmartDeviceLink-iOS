//
//  SDLtreamDelegate.m
//
//  Copyright (c) 2014 FMC. All rights reserved.
//

#import "SDLDebugTool.h"
#import "SDLStreamDelegate.h"

@interface SDLStreamDelegate () {
    dispatch_queue_t _input_stream_queue;
}

@end


@implementation SDLStreamDelegate

- (instancetype)init
{
    self = [super init];
    if (self) {
        _streamOpenHandler = defaultStreamOpenHandler;
        _streamHasBytesHandler = defaultStreamHasBytesHandler;
        _streamHasSpaceHandler = defaultStreamHasSpaceHandler;
        _streamErrorHandler = defaultStreamErrorHandler;
        _streamEndHandler = defaultStreamErrorHandler;

        _input_stream_queue = dispatch_queue_create("com.ford.applink.session.inputreader", DISPATCH_QUEUE_SERIAL);
        dispatch_queue_t high = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_set_target_queue(_input_stream_queue, high);
    }
    return self;
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode
{

    switch(eventCode)
    {
        case NSStreamEventOpenCompleted:
        {
            if (_streamOpenHandler) {
                self.streamOpenHandler(stream);
            }
            break;
        }
        case NSStreamEventHasBytesAvailable:
        {
            if (_streamHasBytesHandler) {
                dispatch_async(_input_stream_queue, ^{
                    self.streamHasBytesHandler((NSInputStream *)stream);
                });
            }
            break;
        }
        case NSStreamEventHasSpaceAvailable:
        {
            if (_streamHasSpaceHandler) {
                self.streamHasSpaceHandler((NSOutputStream *)stream);
            }
            break;
        }
        case NSStreamEventErrorOccurred:
        {
            if (_streamErrorHandler) {
                self.streamErrorHandler(stream);
            }
            break;
        }
        case NSStreamEventEndEncountered:
        {
            if (_streamEndHandler) {
                self.streamEndHandler(stream);
            }
            break;
        }
        case NSStreamEventNone:
        default:
        {
            break;
        }
    }
}

SDLStreamOpenHandler defaultStreamOpenHandler = ^(NSStream *stream) {
    [SDLDebugTool logInfo:@"Stream Event Open"];
};

SDLStreamHasBytesHandler defaultStreamHasBytesHandler = ^(NSInputStream *istream) {
    [SDLDebugTool logInfo:@"Stream Event Has Bytes"];
};

SDLStreamHasSpaceHandler defaultStreamHasSpaceHandler = ^(NSOutputStream *ostream) {

};

SDLStreamErrorHandler defaultStreamErrorHandler = ^(NSStream *stream) {
    [SDLDebugTool logInfo:@"Stream Event Error"];
};

SDLStreamEndHandler defaultStreamEndHandler = ^(NSStream *stream) {
    [SDLDebugTool logInfo:@"Stream Event End"];
};

@end

