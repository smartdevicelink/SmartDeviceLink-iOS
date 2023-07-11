//
//  SDLAsynchronousRPCOperationSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/20/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAppServiceData.h"
#import "SDLAsynchronousRPCOperation.h"
#import "SDLGetAppServiceDataResponse.h"
#import "SDLGlobals.h"
#import "TestConnectionManager.h"
#import "SDLExpect.h"

QuickSpecBegin(SDLAsynchronousRPCOperationSpec)

describe(@"sending responses and notifications", ^{
    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLAsynchronousRPCOperation *testOperation = nil;
    __block NSOperationQueue *testOperationQueue = nil;

    beforeEach(^{
        testOperation = nil;
        testConnectionManager = [[TestConnectionManager alloc] init];

        testOperationQueue = [[NSOperationQueue alloc] init];
        testOperationQueue.name = @"com.sdl.RPCResponse.testqueue";
        testOperationQueue.underlyingQueue = [SDLGlobals sharedGlobals].sdlProcessingQueue;
    });

    context(@"when a single request succeeds", ^{
        __block __kindof SDLRPCMessage *sendRPC = nil;

        beforeEach(^{
            sendRPC = [[SDLGetAppServiceDataResponse alloc] initWithAppServiceData:[[SDLAppServiceData alloc] init]];
        });

        it(@"should correctly send the rpc", ^{
            testOperation = [[SDLAsynchronousRPCOperation alloc] initWithConnectionManager:testConnectionManager rpc:sendRPC];
            [testOperationQueue addOperation:testOperation];

            sleep(SDLExpect.timeout);
            expect(testConnectionManager.receivedRequests).to(contain(sendRPC));
        });
    });

    context(@"when multiple request succeed", ^{
        __block NSMutableArray< __kindof SDLRPCMessage *> *sendRPCs = nil;
        int rpcCount = 9;

        beforeEach(^{
            sendRPCs = [NSMutableArray array];
            for (int i = 0; i < rpcCount; i += 1) {
                [sendRPCs addObject:[[SDLGetAppServiceDataResponse alloc] initWithAppServiceData:[[SDLAppServiceData alloc] init]]];
            }
        });

        it(@"should correctly send all of the rpcs", ^{
            for (int i = 0; i < rpcCount; i += 1) {
                testOperation = [[SDLAsynchronousRPCOperation alloc] initWithConnectionManager:testConnectionManager rpc:sendRPCs[i]];
                [testOperationQueue addOperation:testOperation];
            }

//            sleep(SDLExpect.timeout);
//            [SDLExpect SDLExpectWithTimeout:SDLExpect.timeout expectBlock:^{
            [NSThread sleepForTimeInterval:0.5];
                expect(testConnectionManager.receivedRequests.count).to(equal(rpcCount));
                expect(testConnectionManager.receivedRequests).to(equal(sendRPCs));
//            }];
        });
    });

    context(@"when a requst is cancelled", ^{
        __block __kindof SDLRPCMessage *sendRPC = nil;

        beforeEach(^{
            sendRPC = [[SDLGetAppServiceDataResponse alloc] initWithAppServiceData:[[SDLAppServiceData alloc] init]];
        });

        it(@"should not send the rpc", ^{
            testOperation = [[SDLAsynchronousRPCOperation alloc] initWithConnectionManager:testConnectionManager rpc:sendRPC];

            [testOperationQueue setSuspended:YES];
            [testOperationQueue addOperation:testOperation];
            [testOperationQueue cancelAllOperations];
            [testOperationQueue setSuspended:NO];

            expect(testConnectionManager.receivedRequests).withTimeout(3.0).to(beEmpty());
        });
    });
});

QuickSpecEnd

