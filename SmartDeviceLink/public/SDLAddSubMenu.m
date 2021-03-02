/*
* Copyright (c) 2020, SmartDeviceLink Consortium, Inc.
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
* Redistributions of source code must retain the above copyright notice, this
* list of conditions and the following disclaimer.
*
* Redistributions in binary form must reproduce the above copyright notice,
* this list of conditions and the following
* disclaimer in the documentation and/or other materials provided with the
* distribution.
*
* Neither the name of the SmartDeviceLink Consortium Inc. nor the names of
* its contributors may be used to endorse or promote products derived
* from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
* ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
* LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
* SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
* INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
* CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
* POSSIBILITY OF SUCH DAMAGE.
*/

#import "SDLAddSubMenu.h"

#import "NSMutableDictionary+Store.h"
#import "SDLImage.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAddSubMenu

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameAddSubMenu]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithMenuID:(UInt32)menuID menuName:(NSString *)menuName {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.menuID = @(menuID);
    self.menuName = menuName;
    return self;
}

- (instancetype)initWithMenuID:(UInt32)menuID menuName:(NSString *)menuName position:(nullable NSNumber<SDLUInt> *)position menuIcon:(nullable SDLImage *)menuIcon menuLayout:(nullable SDLMenuLayout)menuLayout parentID:(nullable NSNumber<SDLUInt> *)parentID {
    return [self initWithMenuID:menuID menuName:menuName position:position menuIcon:menuIcon menuLayout:menuLayout parentID:parentID secondaryText:nil tertiaryText:nil secondaryImage:nil];
}

- (instancetype)initWithMenuID:(UInt32)menuID menuName:(NSString *)menuName position:(nullable NSNumber<SDLUInt> *)position menuIcon:(nullable SDLImage *)menuIcon menuLayout:(nullable SDLMenuLayout)menuLayout parentID:(nullable NSNumber<SDLUInt> *)parentID secondaryText:(nullable NSString *)secondaryText tertiaryText:(nullable NSString *)tertiaryText secondaryImage:(nullable SDLImage *)secondaryImage {
    self = [self initWithMenuID:menuID menuName:menuName];
    if (!self) {
        return nil;
    }
    self.position = position;
    self.menuIcon = menuIcon;
    self.menuLayout = menuLayout;
    self.parentID = parentID;
    self.secondaryText = secondaryText;
    self.tertiaryText = tertiaryText;
    self.secondaryImage = secondaryImage;
    return self;
}

- (void)setMenuID:(NSNumber<SDLInt> *)menuID {
    [self.parameters sdl_setObject:menuID forName:SDLRPCParameterNameMenuID];
}

- (NSNumber<SDLInt> *)menuID {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameMenuID ofClass:NSNumber.class error:&error];
}

- (void)setPosition:(nullable NSNumber<SDLInt> *)position {
    [self.parameters sdl_setObject:position forName:SDLRPCParameterNamePosition];
}

- (nullable NSNumber<SDLInt> *)position {
    return [self.parameters sdl_objectForName:SDLRPCParameterNamePosition ofClass:NSNumber.class error:nil];
}

- (void)setMenuName:(NSString *)menuName {
    [self.parameters sdl_setObject:menuName forName:SDLRPCParameterNameMenuName];
}

- (NSString *)menuName {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameMenuName ofClass:NSString.class error:&error];
}

- (void)setMenuIcon:(nullable SDLImage *)menuIcon {
    [self.parameters sdl_setObject:menuIcon forName:SDLRPCParameterNameMenuIcon];
}

- (nullable SDLImage *)menuIcon {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameMenuIcon ofClass:[SDLImage class] error:nil];
}

- (void)setMenuLayout:(nullable SDLMenuLayout)menuLayout {
    [self.parameters sdl_setObject:menuLayout forName:SDLRPCParameterNameMenuLayout];
}

- (nullable SDLMenuLayout)menuLayout {
    return [self.parameters sdl_enumForName:SDLRPCParameterNameMenuLayout error:nil];
}

- (void)setParentID:(nullable NSNumber<SDLUInt> *)parentID {
    [self.parameters sdl_setObject:parentID forName:SDLRPCParameterNameParentID];
}

- (nullable NSNumber<SDLUInt> *)parentID {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameParentID ofClass:NSNumber.class error:nil];
}

- (void)setSecondaryText:(nullable NSString *)secondaryText {
    [self.parameters sdl_setObject:secondaryText forName:SDLRPCParameterNameSecondaryText];
}

- (nullable NSString *)secondaryText {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSecondaryText ofClass:NSString.class error:nil];
}

- (void)setTertiaryText:(nullable NSString *)tertiaryText {
    [self.parameters sdl_setObject:tertiaryText forName:SDLRPCParameterNameTertiaryText];
}

- (nullable NSString *)tertiaryText {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameTertiaryText ofClass:NSString.class error:nil];
}

- (void)setSecondaryImage:(nullable SDLImage *)secondaryImage {
    [self.parameters sdl_setObject:secondaryImage forName:SDLRPCParameterNameSecondaryImage];
}

- (nullable SDLImage *)secondaryImage {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSecondaryImage ofClass:SDLImage.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
