//
//  SDLProxyALM.m
//  SmartDeviceLink
//
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//

#import "SDLProxyALM.h"
#import "SDLProxyBase.h"

@implementation SDLProxyALM

-(instancetype)initWithProxyDelegate:(NSObject<SDLProxyListener>*)delegate
                             appName:(NSString *)appName
                          isMediaApp:(NSNumber *)isMediaApp
                               appID:(NSString *)appID
                             options:(SDLProxyALMOptions *)options{
    
    //TODO: Add SDLTrace log statement?
    return [super initWithProxyDelegate:delegate
      enableAdvancedLifecycleManagement:YES
                                appName:appName
                             isMediaApp:isMediaApp
                                  appID:appID
                                options:options];
}

-(void)resetProxy{
    [super cycleProxy:kNilOptions];
}

@end