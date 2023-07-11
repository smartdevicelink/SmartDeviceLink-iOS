//
//  SDLCacheFileManagerSpec.m
//  SmartDeviceLinkTests
//
//  Created by James Lapinski on 3/23/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLCacheFileManager.h"
#import "SDLIconArchiveFile.h"
#import "SDLOnSystemRequest.h"

@interface SDLCacheFileManager ()

+ (nullable NSString *)sdl_writeImage:(UIImage *)icon toFilePath:(NSString *)filePath imageURL:(NSString *)urlString;
- (void)sdl_downloadIconFromRequestURL:(NSString *)requestURL withCompletionHandler:(ImageRetrievalCompletionHandler)completion;

@property (weak, nonatomic, nullable) NSURLSession *urlSession;
@property (strong, nonatomic, nullable) NSURLSessionDataTask *dataTask;
@property (strong, nonatomic) NSFileManager *fileManager;

@end

QuickSpecBegin(SDLCacheFileManagerSpec)

describe(@"a cache file manager", ^{
    __block SDLCacheFileManager *testManager = nil;
    __block id testManagerMock = nil;
    __block NSFileManager *mockFileManager = nil;
    __block id mockUnarchiver = nil;
    __block id mockUIImage = nil;
    __block id mockURLSession = nil;
    __block id mockArchiver = nil;
    __block SDLOnSystemRequest *testRequest = nil;
    __block NSString *testURL = nil;
    __block SDLOnSystemRequest *expiredTestRequest = nil;
    __block NSString *testFilePath = nil;
    __block NSString *expiredTestURL = nil;
    __block UIImage *testImage = nil;
    __block SDLIconArchiveFile *testArchiveFile = nil;
    __block SDLLockScreenIconCache *testIconCache = nil;
    __block SDLLockScreenIconCache *testExpiredIconCache = nil;
    __block NSArray<SDLLockScreenIconCache *> *testArchiveFileLockScreenCacheArray = nil;

    beforeEach(^{
        testManager = [[SDLCacheFileManager alloc] init];
        testManagerMock = OCMPartialMock(testManager);

        testFilePath = [[NSBundle bundleForClass:self.class] pathForResource:@"testImagePNG" ofType:@"png"];
        testImage = [UIImage imageNamed:@"testImagePNG" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];

        mockFileManager = OCMStrictClassMock([NSFileManager class]);
        testManager.fileManager = mockFileManager;
        mockUnarchiver = OCMClassMock([NSKeyedUnarchiver class]);

        mockUIImage = OCMClassMock([UIImage class]);
        mockURLSession = OCMClassMock([NSURLSession class]);

        mockArchiver = OCMClassMock([NSKeyedArchiver class]);
    });

    it(@"should initialize properties", ^{
        expect(testManager.urlSession).toNot(beNil());
        expect(testManager.fileManager).toNot(beNil());
    });

    describe(@"request with existing icon", ^{
        beforeEach(^{
            testURL = @"testURL";
            testRequest = [[SDLOnSystemRequest alloc] init];
            testRequest.url = testURL;
            testIconCache = [[SDLLockScreenIconCache alloc] initWithIconUrl:testURL iconFilePath:testFilePath];

            expiredTestURL = @"expiredTestURL";
            expiredTestRequest = [[SDLOnSystemRequest alloc] init];
            expiredTestRequest.url = expiredTestURL;
            testExpiredIconCache = [[SDLLockScreenIconCache alloc] initWithIconUrl:expiredTestURL iconFilePath:testFilePath];
            testExpiredIconCache.lastModifiedDate = [[NSDate date] dateByAddingTimeInterval:-31*24*60*60];

            testArchiveFileLockScreenCacheArray = @[testIconCache,testExpiredIconCache];

            testArchiveFile = [[SDLIconArchiveFile alloc] init];
            testArchiveFile.lockScreenIconCaches = testArchiveFileLockScreenCacheArray;

            OCMStub(ClassMethod([mockUnarchiver unarchiveObjectWithFile:[OCMArg any]])).andReturn(testArchiveFile);
            OCMStub([mockFileManager fileExistsAtPath:[OCMArg any]]).andReturn(YES);
        });

        context(@"icon is not expired", ^{
            __block UIImage *resultImage = nil;
            __block NSError *resultError = nil;

            context(@"failure to retrieve icon", ^{
                beforeEach(^{
                    OCMStub(ClassMethod([mockArchiver archiveRootObject:[OCMArg isNotNil] toFile:[OCMArg isNotNil]])).andReturn(YES);
                    OCMStub(ClassMethod([testManagerMock sdl_writeImage:[OCMArg isNotNil] toFilePath:[OCMArg isNotNil] imageURL:[OCMArg isNotNil]])).andReturn(testFilePath);
                    OCMStub([testManagerMock sdl_downloadIconFromRequestURL:[OCMArg isNotNil] withCompletionHandler:([OCMArg invokeBlockWithArgs:testImage, [NSNull null], nil])]);
                    OCMStub([mockFileManager contentsOfDirectoryAtPath:[OCMArg isNotNil] error:[OCMArg anyObjectRef]]);
                    OCMStub(ClassMethod([mockUIImage imageWithContentsOfFile:[OCMArg isNotNil]])).andReturn(nil);
                    [testManager retrieveImageForRequest:testRequest withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
                        resultImage = image;
                        resultError = error;
                    }];
                });

                it(@"should download and return image with no error", ^{
                    expect(resultImage).to(equal(testImage));
                    expect(resultError).to(beNil());
                });
            });

            context(@"retrieve icon success", ^{
                beforeEach(^{
                    OCMStub(ClassMethod([mockUIImage imageWithContentsOfFile:[OCMArg isNotNil]])).andReturn(testImage);
                    [testManager retrieveImageForRequest:testRequest withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
                        resultImage = image;
                        resultError = error;
                    }];
                });

                it(@"should return retrieved image and no error", ^{
                    expect(resultImage).to(equal(testImage));
                    expect(resultError).to(beNil());
                });
            });
        });

        context(@"request with expired icon", ^{
            __block UIImage *resultImage = nil;
            __block NSError *resultError = nil;

            context(@"image download succeeds", ^{
                context(@"Failed to update archive object", ^{
                    beforeEach(^{
                        OCMStub(ClassMethod([mockArchiver archiveRootObject:[OCMArg isNotNil] toFile:[OCMArg isNotNil]])).andReturn(NO);
                        OCMStub(ClassMethod([testManagerMock sdl_writeImage:[OCMArg isNotNil] toFilePath:[OCMArg isNotNil] imageURL:[OCMArg isNotNil]])).andReturn(testFilePath);
                        OCMStub([testManagerMock sdl_downloadIconFromRequestURL:[OCMArg isNotNil] withCompletionHandler:([OCMArg invokeBlockWithArgs:testImage, [NSNull null], nil])]);

                        [testManager retrieveImageForRequest:expiredTestRequest withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
                            resultImage = image;
                            resultError = error;
                        }];
                    });

                    it(@"it should return downloaded image and no error", ^{
                        expect(resultImage).to(equal(testImage));
                        expect(resultError).to(beNil());
                    });
                });

                context(@"write image to file path succeeds", ^{
                    beforeEach(^{
                        OCMStub(ClassMethod([mockArchiver archiveRootObject:[OCMArg isNotNil] toFile:[OCMArg isNotNil]])).andReturn(YES);
                        OCMStub(ClassMethod([testManagerMock sdl_writeImage:[OCMArg isNotNil] toFilePath:[OCMArg isNotNil] imageURL:[OCMArg isNotNil]])).andReturn(testFilePath);
                        OCMStub([testManagerMock sdl_downloadIconFromRequestURL:[OCMArg isNotNil] withCompletionHandler:([OCMArg invokeBlockWithArgs:testImage, [NSNull null], nil])]);

                        [testManager retrieveImageForRequest:expiredTestRequest withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
                            resultImage = image;
                            resultError = error;
                        }];
                    });

                    it(@"it should return downloaded image and no error", ^{
                        expect(resultImage).to(equal(testImage));
                        expect(resultError).to(beNil());
                    });
                });

                context(@"write image to file path fails", ^{
                    beforeEach(^{
                        OCMStub(ClassMethod([testManagerMock sdl_writeImage:[OCMArg isNotNil] toFilePath:[OCMArg isNotNil] imageURL:[OCMArg isNotNil]])).andReturn(nil);
                        OCMStub([testManagerMock sdl_downloadIconFromRequestURL:[OCMArg isNotNil] withCompletionHandler:([OCMArg invokeBlockWithArgs:testImage, [NSNull null], nil])]);

                        [testManager retrieveImageForRequest:expiredTestRequest withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
                            resultImage = image;
                            resultError = error;
                        }];
                    });

                    it(@"it should return downloaded image and no error", ^{
                        expect(resultImage).to(equal(testImage));
                        expect(resultError).to(beNil());
                    });
                });
            });

            context(@"image download fails", ^{
                __block NSError *imageDownloadError = [NSError errorWithDomain:@"test" code:0 userInfo:nil];

                beforeEach(^{
                    OCMStub([mockURLSession dataTaskWithURL:[OCMArg isNotNil] completionHandler:([OCMArg invokeBlockWithArgs:[NSNull null], [NSNull null], imageDownloadError, nil])]);
                    OCMStub([testManagerMock sdl_downloadIconFromRequestURL:[OCMArg isNotNil] withCompletionHandler:([OCMArg invokeBlockWithArgs:[NSNull null], imageDownloadError, nil])]);

                    [testManager retrieveImageForRequest:expiredTestRequest withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
                        resultImage = image;
                        resultError = error;
                    }];
                });

                it(@"it should return error and no image", ^{
                    expect(resultImage).to(beNil());
                    expect(resultError).toNot(beNil());
                });
            });
        });
    });

    describe(@"Receiving a new icon", ^{
        __block SDLOnSystemRequest *newIconRequest = nil;
        __block NSString *newIconURL = nil;

        beforeEach(^{
            newIconURL = @"newURL";
            newIconRequest = [[SDLOnSystemRequest alloc] init];
            newIconRequest.url = newIconURL;
        });

        context(@"When no directory is present", ^{
            __block UIImage *resultImage = nil;
            __block NSError *resultError = nil;

            beforeEach(^{
                OCMStub(ClassMethod([mockArchiver archiveRootObject:[OCMArg isNotNil] toFile:[OCMArg isNotNil]])).andReturn(YES);
                OCMStub(ClassMethod([testManagerMock sdl_writeImage:[OCMArg isNotNil] toFilePath:[OCMArg isNotNil] imageURL:[OCMArg isNotNil]])).andReturn(testFilePath);
                OCMStub([testManagerMock sdl_downloadIconFromRequestURL:[OCMArg isNotNil] withCompletionHandler:([OCMArg invokeBlockWithArgs:testImage, [NSNull null], nil])]);
                OCMStub([mockFileManager contentsOfDirectoryAtPath:[OCMArg isNotNil] error:[OCMArg anyObjectRef]]);
                OCMStub([mockFileManager createDirectoryAtPath:[OCMArg isNotNil] withIntermediateDirectories:[OCMArg any] attributes:[OCMArg any] error:[OCMArg anyObjectRef]]).andReturn(YES);
                OCMStub([mockFileManager fileExistsAtPath:[OCMArg any]]).andReturn(NO);

                [testManager retrieveImageForRequest:newIconRequest withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
                    resultImage = image;
                    resultError = error;
                }];
            });

            it(@"it should return downloaded image and no error", ^{
                expect(resultImage).to(equal(testImage));
                expect(resultError).to(beNil());
            });
        });

        context(@"When directory is present", ^{
            __block UIImage *resultImage = nil;
            __block NSError *resultError = nil;

            beforeEach(^{
                OCMStub(ClassMethod([mockArchiver archiveRootObject:[OCMArg isNotNil] toFile:[OCMArg isNotNil]])).andReturn(YES);
                OCMStub(ClassMethod([testManagerMock sdl_writeImage:[OCMArg isNotNil] toFilePath:[OCMArg isNotNil] imageURL:[OCMArg isNotNil]])).andReturn(testFilePath);
                OCMStub([testManagerMock sdl_downloadIconFromRequestURL:[OCMArg isNotNil] withCompletionHandler:([OCMArg invokeBlockWithArgs:testImage, [NSNull null], nil])]);

                testArchiveFile = [[SDLIconArchiveFile alloc] init];
                testArchiveFile.lockScreenIconCaches = testArchiveFileLockScreenCacheArray;
            });

            context(@"no archive file present", ^{
                beforeEach(^{
                    OCMStub([mockFileManager contentsOfDirectoryAtPath:[OCMArg isNotNil] error:[OCMArg anyObjectRef]]).andReturn(nil);
                    OCMStub([mockFileManager fileExistsAtPath:[OCMArg any]]).andReturn(YES);

                    [testManager retrieveImageForRequest:newIconRequest withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
                        resultImage = image;
                        resultError = error;
                    }];
                });

                it(@"it should return downloaded image and no error", ^{
                    expect(resultImage).to(equal(testImage));
                    expect(resultError).to(beNil());
                });
            });

            context(@"archive file present", ^{
                context(@"remove item success", ^{
                    beforeEach(^{
                        OCMStub([mockFileManager removeItemAtPath:[OCMArg isNotNil] error:[OCMArg anyObjectRef]]).andReturn(YES);
                        OCMStub([mockFileManager contentsOfDirectoryAtPath:[OCMArg isNotNil] error:[OCMArg anyObjectRef]]).andReturn(@[@"iconArchiveFile"]);
                        OCMStub([mockFileManager fileExistsAtPath:[OCMArg any]]).andReturn(YES);

                        [testManager retrieveImageForRequest:newIconRequest withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
                            resultImage = image;
                            resultError = error;
                        }];
                    });

                    it(@"it should return downloaded image and no error", ^{
                        expect(resultImage).to(equal(testImage));
                        expect(resultError).to(beNil());
                    });
                });

                context(@"remove item fails", ^{
                    beforeEach(^{
                        OCMStub([mockFileManager removeItemAtPath:[OCMArg isNotNil] error:[OCMArg anyObjectRef]]).andReturn(NO);
                        OCMStub([mockFileManager contentsOfDirectoryAtPath:[OCMArg isNotNil] error:[OCMArg anyObjectRef]]).andReturn(@[@"iconArchiveFile"]);
                        OCMStub([mockFileManager fileExistsAtPath:[OCMArg any]]).andReturn(YES);

                        [testManager retrieveImageForRequest:newIconRequest withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
                            resultImage = image;
                            resultError = error;
                        }];
                    });

                    it(@"it should return downloaded image and no error", ^{
                        expect(resultImage).to(equal(testImage));
                        expect(resultError).to(beNil());
                    });
                });
            });
        });
    });
});

QuickSpecEnd
