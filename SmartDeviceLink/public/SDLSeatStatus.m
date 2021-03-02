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

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLSeatLocation.h"
#import "SDLSeatStatus.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSeatStatus

- (instancetype)initWithSeatLocation:(SDLSeatLocation *)seatLocation conditionActive:(BOOL)conditionActive {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.seatLocation = seatLocation;
    self.conditionActive = @(conditionActive);
    return self;
}

- (void)setSeatLocation:(SDLSeatLocation *)seatLocation {
    [self.store sdl_setObject:seatLocation forName:SDLRPCParameterNameSeatLocation];
}

- (SDLSeatLocation *)seatLocation {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameSeatLocation ofClass:SDLSeatLocation.class error:&error];
}

- (void)setConditionActive:(NSNumber<SDLBool> *)conditionActive {
    [self.store sdl_setObject:conditionActive forName:SDLRPCParameterNameConditionActive];
}

- (NSNumber<SDLBool> *)conditionActive {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameConditionActive ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
