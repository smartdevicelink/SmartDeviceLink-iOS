//  SDLTCPTransport.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import "SDLTCPTransport.h"
#import "SDLDebugTool.h"
#import <errno.h>
#import <signal.h>
#import <stdio.h>
#import <unistd.h>
#import <sys/types.h>
#import <sys/socket.h>
#import <sys/wait.h>
#import <netinet/in.h>
#import <netdb.h>
#import "SDLHexUtility.h"

int call_socket(const char* hostname, const char* port) { 
    
    int status, sock;
    struct addrinfo hints;
    struct addrinfo* servinfo;
    
    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    
    //no host name?, no problem, get local host
    if (hostname == nil){
        char localhost[128];
        gethostname(localhost, sizeof localhost);
        hostname = (const char*) &localhost;
    }
    
    //getaddrinfo setup
    if ((status = getaddrinfo(hostname, port, &hints, &servinfo)) != 0) {
        fprintf(stderr, "getaddrinfo error: %s\n", gai_strerror(status));
        return(-1);
    }
    
    //get socket
    if ((sock = socket(servinfo->ai_family, servinfo->ai_socktype, servinfo->ai_protocol)) < 0)
		return(-1);
    
    //connect
    if (connect(sock, servinfo->ai_addr, servinfo->ai_addrlen) < 0) {
		close(sock);
		return(-1);
	}
    
    freeaddrinfo(servinfo); // free the linked-list
    return(sock);
} 

@implementation SDLTCPTransport

static void TCPCallback(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info) {
	if (kCFSocketConnectCallBack == type) {
		SDLTCPTransport *transport = (__bridge SDLTCPTransport *)info;
		SInt32 errorNumber = 0;
		if (data) {
			SInt32 *errorNumberPtr = (SInt32 *)data;
			errorNumber = *errorNumberPtr;
		}
		[transport notifyTransportConnected];
	} else if (kCFSocketDataCallBack == type) {
		SDLTCPTransport *transport = (__bridge SDLTCPTransport *)info;
        
        NSMutableString* byteStr = [NSMutableString stringWithCapacity:((int)CFDataGetLength((CFDataRef)data) * 2)];
        for (int i = 0; i < (int)CFDataGetLength((CFDataRef)data); i++) {
            [byteStr appendFormat:@"%02X", ((Byte*)(UInt8 *)CFDataGetBytePtr((CFDataRef)data))[i]];
        }
        
        [SDLDebugTool logInfo:[NSString stringWithFormat:@"Read %d bytes: %@", (int)CFDataGetLength((CFDataRef)data), byteStr] withType:SDLDebugType_Transport_TCP toOutput:SDLDebugOutput_DeviceConsole];
        
        [transport handleDataReceivedFromTransport:[NSData dataWithBytes:(UInt8 *)CFDataGetBytePtr((CFDataRef)data) length:(int)CFDataGetLength((CFDataRef)data)]];
    } else {
        NSString *logMessage = [NSString stringWithFormat:@"unhandled TCPCallback: %lu", type];
		[SDLDebugTool logInfo:logMessage withType:SDLDebugType_Transport_TCP toOutput:SDLDebugOutput_DeviceConsole];
	}
}

- (void) connect {
    
    [SDLDebugTool logInfo:@"Init" withType:SDLDebugType_Transport_TCP];

    int sock_fd = call_socket([self.endpointName UTF8String], [self.endpointParam UTF8String]);
	if (sock_fd < 0) {
        
        [SDLDebugTool logInfo:@"Server Not Ready, Connection Failed" withType:SDLDebugType_Transport_TCP];
        return;
	}
	
	CFSocketContext socketCtxt = {0, (__bridge void *)(self), NULL, NULL, NULL};
	socket = CFSocketCreateWithNative(kCFAllocatorDefault, sock_fd, kCFSocketDataCallBack|kCFSocketConnectCallBack , (CFSocketCallBack) &TCPCallback, &socketCtxt);
	CFRunLoopSourceRef source = CFSocketCreateRunLoopSource(kCFAllocatorDefault, socket, 0);
	CFRunLoopRef loop = CFRunLoopGetCurrent();
	CFRunLoopAddSource(loop, source, kCFRunLoopDefaultMode);
	CFRelease(source);
}

- (void) sendData:(NSData*) msgBytes {

	NSString* byteStr = [SDLHexUtility getHexString:msgBytes];
    [SDLDebugTool logInfo:[NSString stringWithFormat:@"Sent %lu bytes: %@", (unsigned long)msgBytes.length, byteStr] withType:SDLDebugType_Transport_TCP toOutput:SDLDebugOutput_DeviceConsole];

    CFSocketError e = CFSocketSendData(socket, NULL, (__bridge CFDataRef)msgBytes, 10000);
    if (e != kCFSocketSuccess) {
        NSString *errorCause = nil;
        switch (e) {
            case kCFSocketTimeout:
                errorCause = @"Socket Timeout Error.";
                break;

            case kCFSocketError:
                default:
                errorCause = @"Socket Error.";
                break;
        }
        
        [SDLDebugTool logInfo:[NSString stringWithFormat:@"Socket sendData error: %@", errorCause] withType:SDLDebugType_Transport_TCP toOutput:SDLDebugOutput_DeviceConsole];
    }

}

- (void) dealloc {
	if (socket != nil) {
		CFSocketInvalidate(socket);
		CFRelease(socket);
	}
}

@end
