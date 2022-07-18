//
//  SDLProtocolProcessMessageByte.m
//  SmartDeviceLink
//
//  Created by George Miller on 7/13/22.
//  Copyright © 2022 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLProtocolHeader.h"
#import "SDLProtocolReceivedMessageProcessor.h"
#import "SDLProtocolReceivedMessageRouter.h"
#import "SDLSecurityType.h"

@implementation SDLProtocolReceivedMessageProcessor

-(id)init {
    self = [super init];
    version = 0;
    encrypted = false;
    frameType = 0;
    dataLength = 0;
    dataBytesRemaining = 0; //Counter for the data pump

    //Reset state
    [self ResetState];
    return self;
}

- (void)ResetState{
    // Flush Buffers
    self.headerBuffer = [NSMutableData dataWithCapacity:0];
    self.payloadBuffer = [NSMutableData dataWithCapacity:0];
    dataBytesRemaining = 0;
    
    // Reset state
    state = START_STATE;
    prevState = ERROR_STATE;

}

// Loop through the given bytes and call the state machien to process each byte.
- (void)stateMachineManager:(NSMutableData *)receiveBuffer withBlock:(CompletionBlock)completionBlock{
    //get a pointer to the bytes because NSMutableData is layered
    const char *bytes = [receiveBuffer bytes];
    
    //now loop through the bytes
    for (int i = 0; i < [receiveBuffer length]; i++)
    {
        //hand the byte to the state machine
        [self sdl_processMessagesStateMachine:bytes[i] withBlock:completionBlock];
    }
}

// This is the state machine
// It processes a single byte of a message, checks for errors,
// and builds up a header buffer and a payload buffer
// When the header and payload are complete, the message is processed
// The state of the state machine effectively tracks which byte of a message we are expecting next
// For reference: https://smartdevicelink.com/en/guides/sdl-overview-guides/protocol-spec/
// If a byte comes in that does not conform to spec, the buffers are flushed and state is reset.
- (void)sdl_processMessagesStateMachine:(Byte)currentByte withBlock:(CompletionBlock)completionBlock{
    
    Byte serviceType = 0x00;
    Byte controlFrameInfo = 0; // "Frame Info" in the documentation
    SDLProtocolHeader *header = nil;

    
    // State determines how we process the next byte, based on previous bytes.
    switch(state){
        case START_STATE:
            //Flush the buffers
            [self ResetState];
            
            // 4 bits for version
            //4 highest bits    // b1111 0000
            version = (currentByte & 0xF0 ) >> 4;

            // 1 bit for either encryption or compression, depending on version.
            // 4th lowest bit // b0000 1000
            encrypted = (currentByte & 0x08 ) >> 3;
            
            // 3 bits for frameType
            // 3 lowest bits  // b0000 0111
            frameType = (currentByte & 0x07 ) >> 0;

            // Set the next state
            state = SERVICE_TYPE_STATE;
            
            // Add the byte to the headerBuffer
            [self.headerBuffer appendBytes:&currentByte length:sizeof(currentByte)];
            
            // Check version for errors
            if ((version < 1 || version > 5)) {
                prevState=state;
                state = ERROR_STATE;
            }
            
            // Check for valid frameType
            if((frameType < SDLFrameTypeControl) || (frameType > SDLFrameTypeConsecutive)){
                prevState=state;
                state = ERROR_STATE;
                break;
            }
            break;
            
        case SERVICE_TYPE_STATE:
            // 8 bits for service type
            serviceType = currentByte;

            // Add the byte to the headerBuffer
            [self.headerBuffer appendBytes:&currentByte length:sizeof(currentByte)];
            
            // Check for errors
            switch (serviceType) {
                case 0x00: //SessionType.CONTROL:
                case 0x07: //SessionType.RPC:
                case 0x0A: //SessionType.PCM (Audio):
                case 0x0B: //SessionType.NAV (Video):
                case 0x0F: //SessionType.BULK (Hybrid):
                    state = CONTROL_FRAME_INFO_STATE;
                    break;
                default:
                    prevState=state;
                    state = ERROR_STATE;
                    break;
            }
            break;
            
        case CONTROL_FRAME_INFO_STATE:
            // 8 bits for frame information
            controlFrameInfo = currentByte;
            
            // Set the next state
            state = SESSION_ID_STATE;
            
            // Add the byte to the headerBuffer
            [self.headerBuffer appendBytes:&currentByte length:sizeof(currentByte)];
            
            // Check for errors.
            //For these two frame types, the frame info should be 0x00
            if ((frameType == SDLFrameTypeFirst) || (frameType == SDLFrameTypeSingle)){
                if (controlFrameInfo != 0x00) {
                    prevState=state;
                    state = ERROR_STATE;
                }
            }
            break;
            
        case SESSION_ID_STATE:
            // 8 bits for frame information (SessionID)
            
            // Add the byte to the headerBuffer
            [self.headerBuffer appendBytes:&currentByte length:sizeof(currentByte)];
            
            // Set the next state
            state = DATA_SIZE_1_STATE;
            break;
        
        // 32 bits for data size
        case DATA_SIZE_1_STATE:
            dataLength = 0;
            dataLength += (currentByte & 0xFF ) << 24;
            state = DATA_SIZE_2_STATE;
            // Add the byte to the headerBuffer
            [self.headerBuffer appendBytes:&currentByte length:sizeof(currentByte)];
            break;
        case DATA_SIZE_2_STATE:
            dataLength += (currentByte & 0xFF ) << 16;
            state = DATA_SIZE_3_STATE;
            // Add the byte to the headerBuffer
            [self.headerBuffer appendBytes:&currentByte length:sizeof(currentByte)];
            break;
        case DATA_SIZE_3_STATE:
            dataLength += (currentByte & 0xFF ) << 8;
            state = DATA_SIZE_4_STATE;
            // Add the byte to the headerBuffer
            [self.headerBuffer appendBytes:&currentByte length:sizeof(currentByte)];
            break;
        case DATA_SIZE_4_STATE:
            dataLength += (currentByte & 0xFF ) << 0;
            
            // Set the next state
            state = MESSAGE_1_STATE;
            
            // Add the byte to the headerBuffer
            [self.headerBuffer appendBytes:&currentByte length:sizeof(currentByte)];
            
            // Set the counter for the data pump.
            dataBytesRemaining = dataLength;
            
            // Version 1 does not have a message ID
            if( version == 1){
                if (dataLength == 0) {
                    state = FINISHED_STATE; //We are done if we don't have any payload
                } else {
                    //skip ahead to the data pump state
                    state = DATA_PUMP_STATE;
                }
            }
            
            Byte headerSize = 0;
            // Figure out headerSize
            if( version == 1){
                headerSize = 8;
            }else{
                headerSize = 12;
            }
            
            int maxMtuSize = 0;
            // Figure out max MTU size
            if (version <= 2){
                maxMtuSize = 1500;
            } else{
                maxMtuSize = 131084;
            }
            
            // Check data length (does it conform to spec?)
            if (dataLength > (maxMtuSize - headerSize)) {
                prevState=state;
                state = ERROR_STATE;
                break;
            }
            
            // If this is the first frame, it is not encrypted, and the length is not 8 then error.
            if ((frameType == SDLFrameTypeFirst) && (dataLength != 0x08) && (encrypted == false)) {
                prevState=state;
                state = ERROR_STATE;
                break;
            }
            
            break;
            
        // 32 bits for data size (version 2+)
        case MESSAGE_1_STATE:
            //messageId += (currentByte & 0xFF ) << 24;
            state = MESSAGE_2_STATE;
            // Add the byte to the headerBuffer
            [self.headerBuffer appendBytes:&currentByte length:sizeof(currentByte)];
            break;
        case MESSAGE_2_STATE:
            //messageId += (currentByte & 0xFF ) << 16;
            state = MESSAGE_3_STATE;
            // Add the byte to the headerBuffer
            [self.headerBuffer appendBytes:&currentByte length:sizeof(currentByte)];
            break;
        case MESSAGE_3_STATE:
            //messageId += (currentByte & 0xFF ) << 8;
            state = MESSAGE_4_STATE;
            // Add the byte to the headerBuffer
            [self.headerBuffer appendBytes:&currentByte length:sizeof(currentByte)];
            break;
        case MESSAGE_4_STATE:
            // The 4 message states are responsible for changing the 4 byte message ID into a single value.
            //messageId += (currentByte & 0xFF ) << 0;
            
            // Set next state
            if (dataLength == 0) {
                state = FINISHED_STATE;
            } else {
                state = DATA_PUMP_STATE;
            }
            // Add the byte to the headerBuffer
            [self.headerBuffer appendBytes:&currentByte length:sizeof(currentByte)];
            
            break;
        
        case DATA_PUMP_STATE:
            // The pump state takes bytes in and adds them to the payload array
            
            // Add the byte to the payloadBuffer
            [self.payloadBuffer appendBytes:&currentByte length:sizeof(currentByte)];

            // Decrement dataBytesRemaining
            dataBytesRemaining--;
            
            //Check if all the bytes have been read
            if( dataBytesRemaining <= 0) {
                
                // Create a header
                header = [SDLProtocolHeader headerForVersion:version];
                // Process headerBuffer
                [header parse:self.headerBuffer];
                
                //pass the header and payload to the completion
                completionBlock(header.encrypted, header, [NSData dataWithData:self.payloadBuffer]);
                
                //Reset state for the next message
                [self ResetState];
            }
            break;
        case ERROR_STATE:
        default:
            // Reset state
            [self ResetState];
            break;
    } // End of switch
}
@end
