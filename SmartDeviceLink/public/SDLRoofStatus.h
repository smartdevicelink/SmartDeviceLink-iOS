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

#import "SDLDoorStatusType.h"
#import "SDLRPCStruct.h"

@class SDLGrid;
@class SDLWindowState;

NS_ASSUME_NONNULL_BEGIN

/**
 * Describes the status of a parameter of roof/convertible roof/sunroof/moonroof etc. If roof is open (AJAR), state will determine percentage of roof open.
 *
 * @added in SmartDeviceLink 7.1.0
 */
@interface SDLRoofStatus : SDLRPCStruct

/**
 * @param location - location
 * @param status - status
 * @return A SDLRoofStatus object
 */
- (instancetype)initWithLocation:(SDLGrid *)location status:(SDLDoorStatusType)status;

/**
 * @param location - location
 * @param status - status
 * @param state - state
 * @return A SDLRoofStatus object
 */
- (instancetype)initWithLocation:(SDLGrid *)location status:(SDLDoorStatusType)status state:(nullable SDLWindowState *)state;

@property (strong, nonatomic) SDLGrid *location;

@property (strong, nonatomic) SDLDoorStatusType status;

@property (nullable, strong, nonatomic) SDLWindowState *state;

@end

NS_ASSUME_NONNULL_END
