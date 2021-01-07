//  SDLTextField.m
//

#import "SDLTextField.h"

#import "NSMutableDictionary+Store.h"
#import "SDLCharacterSet.h"
#import "SDLRPCParameterNames.h"
#import "SDLTextFieldName.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLTextField

- (instancetype)initWithNameParam:(SDLTextFieldName)nameParam characterSet:(SDLCharacterSet)characterSet width:(UInt16)width rows:(UInt8)rows {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.nameParam = nameParam;
    self.characterSet = characterSet;
    self.width = @(width);
    self.rows = @(rows);
    return self;
}

- (instancetype)initWithName:(SDLTextFieldName)name characterSet:(SDLCharacterSet)characterSet width:(NSUInteger)width rows:(NSUInteger)rows {
    self = [self init];
    if (!self) { return nil; }

    self.nameParam = name;
    self.characterSet = characterSet;
    self.width = @(width);
    self.rows = @(rows);

    return self;
}

- (void)setNameParam:(SDLTextFieldName)nameParam {
    [self.store sdl_setObject:nameParam forName:SDLRPCParameterNameName];
}

- (SDLTextFieldName)nameParam {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameName error:&error];
}

- (void)setName:(SDLTextFieldName)name {
    [self.store sdl_setObject:name forName:SDLRPCParameterNameName];
}

- (SDLTextFieldName)name {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameName error:&error];
}

- (void)setCharacterSet:(SDLCharacterSet)characterSet {
    [self.store sdl_setObject:characterSet forName:SDLRPCParameterNameCharacterSet];
}

- (SDLCharacterSet)characterSet {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameCharacterSet error:&error];
}

- (void)setWidth:(NSNumber<SDLInt> *)width {
    [self.store sdl_setObject:width forName:SDLRPCParameterNameWidth];
}

- (NSNumber<SDLInt> *)width {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameWidth ofClass:NSNumber.class error:&error];
}

- (void)setRows:(NSNumber<SDLInt> *)rows {
    [self.store sdl_setObject:rows forName:SDLRPCParameterNameRows];
}

- (NSNumber<SDLInt> *)rows {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameRows ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
