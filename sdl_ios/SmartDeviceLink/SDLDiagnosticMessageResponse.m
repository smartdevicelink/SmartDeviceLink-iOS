//  SDLDiagnosticMessageResponse.m
//
//  

#import <SmartDeviceLink/SDLDiagnosticMessageResponse.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLDiagnosticMessageResponse

-(id) init {
    if (self = [super initWithName:NAMES_DiagnosticMessage]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setMessageDataResult:(NSMutableArray*) messageDataResult {
    if (messageDataResult != nil) {
        [parameters setObject:messageDataResult forKey:NAMES_messageDataResult];
    } else {
        [parameters removeObjectForKey:NAMES_messageDataResult];
    }
}

-(NSMutableArray*) messageDataResult {
    return [parameters objectForKey:NAMES_messageDataResult];
}

@end
