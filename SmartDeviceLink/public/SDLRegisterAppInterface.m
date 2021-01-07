//  SDLRegisterAppInterface.m
//


#import "SDLRegisterAppInterface.h"

#import "NSMutableDictionary+Store.h"
#import "SDLAppHMIType.h"
#import "SDLAppInfo.h"
#import "SDLDeviceInfo.h"
#import "SDLGlobals.h"
#import "SDLLanguage.h"
#import "SDLLifecycleConfiguration.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLMsgVersion.h"
#import "SDLTemplateColorScheme.h"
#import "SDLTTSChunk.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLRegisterAppInterface

#pragma mark - Lifecycle

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameRegisterAppInterface]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithSdlMsgVersion:(SDLMsgVersion *)sdlMsgVersion appName:(NSString *)appName isMediaApplication:(BOOL)isMediaApplication languageDesired:(SDLLanguage)languageDesired hmiDisplayLanguageDesired:(SDLLanguage)hmiDisplayLanguageDesired appID:(NSString *)appID {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.sdlMsgVersion = sdlMsgVersion;
    self.appName = appName;
    self.isMediaApplication = @(isMediaApplication);
    self.languageDesired = languageDesired;
    self.hmiDisplayLanguageDesired = hmiDisplayLanguageDesired;
    self.appID = appID;
    return self;
}

- (instancetype)initWithSdlMsgVersion:(SDLMsgVersion *)sdlMsgVersion appName:(NSString *)appName isMediaApplication:(BOOL)isMediaApplication languageDesired:(SDLLanguage)languageDesired hmiDisplayLanguageDesired:(SDLLanguage)hmiDisplayLanguageDesired appID:(NSString *)appID ttsName:(nullable NSArray<SDLTTSChunk *> *)ttsName ngnMediaScreenAppName:(nullable NSString *)ngnMediaScreenAppName vrSynonyms:(nullable NSArray<NSString *> *)vrSynonyms appHMIType:(nullable NSArray<SDLAppHMIType> *)appHMIType hashID:(nullable NSString *)hashID deviceInfo:(nullable SDLDeviceInfo *)deviceInfo fullAppID:(nullable NSString *)fullAppID appInfo:(nullable SDLAppInfo *)appInfo dayColorScheme:(nullable SDLTemplateColorScheme *)dayColorScheme nightColorScheme:(nullable SDLTemplateColorScheme *)nightColorScheme {
    self = [self initWithSdlMsgVersion:sdlMsgVersion appName:appName isMediaApplication:isMediaApplication languageDesired:languageDesired hmiDisplayLanguageDesired:hmiDisplayLanguageDesired appID:appID];
    if (!self) {
        return nil;
    }
    self.ttsName = ttsName;
    self.ngnMediaScreenAppName = ngnMediaScreenAppName;
    self.vrSynonyms = vrSynonyms;
    self.appHMIType = appHMIType;
    self.hashID = hashID;
    self.deviceInfo = deviceInfo;
    self.fullAppID = fullAppID;
    self.appInfo = appInfo;
    self.dayColorScheme = dayColorScheme;
    self.nightColorScheme = nightColorScheme;
    return self;
}

- (instancetype)initWithLifecycleConfiguration:(SDLLifecycleConfiguration *)lifecycleConfiguration {
    NSArray<SDLAppHMIType> *allHMITypes = lifecycleConfiguration.additionalAppTypes ? [lifecycleConfiguration.additionalAppTypes arrayByAddingObject:lifecycleConfiguration.appType] : @[lifecycleConfiguration.appType];

    UInt8 majorVersion = (UInt8)[SDLMaxProxyRPCVersion substringWithRange:NSMakeRange(0, 1)].intValue;
    UInt8 minorVersion = (UInt8)[SDLMaxProxyRPCVersion substringWithRange:NSMakeRange(2, 1)].intValue;
    UInt8 patchVersion = (UInt8)[SDLMaxProxyRPCVersion substringWithRange:NSMakeRange(4, 1)].intValue;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    SDLMsgVersion *msgVersion = [[SDLMsgVersion alloc] initWithMajorVersionParam:majorVersion minorVersion:minorVersion patchVersion:@(patchVersion)];
#pragma clang diagnostic pop

    return [self initWithSdlMsgVersion:msgVersion appName:lifecycleConfiguration.appName isMediaApplication:lifecycleConfiguration.isMedia languageDesired:lifecycleConfiguration.language hmiDisplayLanguageDesired:lifecycleConfiguration.language appID:lifecycleConfiguration.appId ttsName:lifecycleConfiguration.ttsName ngnMediaScreenAppName:lifecycleConfiguration.shortAppName vrSynonyms:lifecycleConfiguration.voiceRecognitionCommandNames appHMIType:allHMITypes hashID:lifecycleConfiguration.resumeHash deviceInfo:[SDLDeviceInfo currentDevice] fullAppID:lifecycleConfiguration.fullAppId appInfo:[SDLAppInfo currentAppInfo] dayColorScheme:lifecycleConfiguration.dayColorScheme nightColorScheme:lifecycleConfiguration.nightColorScheme];
}

- (instancetype)initWithAppName:(NSString *)appName appId:(NSString *)appId languageDesired:(SDLLanguage)languageDesired {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.appName = appName;
    self.appID = appId;
    self.fullAppID = nil;
    self.languageDesired = languageDesired;

    self.hmiDisplayLanguageDesired = languageDesired;

    UInt8 majorVersion = (UInt8)[SDLMaxProxyRPCVersion substringWithRange:NSMakeRange(0, 1)].intValue;
    UInt8 minorVersion = (UInt8)[SDLMaxProxyRPCVersion substringWithRange:NSMakeRange(2, 1)].intValue;
    UInt8 patchVersion = (UInt8)[SDLMaxProxyRPCVersion substringWithRange:NSMakeRange(4, 1)].intValue;
    self.sdlMsgVersion = [[SDLMsgVersion alloc] initWithMajorVersion:majorVersion minorVersion:minorVersion patchVersion:patchVersion];
    self.appInfo = [SDLAppInfo currentAppInfo];
    self.deviceInfo = [SDLDeviceInfo currentDevice];
    self.correlationID = @1;
    self.isMediaApplication = @NO;

    return self;
}

- (instancetype)initWithAppName:(NSString *)appName appId:(NSString *)appId fullAppId:(nullable NSString *)fullAppId languageDesired:(SDLLanguage)languageDesired isMediaApp:(BOOL)isMediaApp appTypes:(NSArray<SDLAppHMIType> *)appTypes shortAppName:(nullable NSString *)shortAppName ttsName:(nullable NSArray<SDLTTSChunk *> *)ttsName vrSynonyms:(nullable NSArray<NSString *> *)vrSynonyms hmiDisplayLanguageDesired:(SDLLanguage)hmiDisplayLanguageDesired resumeHash:(nullable NSString *)resumeHash dayColorScheme:(nullable SDLTemplateColorScheme *)dayColorScheme nightColorScheme:(nullable SDLTemplateColorScheme *)nightColorScheme {
    self = [self initWithAppName:appName appId:appId languageDesired:languageDesired];

    self.fullAppID = fullAppId;
    self.isMediaApplication = @(isMediaApp);
    self.appHMIType = appTypes;
    self.ngnMediaScreenAppName = shortAppName;
    self.ttsName = [ttsName copy];
    self.vrSynonyms = [vrSynonyms copy];
    self.hmiDisplayLanguageDesired = hmiDisplayLanguageDesired;
    self.hashID = resumeHash;
    self.dayColorScheme = dayColorScheme;
    self.nightColorScheme = nightColorScheme;

    return self;
}

#pragma mark - Getters and Setters

- (void)setSdlMsgVersion:(SDLMsgVersion *)sdlMsgVersion {
    [self.parameters sdl_setObject:sdlMsgVersion forName:SDLRPCParameterNameSyncMessageVersion];
}

- (SDLMsgVersion *)sdlMsgVersion {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSyncMessageVersion ofClass:SDLMsgVersion.class error:nil];
}

- (void)setAppName:(NSString *)appName {
    [self.parameters sdl_setObject:appName forName:SDLRPCParameterNameAppName];
}

- (NSString *)appName {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAppName ofClass:NSString.class error:&error];
}

- (void)setTtsName:(nullable NSArray<SDLTTSChunk *> *)ttsName {
    [self.parameters sdl_setObject:ttsName forName:SDLRPCParameterNameTTSName];
}

- (nullable NSArray<SDLTTSChunk *> *)ttsName {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameTTSName ofClass:SDLTTSChunk.class error:nil];
}

- (void)setNgnMediaScreenAppName:(nullable NSString *)ngnMediaScreenAppName {
    [self.parameters sdl_setObject:ngnMediaScreenAppName forName:SDLRPCParameterNameNGNMediaScreenAppName];
}

- (nullable NSString *)ngnMediaScreenAppName {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameNGNMediaScreenAppName ofClass:NSString.class error:nil];
}

- (void)setVrSynonyms:(nullable NSArray<NSString *> *)vrSynonyms {
    [self.parameters sdl_setObject:vrSynonyms forName:SDLRPCParameterNameVRSynonyms];
}

- (nullable NSArray<NSString *> *)vrSynonyms {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameVRSynonyms ofClass:NSString.class error:nil];
}

- (void)setIsMediaApplication:(NSNumber<SDLBool> *)isMediaApplication {
    [self.parameters sdl_setObject:isMediaApplication forName:SDLRPCParameterNameIsMediaApplication];
}

- (NSNumber<SDLBool> *)isMediaApplication {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameIsMediaApplication ofClass:NSNumber.class error:&error];
}

- (void)setLanguageDesired:(SDLLanguage)languageDesired {
    [self.parameters sdl_setObject:languageDesired forName:SDLRPCParameterNameLanguageDesired];
}

- (SDLLanguage)languageDesired {
    NSError *error = nil;
    return [self.parameters sdl_enumForName:SDLRPCParameterNameLanguageDesired error:&error];
}

- (void)setHmiDisplayLanguageDesired:(SDLLanguage)hmiDisplayLanguageDesired {
    [self.parameters sdl_setObject:hmiDisplayLanguageDesired forName:SDLRPCParameterNameHMIDisplayLanguageDesired];
}

- (SDLLanguage)hmiDisplayLanguageDesired {
    NSError *error = nil;
    return [self.parameters sdl_enumForName:SDLRPCParameterNameHMIDisplayLanguageDesired error:&error];
}

- (void)setAppHMIType:(nullable NSArray<SDLAppHMIType> *)appHMIType {
    [self.parameters sdl_setObject:appHMIType forName:SDLRPCParameterNameAppHMIType];
}

- (nullable NSArray<SDLAppHMIType> *)appHMIType {
    return [self.parameters sdl_enumsForName:SDLRPCParameterNameAppHMIType error:nil];
}

- (void)setHashID:(nullable NSString *)hashID {
    [self.parameters sdl_setObject:hashID forName:SDLRPCParameterNameHashId];
}

- (nullable NSString *)hashID {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameHashId ofClass:NSString.class error:nil];
}

- (void)setDeviceInfo:(nullable SDLDeviceInfo *)deviceInfo {
    [self.parameters sdl_setObject:deviceInfo forName:SDLRPCParameterNameDeviceInfo];
}

- (nullable SDLDeviceInfo *)deviceInfo {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameDeviceInfo ofClass:SDLDeviceInfo.class error:nil];
}

- (void)setAppID:(NSString *)appID {
    [self.parameters sdl_setObject:appID forName:SDLRPCParameterNameAppId];
}

- (NSString *)appID {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAppId ofClass:NSString.class error:&error];
}

- (void)setFullAppID:(nullable NSString *)fullAppID {
    [self.parameters sdl_setObject:fullAppID forName:SDLRPCParameterNameFullAppID];
}

- (nullable NSString *)fullAppID {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameFullAppID ofClass:NSString.class error:nil];
}

- (void)setAppInfo:(nullable SDLAppInfo *)appInfo {
    [self.parameters sdl_setObject:appInfo forName:SDLRPCParameterNameAppInfo];
}

- (nullable SDLAppInfo *)appInfo {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAppInfo ofClass:SDLAppInfo.class error:nil];
}

- (void)setDayColorScheme:(nullable SDLTemplateColorScheme *)dayColorScheme {
    [self.parameters sdl_setObject:dayColorScheme forName:SDLRPCParameterNameDayColorScheme];
}

- (nullable SDLTemplateColorScheme *)dayColorScheme {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameDayColorScheme ofClass:SDLTemplateColorScheme.class error:nil];
}

- (void)setNightColorScheme:(nullable SDLTemplateColorScheme *)nightColorScheme {
    [self.parameters sdl_setObject:nightColorScheme forName:SDLRPCParameterNameNightColorScheme];
}

- (nullable SDLTemplateColorScheme *)nightColorScheme {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameNightColorScheme ofClass:SDLTemplateColorScheme.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
