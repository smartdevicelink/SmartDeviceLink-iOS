#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAudioStreamManager.h"
#import "SDLError.h"
#import "SDLStreamingAudioManagerMock.h"

QuickSpecBegin(SDLAudioStreamManagerSpec)

describe(@"the audio stream manager", ^{
    __block SDLAudioStreamManager *testManager = nil;
    __block SDLStreamingAudioManagerMock *mockAudioManager = nil;
    __block NSURL *testAudioFileURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"testAudio" withExtension:@"mp3"];
    __block NSData *testAudioFileData = [NSData dataWithContentsOfURL:testAudioFileURL options:0 error:nil];

    beforeEach(^{
        mockAudioManager = [[SDLStreamingAudioManagerMock alloc] init];
        testManager = [[SDLAudioStreamManager alloc] initWithManager:mockAudioManager];
        testManager.delegate = mockAudioManager;
    });

    it(@"should have proper initial vars", ^{
        expect(testManager.delegate).toNot(beNil());
        expect(testManager.playing).to(beFalse());
        expect(testManager.queue).to(beEmpty());

        // Also just double check that we actually have a URL
        expect(testAudioFileURL).toNot(beNil());
    });

    describe(@"when audio streaming is not connected", ^{
        context(@"with a file URL", ^{
            beforeEach(^{
                mockAudioManager.audioConnected = NO;
                [testManager pushWithFileURL:testAudioFileURL];
            });

            describe(@"after attempting to play the file", ^{
                beforeEach(^{
                    [mockAudioManager clearData];
                    [testManager playNextWhenReady];
                });

                it(@"should fail to send data", ^{
                    expect(mockAudioManager.dataSinceClear.length).withTimeout(3.0).to(equal(0));
                    expect(mockAudioManager.error.code).withTimeout(3).toEventually(equal(SDLAudioStreamManagerErrorNotConnected));
                });
            });
        });

        context(@"with a data buffer", ^{
            beforeEach(^{
                mockAudioManager.audioConnected = NO;
                [testManager pushWithData:testAudioFileData];
            });

            describe(@"after attempting to play the file", ^{
                beforeEach(^{
                    [mockAudioManager clearData];
                    [testManager playNextWhenReady];
                });

                it(@"should fail to send data", ^{
                    expect(mockAudioManager.dataSinceClear.length).to(equal(0));
                    expect(mockAudioManager.error.code).to(equal(SDLAudioStreamManagerErrorNotConnected));
                });
            });
        });
    });

    describe(@"after adding an audio file to the queue", ^{
        beforeEach(^{
            mockAudioManager.audioConnected = YES;
            [testManager pushWithFileURL:testAudioFileURL];
        });

        it(@"should have a file in the queue", ^{
            expect(testManager.queue).to(beEmpty());
        });

        describe(@"after attempting to play the file", ^{
            beforeEach(^{
                [mockAudioManager clearData];
                [testManager playNextWhenReady];
            });

            it(@"should be sending data", ^{
                expect(testManager.isPlaying).to(beTrue());
                expect(mockAudioManager.dataSinceClear.length).to(equal(34380));
                expect(mockAudioManager.finishedPlaying).withTimeout(3.0).to(beTrue());
            });
        });

        describe(@"after stopping the manager", ^{
            beforeEach(^{
                [testManager stop];
            });

            it(@"should have an empty queue", ^{
                expect(testManager.queue).to(beEmpty());
            });
        });
    });

    describe(@"after adding an audio buffer to the queue", ^{
        beforeEach(^{
            mockAudioManager.audioConnected = YES;
            [testManager pushWithData:testAudioFileData];
        });

        it(@"should have a file in the queue", ^{
            expect(testManager.queue).toNot(beEmpty());
        });

        describe(@"after attempting to play the audio buffer", ^{
            beforeEach(^{
                [mockAudioManager clearData];
                [testManager playNextWhenReady];
            });

            it(@"should be sending data", ^{
                expect(testManager.isPlaying).to(beTrue());
                expect(mockAudioManager.dataSinceClear.length).to(equal(14838));

                // Fails when it shouldn't, `weakself` goes to nil in `sdl_playNextWhenReady`
                expect(mockAudioManager.finishedPlaying).to(beTrue());
            });
        });

        describe(@"after stopping the manager", ^{
            beforeEach(^{
                [testManager stop];
            });

            it(@"should have an empty queue", ^{
                expect(testManager.queue).to(beEmpty());
            });
        });
    });
});

QuickSpecEnd
