/*
 * Copyright (c) 2021, SmartDeviceLink Consortium, Inc.
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

#import "NSMutableDictionary+Store.h"
#import "SDLKeyboardLayout.h"
#import "SDLKeyboardLayoutCapability.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLKeyboardLayoutCapability

- (instancetype)initWithKeyboardLayout:(SDLKeyboardLayout)keyboardLayout numConfigurableKeys:(UInt8)numConfigurableKeys {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.keyboardLayout = keyboardLayout;
    self.numConfigurableKeys = @(numConfigurableKeys);
    return self;
}

- (void)setKeyboardLayout:(SDLKeyboardLayout)keyboardLayout {
    [self.store sdl_setObject:keyboardLayout forName:SDLRPCParameterNameKeyboardLayout];
}

- (SDLKeyboardLayout)keyboardLayout {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameKeyboardLayout error:&error];
}

- (void)setNumConfigurableKeys:(NSNumber<SDLUInt> *)numConfigurableKeys {
    [self.store sdl_setObject:numConfigurableKeys forName:SDLRPCParameterNameNumConfigurableKeys];
}

- (NSNumber<SDLUInt> *)numConfigurableKeys {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameNumConfigurableKeys ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
