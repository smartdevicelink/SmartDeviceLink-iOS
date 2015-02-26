//  SDLRegisterAppInterfaceResponse.m
//
//  

#import <SmartDeviceLink/SDLRegisterAppInterfaceResponse.h>

#import <SmartDeviceLink/SDLNames.h>
#import <SmartDeviceLink/SDLButtonCapabilities.h>
#import <SmartDeviceLink/SDLSoftButtonCapabilities.h>
#import <SmartDeviceLink/SDLHmiZoneCapabilities.h>
#import <SmartDeviceLink/SDLSpeechCapabilities.h>
#import <SmartDeviceLink/SDLPrerecordedSpeech.h>
#import <SmartDeviceLink/SDLVrCapabilities.h>
#import <SmartDeviceLink/SDLAudioPassThruCapabilities.h>

@implementation SDLRegisterAppInterfaceResponse

-(id) init {
    if (self = [super initWithName:NAMES_RegisterAppInterface]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setSyncMsgVersion:(SDLSyncMsgVersion*) syncMsgVersion {
    if (syncMsgVersion != nil) {
        [parameters setObject:syncMsgVersion forKey:NAMES_syncMsgVersion];
    } else {
        [parameters removeObjectForKey:NAMES_syncMsgVersion];
    }
}

-(SDLSyncMsgVersion*) syncMsgVersion {
    NSObject* obj = [parameters objectForKey:NAMES_syncMsgVersion];
    if ([obj isKindOfClass:SDLSyncMsgVersion.class]) {
        return (SDLSyncMsgVersion*)obj;
    } else {
        return [[SDLSyncMsgVersion alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

-(void) setLanguage:(SDLLanguage*) language {
    if (language != nil) {
        [parameters setObject:language forKey:NAMES_language];
    } else {
        [parameters removeObjectForKey:NAMES_language];
    }
}

-(SDLLanguage*) language {
    NSObject* obj = [parameters objectForKey:NAMES_language];
    if ([obj isKindOfClass:SDLLanguage.class]) {
        return (SDLLanguage*)obj;
    } else {
        return [SDLLanguage valueOf:(NSString*)obj];
    }
}

-(void) setHmiDisplayLanguage:(SDLLanguage*) hmiDisplayLanguage {
    if (hmiDisplayLanguage != nil) {
        [parameters setObject:hmiDisplayLanguage forKey:NAMES_hmiDisplayLanguage];
    } else {
        [parameters removeObjectForKey:NAMES_hmiDisplayLanguage];
    }
}

-(SDLLanguage*) hmiDisplayLanguage {
    NSObject* obj = [parameters objectForKey:NAMES_hmiDisplayLanguage];
    if ([obj isKindOfClass:SDLLanguage.class]) {
        return (SDLLanguage*)obj;
    } else {
        return [SDLLanguage valueOf:(NSString*)obj];
    }
}

-(void) setDisplayCapabilities:(SDLDisplayCapabilities*) displayCapabilities {
    if (displayCapabilities != nil) {
        [parameters setObject:displayCapabilities forKey:NAMES_displayCapabilities];
    } else {
        [parameters removeObjectForKey:NAMES_displayCapabilities];
    }
}

-(SDLDisplayCapabilities*) displayCapabilities {
    NSObject* obj = [parameters objectForKey:NAMES_displayCapabilities];
    if ([obj isKindOfClass:SDLDisplayCapabilities.class]) {
        return (SDLDisplayCapabilities*)obj;
    } else {
        return [[SDLDisplayCapabilities alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

-(void) setButtonCapabilities:(NSMutableArray*) buttonCapabilities {
    if (buttonCapabilities != nil) {
        [parameters setObject:buttonCapabilities forKey:NAMES_buttonCapabilities];
    } else {
        [parameters removeObjectForKey:NAMES_buttonCapabilities];
    }
}

-(NSMutableArray*) buttonCapabilities {
    NSMutableArray* array = [parameters objectForKey:NAMES_buttonCapabilities];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLButtonCapabilities.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary* dict in array) {
            [newList addObject:[[SDLButtonCapabilities alloc] initWithDictionary:(NSMutableDictionary*)dict]];
        }
        return newList;
    }
}

-(void) setSoftButtonCapabilities:(NSMutableArray*) softButtonCapabilities {
    if (softButtonCapabilities != nil) {
        [parameters setObject:softButtonCapabilities forKey:NAMES_softButtonCapabilities];
    } else {
        [parameters removeObjectForKey:NAMES_softButtonCapabilities];
    }
}

-(NSMutableArray*) softButtonCapabilities {
    NSMutableArray* array = [parameters objectForKey:NAMES_softButtonCapabilities];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLSoftButtonCapabilities.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary* dict in array) {
            [newList addObject:[[SDLSoftButtonCapabilities alloc] initWithDictionary:(NSMutableDictionary*)dict]];
        }
        return newList;
    }
}

-(void) setPresetBankCapabilities:(SDLPresetBankCapabilities*) presetBankCapabilities {
    if (presetBankCapabilities != nil) {
        [parameters setObject:presetBankCapabilities forKey:NAMES_presetBankCapabilities];
    } else {
        [parameters removeObjectForKey:NAMES_presetBankCapabilities];
    }
}

-(SDLPresetBankCapabilities*) presetBankCapabilities {
    NSObject* obj = [parameters objectForKey:NAMES_presetBankCapabilities];
    if ([obj isKindOfClass:SDLPresetBankCapabilities.class]) {
        return (SDLPresetBankCapabilities*)obj;
    } else {
        return [[SDLPresetBankCapabilities alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

-(void) setHmiZoneCapabilities:(NSMutableArray*) hmiZoneCapabilities {
    if (hmiZoneCapabilities != nil) {
        [parameters setObject:hmiZoneCapabilities forKey:NAMES_hmiZoneCapabilities];
    } else {
        [parameters removeObjectForKey:NAMES_hmiZoneCapabilities];
    }
}

-(NSMutableArray*) hmiZoneCapabilities {
    NSMutableArray* array = [parameters objectForKey:NAMES_hmiZoneCapabilities];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLHmiZoneCapabilities.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString* enumString in array) {
            [newList addObject:[SDLHmiZoneCapabilities valueOf:enumString]];
        }
        return newList;
    }
}

-(void) setSpeechCapabilities:(NSMutableArray*) speechCapabilities {
    if (speechCapabilities != nil) {
        [parameters setObject:speechCapabilities forKey:NAMES_speechCapabilities];
    } else {
        [parameters removeObjectForKey:NAMES_speechCapabilities];
    }
}

-(NSMutableArray*) speechCapabilities {
    NSMutableArray* array = [parameters objectForKey:NAMES_speechCapabilities];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLSpeechCapabilities.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString* enumString in array) {
            [newList addObject:[SDLSpeechCapabilities valueOf:enumString]];
        }
        return newList;
    }
}

-(void) setPrerecordedSpeech:(NSMutableArray*) prerecordedSpeech {
    if (prerecordedSpeech != nil) {
        [parameters setObject:prerecordedSpeech forKey:NAMES_prerecordedSpeech];
    } else {
        [parameters removeObjectForKey:NAMES_prerecordedSpeech];
    }
}

-(NSMutableArray*) prerecordedSpeech {
    NSMutableArray* array = [parameters objectForKey:NAMES_prerecordedSpeech];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLPrerecordedSpeech.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString* enumString in array) {
            [newList addObject:[SDLPrerecordedSpeech valueOf:enumString]];
        }
        return newList;
    }
}

-(void) setVrCapabilities:(NSMutableArray*) vrCapabilities {
    if (vrCapabilities != nil) {
        [parameters setObject:vrCapabilities forKey:NAMES_vrCapabilities];
    } else {
        [parameters removeObjectForKey:NAMES_vrCapabilities];
    }
}

-(NSMutableArray*) vrCapabilities {
    NSMutableArray* array = [parameters objectForKey:NAMES_vrCapabilities];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLVrCapabilities.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString* enumString in array) {
            [newList addObject:[SDLVrCapabilities valueOf:enumString]];
        }
        return newList;
    }
}

-(void) setAudioPassThruCapabilities:(NSMutableArray*) audioPassThruCapabilities {
    if (audioPassThruCapabilities != nil) {
        [parameters setObject:audioPassThruCapabilities forKey:NAMES_audioPassThruCapabilities];
    } else {
        [parameters removeObjectForKey:NAMES_audioPassThruCapabilities];
    }
}

-(NSMutableArray*) audioPassThruCapabilities {
    NSMutableArray* array = [parameters objectForKey:NAMES_audioPassThruCapabilities];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLAudioPassThruCapabilities.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary* dict in array) {
            [newList addObject:[[SDLAudioPassThruCapabilities alloc] initWithDictionary:(NSMutableDictionary*)dict]];
        }
        return newList;
    }
}

-(void) setVehicleType:(SDLVehicleType*) vehicleType {
    if (vehicleType != nil) {
        [parameters setObject:vehicleType forKey:NAMES_vehicleType];
    } else {
        [parameters removeObjectForKey:NAMES_vehicleType];
    }
}

-(SDLVehicleType*) vehicleType {
    NSObject* obj = [parameters objectForKey:NAMES_vehicleType];
    if ([obj isKindOfClass:SDLVehicleType.class]) {
        return (SDLVehicleType*)obj;
    } else {
        return [[SDLVehicleType alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

-(void) setSupportedDiagModes:(NSMutableArray*) supportedDiagModes {
    if (supportedDiagModes != nil) {
        [parameters setObject:supportedDiagModes forKey:NAMES_supportedDiagModes];
    } else {
        [parameters removeObjectForKey:NAMES_supportedDiagModes];
    }
}

-(NSMutableArray*) supportedDiagModes {
    return [parameters objectForKey:NAMES_supportedDiagModes];
}

@end
