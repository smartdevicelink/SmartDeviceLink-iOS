//
//  SDLChoiceSet.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/21/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLChoiceSet.h"

#import "SDLChoiceCell.h"
#import "SDLLogMacros.h"
#import "SDLTTSChunk.h"
#import "SDLVrHelpItem.h"
#import "SDLVersion.h"
#import "SDLGlobals.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLChoiceSet()

@property (nullable, copy, nonatomic) SDLChoiceSetCanceledHandler canceledHandler;

@end

@implementation SDLChoiceSet

static NSTimeInterval _defaultTimeout = 10.0;
static SDLChoiceSetLayout _defaultLayout = SDLChoiceSetLayoutList;

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _timeout = self.class.defaultTimeout;
    _layout = self.class.defaultLayout;

    return self;
}

- (instancetype)initWithTitle:(NSString *)title delegate:(id<SDLChoiceSetDelegate>)delegate choices:(NSArray<SDLChoiceCell *> *)choices {
    return [self initWithTitle:title delegate:delegate layout:SDLChoiceSet.defaultLayout timeout:SDLChoiceSet.defaultTimeout initialPrompt:nil timeoutPrompt:nil helpPrompt:nil vrHelpList:nil choices:choices];
}

- (instancetype)initWithTitle:(NSString *)title delegate:(id<SDLChoiceSetDelegate>)delegate layout:(SDLChoiceSetLayout)layout timeout:(NSTimeInterval)timeout initialPromptString:(nullable NSString *)initialPrompt timeoutPromptString:(nullable NSString *)timeoutPrompt helpPromptString:(nullable NSString *)helpPrompt vrHelpList:(nullable NSArray<SDLVRHelpItem *> *)helpList choices:(NSArray<SDLChoiceCell *> *)choices {
    NSArray<SDLTTSChunk *> *initialTTS = [SDLTTSChunk textChunksFromString:initialPrompt];
    NSArray<SDLTTSChunk *> *timeoutTTS = [SDLTTSChunk textChunksFromString:timeoutPrompt];
    NSArray<SDLTTSChunk *> *helpTTS = [SDLTTSChunk textChunksFromString:helpPrompt];

    return [self initWithTitle:title delegate:delegate layout:layout timeout:timeout initialPrompt:initialTTS timeoutPrompt:timeoutTTS helpPrompt:helpTTS vrHelpList:helpList choices:choices];
}

- (instancetype)initWithTitle:(NSString *)title delegate:(id<SDLChoiceSetDelegate>)delegate layout:(SDLChoiceSetLayout)layout timeout:(NSTimeInterval)timeout initialPrompt:(nullable NSArray<SDLTTSChunk *> *)initialPrompt timeoutPrompt:(nullable NSArray<SDLTTSChunk *> *)timeoutPrompt helpPrompt:(nullable NSArray<SDLTTSChunk *> *)helpPrompt vrHelpList:(nullable NSArray<SDLVRHelpItem *> *)helpList choices:(NSArray<SDLChoiceCell *> *)choices {
    self = [self init];
    if (!self) { return nil; }

    if (choices.count == 0 || choices.count > 100) {
        SDLLogW(@"Attempted to create a choice set with %lu choices; Only 1 - 100 choices are valid", (unsigned long)choices.count);
        return nil;
    }

    if (timeout < 5 || timeout > 100) {
        SDLLogW(@"Attempted to create a choice set with a %f second timeout; Only 5 - 100 seconds is valid", timeout);
        return nil;
    }

    if (title.length == 0 || title.length > 500) {
        SDLLogW(@"Attempted to create a choice set title with a %lu length. Only 500 characters are supported", (unsigned long)title.length);
        return nil;
    }

    if (![self sdl_choiceCellsAreUnique:choices]) { return nil; }

    for (NSUInteger i = 0; i < helpList.count; i++) {
        helpList[i].position = @(i + 1);
    }

    _title = title;
    _delegate = delegate;
    _layout = layout;
    _timeout = timeout;
    _initialPrompt = initialPrompt;
    _timeoutPrompt = timeoutPrompt;
    _helpPrompt = helpPrompt;
    _helpList = helpList;
    _choices = choices;

    return self;
}

#pragma mark - Cancel

- (void)cancel {
    if (self.canceledHandler == nil) { return; }
    self.canceledHandler();
}

#pragma mark - Getters / Setters

+ (NSTimeInterval)defaultTimeout {
    return _defaultTimeout;
}

+ (void)setDefaultTimeout:(NSTimeInterval)defaultTimeout {
    _defaultTimeout = defaultTimeout;
}

+ (SDLChoiceSetLayout)defaultLayout {
    return _defaultLayout;
}

+ (void)setDefaultLayout:(SDLChoiceSetLayout)defaultLayout {
    _defaultLayout = defaultLayout;
}

- (void)setHelpList:(nullable NSArray<SDLVRHelpItem *> *)helpList {
    _helpList = helpList;

    for (NSUInteger i = 0; i < _helpList.count; i++) {
        _helpList[i].position = @(i + 1);
    }
}

#pragma mark - Helpers

/**
 Check for duplicate choices and voiceCommands

 @param choices The choices you will be adding
 @return Boolean that indicates whether choices and voice commands are unique or not
 */
-(BOOL)sdl_choiceCellsAreUnique:(NSArray<SDLChoiceCell *> *)choices {
    NSMutableSet<SDLChoiceCell *> *identicalCellsCheckSet = [NSMutableSet setWithCapacity:choices.count];
    NSMutableSet<NSString *> *identicalVoiceCommandsCheckSet = [NSMutableSet set];
    NSUInteger allVoiceCommandsCount = 0;
    for (SDLChoiceCell *cell in choices) {
        [identicalCellsCheckSet addObject:cell];

        if (cell.voiceCommands == nil) { continue; }
        [identicalVoiceCommandsCheckSet addObjectsFromArray:cell.voiceCommands];
        allVoiceCommandsCount += cell.voiceCommands.count;
    }

    if (identicalCellsCheckSet.count < choices.count) {
        SDLLogE(@"Attempted to create a choice set with duplicate cells. At least one property must be different between any two cells. The choice set will not be set.");
        return NO;
    }

    // All the VR commands must be unique
    if (identicalVoiceCommandsCheckSet.count < allVoiceCommandsCount) {
        SDLLogE(@"Attempted to create a choice set where the cells contained duplicate voice commands. All VR commands must be unique. There are %lu unique VR commands and %lu VR commands. The choice set will not be set.", (unsigned long)identicalVoiceCommandsCheckSet.count, (unsigned long)allVoiceCommandsCount);
        return NO;
    }

    return YES;
}

#pragma mark - Etc.

- (NSString *)description {
    return [NSString stringWithFormat:@"SDLChoiceSet: \"%@\", layout: %@", _title, (_layout == SDLChoiceSetLayoutList ? @"List" : @"Tiles")];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"SDLChoiceSet: Title: \"%@\", layout: %@, timeout: %@, initial prompt: \"%@\", timeout prompt: \"%@\", help prompt: \"%@\", help list: %@, choices: %@", _title, (_layout == SDLChoiceSetLayoutList ? @"List" : @"Tiles"), @(_timeout), _initialPrompt, _timeoutPrompt, _helpPrompt, _helpList, _choices];
}

@end

NS_ASSUME_NONNULL_END
