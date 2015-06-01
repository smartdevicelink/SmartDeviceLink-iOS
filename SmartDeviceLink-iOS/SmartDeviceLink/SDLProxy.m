// SDLProxy.m

#import "SDLProxy.h"

@import UIKit;
@import ExternalAccessory;
#import <objc/runtime.h>

#import "SDLAbstractTransport.h"
#import "SDLAudioStreamingState.h"
#import "SDLDebugTool.h"
#import "SDLEncodedSyncPData.h"
#import "SDLFileType.h"
#import "SDLFunctionID.h"
#import "SDLHMILevel.h"
#import "SDLJsonDecoder.h"
#import "SDLJsonEncoder.h"
#import "SDLLanguage.h"
#import "SDLLayoutMode.h"
#import "SDLLockScreenManager.h"
#import "SDLNames.h"
#import "SDLOnHMIStatus.h"
#import "SDLOnSystemRequest.h"
#import "SDLPolicyDataParser.h"
#import "SDLProtocol.h"
#import "SDLProtocolMessage.h"
#import "SDLPutFile.h"
#import "SDLRequestType.h"
#import "SDLRPCPayload.h"
#import "SDLRPCRequestFactory.h"
#import "SDLRPCResponse.h"
#import "SDLSiphonServer.h"
#import "SDLSystemContext.h"
#import "SDLSystemRequest.h"
#import "SDLQueryAppsManager.h"
#import "SDLRPCPayload.h"
#import "SDLPolicyDataParser.h"
#import "SDLLockScreenManager.h"
#import "SDLProtocolMessage.h"
#import "SDLTimer.h"


#define VERSION_STRING @"SmartDeviceLink-20140929-090241-LOCAL-iOS"
typedef void(^URLSessionTaskCompletionHandler)(NSData *data, NSURLResponse *response, NSError *error);

const float startSessionTime = 10.0;
const float notifyProxyClosedDelay = 0.1;
const int POLICIES_CORRELATION_ID = 65535;


@interface SDLProxy ()
{
    SDLLockScreenManager *_lsm;
    NSURLSession *_systemRequestSession;
    NSURLSession *_encodedSyncPDataSession;
}

@property (strong, nonatomic) NSMutableSet *activeSystemRequestTasks;

@end


@implementation SDLProxy

#pragma mark - Object lifecycle
- (instancetype)initWithTransport:(SDLAbstractTransport *)transport protocol:(SDLAbstractProtocol *)protocol delegate:(NSObject<SDLProxyListener> *)theDelegate {
    if (self = [super init]) {
        _debugConsoleGroupName = @"default";
        

        _lsm = [[SDLLockScreenManager alloc] init];

        _alreadyDestructed = NO;
                
        self.proxyListeners = [[NSMutableArray alloc] initWithObjects:theDelegate, nil];
        self.protocol = protocol;
        self.transport = transport;
        self.transport.delegate = protocol;
        self.protocol.protocolDelegate = self;
        self.protocol.transport = transport;

        [self.transport performSelector:@selector(connect) withObject:nil afterDelay:0];

        [SDLDebugTool logInfo:@"SDLProxy initWithTransport"];
        [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
    }
    
    return self;
}

-(void) destructObjects {
    if(!_alreadyDestructed) {
        _alreadyDestructed = YES;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[EAAccessoryManager sharedAccessoryManager] unregisterForLocalNotifications];
        
        if (_systemRequestSession != nil) {
            [_systemRequestSession invalidateAndCancel];
        }
        
        if (_encodedSyncPDataSession != nil) {
            [_encodedSyncPDataSession invalidateAndCancel];
        }

        [self.protocol dispose];
        [self.transport dispose];

        self.transport = nil;
        self.protocol = nil;
        self.proxyListeners = nil;
    }
}

-(void) dispose {
    if (self.transport != nil) {
        [self.transport disconnect];
    }
    
    [self destructObjects];
}

-(void) dealloc {
    [self destructObjects];
    [SDLDebugTool logInfo:@"SDLProxy Dealloc" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:_debugConsoleGroupName];
}

-(void) notifyProxyClosed {
    if (_isConnected) {
        _isConnected = NO;
        [self invokeMethodOnDelegates:@selector(onProxyClosed) withObject:nil];
    }
}

- (void)sendMobileHMIState {
    UIApplicationState appState = [UIApplication sharedApplication].applicationState;
    SDLOnHMIStatus *HMIStatusRPC = [[SDLOnHMIStatus alloc] init];
    
    HMIStatusRPC.audioStreamingState = [SDLAudioStreamingState NOT_AUDIBLE];
    HMIStatusRPC.systemContext = [SDLSystemContext MAIN];
    
    switch (appState) {
        case UIApplicationStateActive: {
            HMIStatusRPC.hmiLevel = [SDLHMILevel FULL];
        } break;
        case UIApplicationStateInactive: // Fallthrough
        case UIApplicationStateBackground: {
            HMIStatusRPC.hmiLevel = [SDLHMILevel BACKGROUND];
        } break;
        default: break;
    }
    
    NSString *log = [NSString stringWithFormat:@"Sending new mobile hmi state: %@", HMIStatusRPC.hmiLevel.value];
    [SDLDebugTool logInfo:log withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    
    [self sendRPC:HMIStatusRPC];
}

- (NSString *)proxyVersion {
    return VERSION_STRING;
}

- (void)startRPCSession {
    [self.protocol sendStartSessionWithType:SDLServiceType_RPC];
}

#pragma mark - SDLProtocolListener Implementation
- (void) onProtocolOpened {
    _isConnected = YES;
    [SDLDebugTool logInfo:@"StartSession (request)" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];

    [self startRPCSession];

    if (self.startSessionTimer == nil) {
        self.startSessionTimer = [[SDLTimer alloc] initWithDuration:startSessionTime];
        __weak typeof(self) weakSelf = self;
        self.startSessionTimer.elapsedBlock = ^{
            [SDLDebugTool logInfo:@"Start Session Timeout" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:weakSelf.debugConsoleGroupName];
            [weakSelf performSelector:@selector(notifyProxyClosed) withObject:nil afterDelay:notifyProxyClosedDelay];
        };
    }
    [self.startSessionTimer start];
}

-(void) onProtocolClosed {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    
    [self notifyProxyClosed];
}

-(void) onError:(NSString*) info exception:(NSException*) e {
    [self invokeMethodOnDelegates:@selector(onError:) withObject:e];
}

- (void)handleProtocolSessionStarted:(SDLServiceType)serviceType sessionID:(Byte)sessionID version:(Byte)maxVersionForModule {
    // Turn off the timer, the start session response came back
    [self.startSessionTimer cancel];

    NSString *logMessage = [NSString stringWithFormat:@"StartSession (response)\nSessionId: %d for serviceType %d", sessionID, serviceType];
    [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];

    if (_version <= 1) {
        if (maxVersionForModule >= 2) {
            _version = maxVersionForModule;
        }
    }

    if (serviceType == SDLServiceType_RPC || _version >= 2) {
        [self invokeMethodOnDelegates:@selector(onProxyOpened) withObject:nil];
    }
}

- (void) onProtocolMessageReceived:(SDLProtocolMessage*) msgData {
    @try {
        [self handleProtocolMessage:msgData];
    }
    @catch (NSException * e) {
        NSString *logMessage = [NSString stringWithFormat:@"Proxy: Failed to handle protocol message %@", e];
        [SDLDebugTool logInfo:logMessage withType:SDLDebugType_Debug toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    }
}


#pragma mark - Message sending and recieving
- (void)sendRPC:(SDLRPCMessage *)message {
    @try {
        [self.protocol sendRPC:message];
    } @catch (NSException *exception) {
        NSString *logMessage = [NSString stringWithFormat:@"Proxy: Failed to send RPC message: %@", message.name];
        [SDLDebugTool logInfo:logMessage withType:SDLDebugType_Debug toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    }
}

-(void) sendRPCRequest:(SDLRPCMessage*) msg {
    if ([msg isKindOfClass:SDLRPCRequest.class]) {
        [self sendRPC:msg];
    }
}

- (void)handleProtocolMessage:(SDLProtocolMessage *)incomingMessage {
    // Convert protocol message to dictionary
    NSDictionary* rpcMessageAsDictionary = [incomingMessage rpcDictionary];
    [self handleRPCDictionary:rpcMessageAsDictionary];
}

- (void)handleRPCDictionary:(NSDictionary *)dict {
    SDLRPCMessage* message = [[SDLRPCMessage alloc] initWithDictionary:[dict mutableCopy]];
    NSString* functionName = [message getFunctionName];
    NSString* messageType = [message messageType];
    
    // TODO: I don't think this does anything, confirm?
    // From the function name, create the corresponding RPCObject and initialize it
    NSString* functionClassName = [NSString stringWithFormat:@"SDL%@", functionName];
    SDLRPCMessage *newMessage = [[NSClassFromString(functionClassName) alloc] initWithDictionary:dict];
    
    // Log the RPC message out
    NSString *logMessage = [NSString stringWithFormat:@"%@", newMessage];
    [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    
    
    // Intercept and handle ourselves a bunch of things
    if ([functionName isEqualToString:NAMES_OnAppInterfaceUnregistered]
        || [functionName isEqualToString:NAMES_UnregisterAppInterface]) {
        [self handleRPCUnregistered:newMessage];
        return;
    }
    
    if ([messageType isEqualToString:NAMES_response]) {
        BOOL notGenericResponseMessage = ![functionName isEqualToString:@"GenericResponse"];
        if(notGenericResponseMessage) {
            [newMessage setFunctionName:[NSString stringWithFormat:@"%@Response", functionName]];
            functionName = [newMessage getFunctionName];
        } else {
            return;
        }
    }
    
    if ([functionName isEqualToString:@"RegisterAppInterfaceResponse"]) {
        [self handleRegisterAppInterfaceResponse:(SDLRPCResponse *)newMessage];
        return;
    }
    
    if ([functionName isEqualToString:@"EncodedSyncPDataResponse"]) {
        [SDLDebugTool logInfo:@"EncodedSyncPData (response)" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
        return;
    }
    
    if ([functionName isEqualToString:@"OnEncodedSyncPData"]) {
        [self handleSyncPData:newMessage];
        return;
    }
    
    if ([functionName isEqualToString:@"OnSystemRequest"]) {
        [self handleSystemRequest:dict];
        return;
    }
    
    if ([functionName isEqualToString:@"SystemRequestResponse"]) {
        [self handleSystemRequestResponse:newMessage];
        return;
    }
    
    // Formulate the name of the method to call and invoke the method on the delegate(s)
    NSString* handlerName = [NSString stringWithFormat:@"on%@:", functionName];
    SEL handlerSelector = NSSelectorFromString(handlerName);
    [self invokeMethodOnDelegates:handlerSelector withObject:newMessage];
    
    // When an OnHMIStatus notification comes in, after passing it on (above), generate an "OnLockScreenNotification"
    if ([functionName isEqualToString:@"OnHMIStatus"]) {
        [self handleAfterHMIStatus:newMessage];
    }
    
    // When an OnDriverDistraction notification comes in, after passing it on (above), generate an "OnLockScreenNotification"
    if ([functionName isEqualToString:@"OnDriverDistraction"]) {
        [self handleAfterDriverDistraction:newMessage];
    }
}

- (void)handleRpcMessage:(NSDictionary*) msg {
    [self handleRPCDictionary:msg];
}


#pragma mark - RPC Handlers
- (void)handleRPCUnregistered:(SDLRPCMessage *)message {
    NSString *logMessage = [NSString stringWithFormat:@"Unregistration forced by module. %@", message];
    [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC  toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    [self notifyProxyClosed];
}

- (void)handleRegisterAppInterfaceResponse:(SDLRPCResponse *)response {
    //Print Proxy Version To Console
    NSString *logMessage = [NSString stringWithFormat:@"Framework Version: %@", self.proxyVersion];
    [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    
    if (_version >= 4) {
        // Send the Mobile HMI state and register handlers for changing state
        [self sendMobileHMIState];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMobileHMIState) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMobileHMIState) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
}

- (void)handleSyncPData:(SDLRPCMessage *)message {
    // If URL != nil, perform HTTP Post and don't pass the notification to FMProxyListeners
    NSString *logMessage = [NSString stringWithFormat:@"OnEncodedSyncPData (notification)\n%@", message];
    [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    
    NSString *urlString = (NSString *)[message getParameters:@"URL"];
    NSDictionary *encodedSyncPData = (NSDictionary *)[message getParameters:@"data"];
    NSNumber *encodedSyncPTimeout = (NSNumber *)[message getParameters:@"Timeout"];
    
    if (urlString && encodedSyncPData && encodedSyncPTimeout) {
        [self sendEncodedSyncPData:encodedSyncPData toURL:urlString withTimeout:encodedSyncPTimeout];
    }
}

- (void)handleSystemRequest:(NSDictionary *)dict {
    
    [SDLDebugTool logInfo:@"OnSystemRequest (notification)" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    
    SDLOnSystemRequest* systemRequest = [[SDLOnSystemRequest alloc] initWithDictionary:[dict mutableCopy]];
    SDLRequestType *requestType = systemRequest.requestType;
    
    // Handle the various OnSystemRequest types
    if (requestType == [SDLRequestType PROPRIETARY]) {
        [self handleSystemRequestProprietary:systemRequest];
    } else if (requestType == [SDLRequestType QUERY_APPS]) {
        [self handleSystemRequestQueryApps:systemRequest];
    } else if (requestType == [SDLRequestType LAUNCH_APP]) {
        [self handleSystemRequestLaunchApp:systemRequest];
    }
}

- (void)handleSystemRequestResponse:(SDLRPCMessage *)message {
    NSString *logMessage = [NSString stringWithFormat:@"SystemRequest (response)\n%@", message];
    [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
}


#pragma mark Handle Post-Invoke of Delegate Methods
- (void)handleAfterHMIStatus:(SDLRPCMessage *)message {
    NSString *statusString = (NSString *)[message getParameters:NAMES_hmiLevel];
    SDLHMILevel *hmiLevel = [SDLHMILevel valueOf:statusString];
    _lsm.hmiLevel = hmiLevel;
    
    SEL callbackSelector = NSSelectorFromString(@"onOnLockScreenNotification:");
    [self invokeMethodOnDelegates:callbackSelector withObject:_lsm.lockScreenStatusNotification];
}

- (void)handleAfterDriverDistraction:(SDLRPCMessage *)message {
    NSString *stateString = (NSString *)[message getParameters:NAMES_state];
    BOOL state = [stateString isEqualToString:@"DD_ON"]?YES:NO;
    _lsm.driverDistracted = state;
    
    SEL callbackSelector = NSSelectorFromString(@"onOnLockScreenNotification:");
    [self invokeMethodOnDelegates:callbackSelector withObject:_lsm.lockScreenStatusNotification];
}


#pragma mark OnSystemRequest Handlers
- (void)handleSystemRequestProprietary:(SDLOnSystemRequest *)request {
    NSDictionary *JSONDictionary = [self validateAndParseSystemRequest:request];
    if (JSONDictionary == nil || request.url == nil) {
        return;
    }
    
    NSDictionary *requestData = JSONDictionary[@"HTTPRequest"];
    NSString *bodyString = requestData[@"body"];
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    // Parse and display the policy data.
    SDLPolicyDataParser *pdp = [[SDLPolicyDataParser alloc] init];
    NSData *policyData = [pdp unwrap:bodyData];
    if (policyData != nil) {
        [pdp parsePolicyData:policyData];
        NSString *logMessage = [NSString stringWithFormat:@"Policy Data from Module\n%@", pdp];
        [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    }
    
    // Send the HTTP Request
    NSURLSessionUploadTask *task = [self uploadTaskForBodyDataDictionary:JSONDictionary URLString:request.url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *logMessage = nil;
        
        if (error) {
            logMessage = [NSString stringWithFormat:@"OnSystemRequest (HTTP response) = ERROR: %@", error];
            [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
            return;
        }
        
        if (data == nil || data.length == 0) {
            [SDLDebugTool logInfo:@"OnSystemRequest (HTTP response) failure: no data returned" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
            return;
        }
        
        // Show the HTTP response
        [SDLDebugTool logInfo:@"OnSystemRequest (HTTP response)" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
        
        // Create the SystemRequest RPC to send to module.
        SDLSystemRequest *request = [[SDLSystemRequest alloc] init];
        request.correlationID = [NSNumber numberWithInt:POLICIES_CORRELATION_ID];
        request.requestType = [SDLRequestType PROPRIETARY];
        request.bulkData = data;
        
        // Parse and display the policy data.
        SDLPolicyDataParser *pdp = [[SDLPolicyDataParser alloc] init];
        NSData *policyData = [pdp unwrap:data];
        if (policyData) {
            [pdp parsePolicyData:policyData];
            logMessage = [NSString stringWithFormat:@"Policy Data from Cloud\n%@", pdp];
            [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
        }
        
        // Send and log RPC Request
        logMessage = [NSString stringWithFormat:@"SystemRequest (request)\n%@\nData length=%lu", [request serializeAsDictionary:2], (unsigned long)data.length ];
        [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
        [self sendRPC:request];
    }];
    [task resume];
}

- (void)handleSystemRequestQueryApps:(SDLOnSystemRequest *)request {
    NSURLSessionDataTask *task = nil;
    task = [self dataTaskForSystemRequestURLString:request.url completionHandler:^(NSData *data, NSURLResponse *response, NSError *requestError) {
        if ([self.activeSystemRequestTasks containsObject:task]) {
            [self.activeSystemRequestTasks removeObject:task];
        }
        
        if (requestError != nil) {
            NSString *logMessage = [NSString stringWithFormat:@"OnSystemRequest failure (HTTP response), upload task failed: %@", requestError.localizedDescription];
            [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
            return;
        }
        
        NSError *JSONError = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&JSONError];
        if (JSONError != nil) {
            NSString *logMessage = [NSString stringWithFormat:@"OnSystemRequest failure (HTTP response), data parsing failed: %@", JSONError.localizedDescription];
            [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
            return;
        }
        
        [SDLQueryAppsManager filterQueryResponse:responseDictionary completionBlock:^(NSData *filteredResponseData, NSError *error) {
            if (error != nil) {
                NSString *logMessage = [NSString stringWithFormat:@"OnSystemRequest failure, filtering response failed: %@", error.localizedDescription];
                [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
                return;
            }
            
            SDLSystemRequest *request = [[SDLSystemRequest alloc] init];
            request.requestType = [SDLRequestType QUERY_APPS];
            request.bulkData = filteredResponseData;
            
            NSString *logMessage = [NSString stringWithFormat:@"SystemRequest (request)\n%@\nData length=%lu", [request serializeAsDictionary:2], (unsigned long)data.length];
            [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
            [self sendRPC:request];
        }];
    }];
    [self.activeSystemRequestTasks addObject:task];
    [task resume];
}

- (void)handleSystemRequestLaunchApp:(SDLOnSystemRequest *)request {
    NSURL *URLScheme = [NSURL URLWithString:request.url];
    if (URLScheme == nil) {
        [SDLDebugTool logInfo:[NSString stringWithFormat:@"Launch App failure: invalid URL sent from module: %@", request.url] withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
        return;
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:URLScheme]) {
        [[UIApplication sharedApplication] openURL:URLScheme];
    }
}

/**
 *  Determine if the System Request is valid and return it's JSON dictionary, if available.
 *
 *  @param request The system request to parse
 *
 *  @return A parsed JSON dictionary, or nil if it couldn't be parsed
 */
- (NSDictionary *)validateAndParseSystemRequest:(SDLOnSystemRequest *)request {
    NSString *urlString = request.url;
    SDLFileType *fileType = request.fileType;
    
    // Validate input
    if (urlString == nil || [NSURL URLWithString:urlString] == nil) {
        [SDLDebugTool logInfo:@"OnSystemRequest (notification) failure: url is nil" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
        return nil;
    }
    
    if (fileType != [SDLFileType JSON]) {
        [SDLDebugTool logInfo:@"OnSystemRequest (notification) failure: file type is not JSON" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
        return nil;
    }
    
    // Get data dictionary from the bulkData
    NSError *error = nil;
    NSDictionary *JSONDictionary = [NSJSONSerialization JSONObjectWithData:request.bulkData options:kNilOptions error:&error];
    if (error != nil) {
        [SDLDebugTool logInfo:@"OnSystemRequest failure: notification data is not valid JSON." withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
        return nil;
    }
    
    return JSONDictionary;
}

/**
 *  Generate an NSURLSessionUploadTask for System Request
 *
 *  @param dictionary        The system request dictionary that contains the HTTP data to be sent
 *  @param urlString         A string containing the URL to send the upload to
 *  @param completionHandler A completion handler returning the response from the server to the upload task
 *
 *  @return The upload task, which can be started by calling -[resume]
 */
- (NSURLSessionUploadTask *)uploadTaskForBodyDataDictionary:(NSDictionary *)dictionary URLString:(NSString *)urlString completionHandler:(URLSessionTaskCompletionHandler)completionHandler {
    NSParameterAssert(dictionary != nil);
    NSParameterAssert(urlString != nil);
    NSParameterAssert(completionHandler != NULL);
    
    // Extract data from the dictionary
    NSDictionary *requestData = dictionary[@"HTTPRequest"];
    NSDictionary *headers = requestData[@"headers"];
    NSString *contentType = headers[@"ContentType"];
    NSTimeInterval timeout = [headers[@"ConnectTimeout"] doubleValue];
    NSString *method = headers[@"RequestMethod"];
    NSString *bodyString = requestData[@"body"];
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    // NSURLSession configuration
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:contentType forHTTPHeaderField:@"content-type"];
    request.timeoutInterval = timeout;
    request.HTTPMethod = method;
    
    // Logging
    NSString *logMessage = [NSString stringWithFormat:@"OnSystemRequest (HTTP Request) to URL %@", urlString];
    [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    
    // Create the upload task
    return [[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:bodyData completionHandler:completionHandler];
}

/**
 *  Generate an NSURLSessionDataTask for System Requests
 *
 *  @param urlString         A string containing the URL to request data from
 *  @param completionHandler A completion handler returning the response from the server to the data task
 *
 *  @return The data task, which can be started by calling -[resume]
 */
- (NSURLSessionDataTask *)dataTaskForSystemRequestURLString:(NSString *)urlString completionHandler:(URLSessionTaskCompletionHandler)completionHandler {
    NSParameterAssert(urlString != nil);
    NSParameterAssert(completionHandler != nil);
    
    NSString *logMessage = [NSString stringWithFormat:@"OnSystemRequest (HTTP Request to URL: %@", urlString];
    [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    
    // Create and return the data task
    return [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlString]];
}


#pragma mark - Delegate management
-(void) addDelegate:(NSObject<SDLProxyListener>*) delegate {
    @synchronized(self.proxyListeners) {
        [self.proxyListeners addObject:delegate];
    }
}

- (void)invokeMethodOnDelegates:(SEL)aSelector withObject:(id)object {
    [self.proxyListeners enumerateObjectsUsingBlock:^(id listener, NSUInteger idx, BOOL *stop) {
        if ([(NSObject *)listener respondsToSelector:aSelector]) {
            [(NSObject *)listener performSelectorOnMainThread:aSelector withObject:object waitUntilDone:NO];
        }
    }];
}


#pragma mark - System Request and SyncP handling
-(void)sendEncodedSyncPData:(NSDictionary*)encodedSyncPData toURL:(NSString*)urlString withTimeout:(NSNumber*) timeout{
    
    // Configure HTTP URL & Request
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // Configure HTTP Session
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPAdditionalHeaders = @{@"Content-Type": @"application/json"};
    config.timeoutIntervalForRequest = 60;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // Prepare the data in the required format
    NSString *encodedSyncPDataString = [[NSString stringWithFormat:@"%@", encodedSyncPData] componentsSeparatedByString:@"\""][1];
    NSArray *array = [NSArray arrayWithObject:encodedSyncPDataString];
    NSDictionary *dictionary = @{@"data": array};
    NSError *JSONSerializationError = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:&JSONSerializationError];
    if (JSONSerializationError) {
        NSString *logMessage = [NSString stringWithFormat:@"Error formatting data for HTTP Request. %@", JSONSerializationError];
        [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
        return;
    }
    
    // Send the HTTP Request
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [self SyncPDataNetworkRequestCompleteWithData:data response:response error:error];
    }];
    [uploadTask resume];
    
    [SDLDebugTool logInfo:@"OnEncodedSyncPData (HTTP request)" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
}

// Handle the OnEncodedSyncPData HTTP Response
- (void)SyncPDataNetworkRequestCompleteWithData:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error {
    // Sample of response: {"data":["SDLKGLSDKFJLKSjdslkfjslkJLKDSGLKSDJFLKSDJF"]}
    [SDLDebugTool logInfo:@"OnEncodedSyncPData (HTTP response)" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    
    // Validate response data.
    if (data == nil || data.length == 0) {
        [SDLDebugTool logInfo:@"OnEncodedSyncPData (HTTP response) failure: no data returned" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
        return;
    }
    
    // Convert data to RPCRequest
    NSError *JSONConversionError = nil;
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&JSONConversionError];
    if (!JSONConversionError) {
        SDLEncodedSyncPData *request = [[SDLEncodedSyncPData alloc] init];
        request.correlationID = [NSNumber numberWithInt:POLICIES_CORRELATION_ID];
        request.data = [responseDictionary objectForKey:@"data"];
        
        [self sendRPC:request];
    }
    
}


#pragma mark - PutFile Streaming
- (void)putFileStream:(NSInputStream*)inputStream :(SDLPutFile*)putFileRPCRequest
{
    [self putFileStream:inputStream withRequest:putFileRPCRequest];
}

#pragma mark - PutFile Streaming
- (void)putFileStream:(NSInputStream*)inputStream withRequest:(SDLPutFile*)putFileRPCRequest
{
    inputStream.delegate = self;
    objc_setAssociatedObject(inputStream, @"SDLPutFile", putFileRPCRequest, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(inputStream, @"BaseOffset", [putFileRPCRequest offset], OBJC_ASSOCIATION_RETAIN);

    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode
{
    switch(eventCode) {
        case NSStreamEventHasBytesAvailable:
        {
            @autoreleasepool {
                // Grab some bytes from the stream and send them in a SDLPutFile RPC Request
                NSUInteger currentStreamOffset = [[stream propertyForKey:NSStreamFileCurrentOffsetKey] unsignedIntegerValue];

                NSUInteger bufferSize = self.transport.MTU;
                uint8_t *buffer = malloc(bufferSize);
                if (buffer) {
                    NSUInteger len = [(NSInputStream *)stream read:buffer maxLength:bufferSize];
                    if(len > 0)
                    {
                        NSData *data = [NSData dataWithBytes:buffer length:len];

                        NSUInteger baseOffset = [(NSNumber*)objc_getAssociatedObject(stream, @"BaseOffset") unsignedIntegerValue];
                        NSUInteger newOffset = baseOffset + currentStreamOffset;

                        SDLPutFile* putFileRPCRequest = (SDLPutFile*)objc_getAssociatedObject(stream, @"SDLPutFile");
                        [putFileRPCRequest setOffset:[NSNumber numberWithUnsignedInteger:newOffset]];
                        [putFileRPCRequest setLength:[NSNumber numberWithUnsignedInteger:len]];
                        [putFileRPCRequest setBulkData:data];

                        [self sendRPC:putFileRPCRequest];
                        data = nil;

                    }
                    free(buffer);
                } else {
                    [SDLDebugTool logInfo:@"Could not allocate stream read buffer."];
                }
            }
            
            break;
        }
        case NSStreamEventEndEncountered:
        {
            // Cleanup the stream
            [stream close];
            [stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            
            break;
        }
        case NSStreamEventErrorOccurred:
        {
            [SDLDebugTool logInfo:@"Stream Event: Error" withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
            break;
        }
        default:
        {
            break;
        }
    }
}


#pragma mark - Siphon management
+(void)enableSiphonDebug {
    [SDLSiphonServer enableSiphonDebug];
}

+(void)disableSiphonDebug {
    [SDLSiphonServer disableSiphonDebug];
}

@end
