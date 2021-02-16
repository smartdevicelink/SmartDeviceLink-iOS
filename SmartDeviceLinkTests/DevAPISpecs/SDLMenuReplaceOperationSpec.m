//
//  SDLMenuReplaceOperationSpec.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 2/16/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>
#import <Quick/Quick.h>

#import <SmartDeviceLink/SmartDeviceLink.h>
#import "SDLMenuReplaceOperation.h"
#import "TestConnectionManager.h"

QuickSpecBegin(SDLMenuReplaceOperationSpec)

describe(@"a menu replace operation", ^{
    __block SDLMenuReplaceOperation *testOp = nil;

    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLFileManager *testFileManager = nil;
    __block SDLWindowCapability *testWindowCapability = nil;
    __block SDLMenuConfiguration *testMenuConfiguration = nil;
    __block NSArray<SDLMenuCell *> *testCurrentMenu = nil;
    __block NSArray<SDLMenuCell *> *testNewMenu = nil;

//    describe(@"sending menu cells", ^{
//        it(@"should check if all artworks are uploaded and return NO", ^{
//            textAndImageCell = [[SDLMenuCell alloc] initWithTitle:@"Test 2" icon:testArtwork3 voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
//            testManager.menuCells = @[textAndImageCell, textOnlyCell];
//            OCMVerify([testManager sdl_shouldRPCsIncludeImages:testManager.menuCells]);
//            expect([testManager sdl_shouldRPCsIncludeImages:testManager.menuCells]).to(beFalse());
//        });
//
//        it(@"should properly update a text cell", ^{
//            testManager.menuCells = @[textOnlyCell];
//
//            NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLDeleteCommand class]];
//            NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];
//            expect(deletes).to(beEmpty());
//
//            NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddCommand class]];
//            NSArray *add = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];
//            expect(add).toNot(beEmpty());
//        });
//
//        it(@"should properly update with subcells", ^{
//            OCMStub([mockFileManager uploadArtworks:[OCMArg any] completionHandler:[OCMArg invokeBlock]]);
//            testManager.menuCells = @[submenuCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddCommand class]];
//            NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];
//
//            NSPredicate *submenuCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddSubMenu class]];
//            NSArray *submenus = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:submenuCommandPredicate];
//
//            expect(adds).to(haveCount(2));
//            expect(submenus).to(haveCount(1));
//        });
//    });
//
//    describe(@"updating with an image", ^{
//        context(@"when the image is already on the head unit", ^{
//            beforeEach(^{
//                OCMStub([mockFileManager hasUploadedFile:[OCMArg isNotNil]]).andReturn(YES);
//            });
//
//            it(@"should check if all artworks are uploaded", ^{
//                textAndImageCell = [[SDLMenuCell alloc] initWithTitle:@"Test 2" icon:testArtwork3 voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
//                testManager.menuCells = @[textAndImageCell, textOnlyCell];
//                OCMVerify([testManager sdl_shouldRPCsIncludeImages:testManager.menuCells]);
//                expect([testManager sdl_shouldRPCsIncludeImages:testManager.menuCells]).to(beTrue());
//            });
//
//            it(@"should properly update an image cell", ^{
//                testManager.menuCells = @[textAndImageCell, submenuImageCell];
//
//                NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddCommand class]];
//                NSArray *add = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];
//                SDLAddCommand *sentCommand = add.firstObject;
//
//                NSPredicate *addSubmenuPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddSubMenu class]];
//                NSArray *submenu = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addSubmenuPredicate];
//                SDLAddSubMenu *sentSubmenu = submenu.firstObject;
//
//                expect(add).to(haveCount(1));
//                expect(submenu).to(haveCount(1));
//                expect(sentCommand.cmdIcon.value).to(equal(testArtwork.name));
//                expect(sentSubmenu.menuIcon.value).to(equal(testArtwork2.name));
//                OCMReject([mockFileManager uploadArtworks:[OCMArg any] completionHandler:[OCMArg any]]);
//            });
//
//            it(@"should properly overwrite an image cell", ^{
//                OCMStub([mockFileManager fileNeedsUpload:[OCMArg isNotNil]]).andReturn(YES);
//                textAndImageCell = [[SDLMenuCell alloc] initWithTitle:@"Test 2" icon:testArtwork3 voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
//                testManager.menuCells = @[textAndImageCell, submenuImageCell];
//                OCMVerify([mockFileManager uploadArtworks:[OCMArg any] completionHandler:[OCMArg any]]);
//            });
//        });
//
//        // No longer a valid unit test
//        context(@"when the image is not on the head unit", ^{
//            beforeEach(^{
//                testManager.dynamicMenuUpdatesMode = SDLDynamicMenuUpdatesModeForceOff;
//                OCMStub([mockFileManager uploadArtworks:[OCMArg any] completionHandler:[OCMArg invokeBlock]]);
//            });
//
//            it(@"should wait till image is on head unit and attempt to update without the image", ^{
//                testManager.menuCells = @[textAndImageCell, submenuImageCell];
//
//                NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddCommand class]];
//                NSArray *add = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];
//                SDLAddCommand *sentCommand = add.firstObject;
//
//                NSPredicate *addSubmenuPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddSubMenu class]];
//                NSArray *submenu = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addSubmenuPredicate];
//                SDLAddSubMenu *sentSubmenu = submenu.firstObject;
//
//                expect(add).to(haveCount(1));
//                expect(submenu).to(haveCount(1));
//                expect(sentCommand.cmdIcon.value).to(beNil());
//                expect(sentSubmenu.menuIcon.value).to(beNil());
//            });
//        });
//    });
//
//    describe(@"updating when a menu already exists with dynamic updates on", ^{
//        beforeEach(^{
//            testManager.dynamicMenuUpdatesMode = SDLDynamicMenuUpdatesModeForceOn;
//            OCMStub([mockFileManager uploadArtworks:[OCMArg any] completionHandler:[OCMArg invokeBlock]]);
//        });
//
//        it(@"should send deletes first", ^{
//            testManager.menuCells = @[textOnlyCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            testManager.menuCells = @[textAndImageCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
//            NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];
//
//            NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
//            NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];
//
//            expect(deletes).to(haveCount(1));
//            expect(adds).to(haveCount(2));
//        });
//
//        it(@"should send dynamic deletes first then dynamic adds case with 2 submenu cells", ^{
//            testManager.menuCells = @[textOnlyCell, submenuCell, submenuImageCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            testManager.menuCells = @[submenuCell, submenuImageCell, textOnlyCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
//            NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];
//
//            NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
//            NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];
//
//            NSPredicate *addSubmenuPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddSubMenu class]];
//            NSArray *submenu = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addSubmenuPredicate];
//
//            expect(deletes).to(haveCount(1));
//            expect(adds).to(haveCount(5));
//            expect(submenu).to(haveCount(2));
//        });
//
//        it(@"should send dynamic deletes first then dynamic adds when removing one submenu cell", ^{
//            testManager.menuCells = @[textOnlyCell, textAndImageCell, submenuCell, submenuImageCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            testManager.menuCells = @[textOnlyCell, textAndImageCell, submenuCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
//            NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];
//
//            NSPredicate *deleteSubCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteSubMenu class]];
//            NSArray *subDeletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteSubCommandPredicate];
//
//            NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
//            NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];
//
//            NSPredicate *addSubmenuPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddSubMenu class]];
//            NSArray *submenu = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addSubmenuPredicate];
//
//            expect(deletes).to(haveCount(0));
//            expect(subDeletes).to(haveCount(1));
//            expect(adds).to(haveCount(5));
//            expect(submenu).to(haveCount(2));
//        });
//
//        it(@"should send dynamic deletes first then dynamic adds when adding one new cell", ^{
//            testManager.menuCells = @[textOnlyCell, textAndImageCell, submenuCell, submenuImageCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            testManager.menuCells = @[textOnlyCell, textAndImageCell, submenuCell, submenuImageCell, textOnlyCell2];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
//            NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];
//
//            NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
//            NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];
//
//            NSPredicate *addSubmenuPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddSubMenu class]];
//            NSArray *submenu = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addSubmenuPredicate];
//
//            expect(deletes).to(haveCount(0));
//            expect(adds).to(haveCount(6));
//            expect(submenu).to(haveCount(2));
//        });
//
//        it(@"should send dynamic deletes first then dynamic adds when cells stay the same", ^{
//            testManager.menuCells = @[textOnlyCell, textOnlyCell2, textAndImageCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            testManager.menuCells = @[textOnlyCell, textOnlyCell2, textAndImageCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
//            NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];
//
//            NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
//            NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];
//
//            expect(deletes).to(haveCount(0));
//            expect(adds).to(haveCount(3));
//        });
//    });
//
//    describe(@"updating when a menu already exists with dynamic updates off", ^{
//        beforeEach(^{
//             testManager.dynamicMenuUpdatesMode = SDLDynamicMenuUpdatesModeForceOff;
//             OCMStub([mockFileManager uploadArtworks:[OCMArg any] completionHandler:[OCMArg invokeBlock]]);
//        });
//
//        it(@"should send deletes first", ^{
//            testManager.menuCells = @[textOnlyCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            testManager.menuCells = @[textAndImageCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
//            NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];
//
//            NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
//            NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];
//
//            expect(deletes).to(haveCount(1));
//            expect(adds).to(haveCount(2));
//        });
//
//        it(@"should deletes first case 2", ^{
//            testManager.menuCells = @[textOnlyCell, textAndImageCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            testManager.menuCells = @[textAndImageCell, textOnlyCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
//            NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];
//
//            NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
//            NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];
//
//            expect(deletes).to(haveCount(2));
//            expect(adds).to(haveCount(4));
//        });
//
//        it(@"should send deletes first case 3", ^{
//            testManager.menuCells = @[textOnlyCell, textAndImageCell, submenuCell, submenuImageCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            testManager.menuCells = @[textOnlyCell, textAndImageCell, submenuCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
//            NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];
//
//            NSPredicate *deleteSubCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteSubMenu class]];
//            NSArray *subDeletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteSubCommandPredicate];
//
//            NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
//            NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];
//
//            NSPredicate *addSubmenuPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddSubMenu class]];
//            NSArray *submenu = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addSubmenuPredicate];
//
//            expect(deletes).to(haveCount(2));
//            expect(subDeletes).to(haveCount(2));
//            expect(adds).to(haveCount(9));
//            expect(submenu).to(haveCount(3));
//        });
//
//        it(@"should send deletes first case 4", ^{
//            testManager.menuCells = @[textOnlyCell, textAndImageCell, submenuCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            testManager.menuCells = @[textOnlyCell, textAndImageCell, submenuCell, textOnlyCell2];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//
//            NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
//            NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];
//
//            NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
//            NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];
//
//            NSPredicate *addSubmenuPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddSubMenu class]];
//            NSArray *submenu = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addSubmenuPredicate];
//
//            NSPredicate *deleteSubCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteSubMenu class]];
//            NSArray *subDeletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteSubCommandPredicate];
//
//            expect(deletes).to(haveCount(2));
//            expect(adds).to(haveCount(9));
//            expect(submenu).to(haveCount(2));
//            expect(subDeletes).to(haveCount(1));
//        });
//
//        it(@"should deletes first case 5", ^{
//            testManager.menuCells = @[textOnlyCell, textOnlyCell2, textAndImageCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            testManager.menuCells = @[textOnlyCell, textOnlyCell2, textAndImageCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
//            NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];
//
//            NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
//            NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];
//
//            expect(deletes).to(haveCount(3));
//            expect(adds).to(haveCount(6));
//        });
//    });
});

QuickSpecEnd