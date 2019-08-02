//
//  SDLCancelInteraction.m
//  SmartDeviceLink
//
//  Created by Nicole on 7/12/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLCancelInteraction.h"

#import "NSMutableDictionary+Store.h"
#import "SDLFunctionID.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLCancelInteraction

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameCancelInteraction]) {
    }
    return self;
}

- (instancetype)initWithAlertCancelID:(UInt32)cancelID {
    return [self initWithfunctionID:[SDLFunctionID.sharedInstance functionIdForName:SDLRPCFunctionNameAlert].unsignedIntValue cancelID:cancelID];
}

- (instancetype)initWithSliderCancelID:(UInt32)cancelID {
     return [self initWithfunctionID:[SDLFunctionID.sharedInstance functionIdForName:SDLRPCFunctionNameSlider].unsignedIntValue cancelID:cancelID];
}

- (instancetype)initWithScrollableMessageCancelID:(UInt32)cancelID {
    return [self initWithfunctionID:[SDLFunctionID.sharedInstance functionIdForName:SDLRPCFunctionNameScrollableMessage].unsignedIntValue cancelID:cancelID];
}

- (instancetype)initWithPerformInteractionCancelID:(UInt32)cancelID {
    return [self initWithfunctionID:[SDLFunctionID.sharedInstance functionIdForName:SDLRPCFunctionNamePerformInteraction].unsignedIntValue cancelID:cancelID];
}

#pragma clang diagnostic pop


- (instancetype)initWithfunctionID:(UInt32)functionID {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.functionID = @(functionID);

    return self;
}

- (instancetype)initWithfunctionID:(UInt32)functionID cancelID:(UInt32)cancelID {
    self = [self initWithfunctionID:functionID];
    if (!self) {
        return nil;
    }

    self.cancelID = @(cancelID);

    return self;
}

- (void)setCancelID:(nullable NSNumber<SDLInt> *)cancelID {
    [self.parameters sdl_setObject:cancelID forName:SDLRPCParameterNameCancelID];
}

- (nullable NSNumber<SDLInt> *)cancelID {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameCancelID ofClass:NSNumber.class error:nil];
}

- (void)setFunctionID:(NSNumber<SDLInt> *)functionID {
    [self.parameters sdl_setObject:functionID forName:SDLRPCParameterNameFunctionID];
}

- (NSNumber<SDLInt> *)functionID {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameFunctionID ofClass:NSNumber.class error:&error];
}


@end

NS_ASSUME_NONNULL_END
