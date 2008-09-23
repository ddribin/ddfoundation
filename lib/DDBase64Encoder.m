//
//  DDBase64Encoder.m
//  DDFoundation
//
//  Created by Dave Dribin on 9/23/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import "DDBase64Encoder.h"

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

enum state
{
    BYTE_0,
    BYTE_1,
    BYTE_2,
};

@implementation DDBase64Encoder

+ (NSString *)encodeData:(NSData *)data;
{
    DDBase64Encoder * encoder = [[[self alloc] init] autorelease];
    [encoder encodeData:data];
    return [encoder finishEncoding];
}

- (id)init
{
    self = [super init];
    if (self == nil)
        return nil;
    
    [self reset];
    
    return self;
}

- (void)dealloc
{
    [_output release];
    [super dealloc];
}

- (void)reset;
{
    [_output release];
    _output = [[NSMutableString alloc ]init];
    _state = BYTE_0;
}

- (NSString *)finishEncoding;
{
    uint32_t value;
    switch (_state)
    {
        case BYTE_1:
            // 00000000 xxxxxxxx xxxxxxxx
            //       ee eeee    
            value = (_buffer >> 12) & 0x3F;
            [_output appendFormat:@"%c==", encodingTable[value]];
            break;
            
        case BYTE_2:
            // 00000000 11111111 xxxxxxxx
            //              eeee ee
            value = (_buffer >> 6) & 0x3F;
            [_output appendFormat:@"%c=", encodingTable[value]];
            break;
    }

    return _output;
    [self reset];
}

- (void)encodeByte:(uint8_t)byte;
{
    uint32_t value;
    switch (_state)
    {
        case BYTE_0:
            // 00000000 xxxxxxxxx xxxxxxxx
            // eeeeee
            _buffer = 0;
            _buffer |= (byte << 16);
            
            value = (_buffer >> 18) & 0x3F;
            [_output appendFormat:@"%c", encodingTable[value]];
            
            _state = BYTE_1;
            break;
            
        case BYTE_1:
            // 00000000 11111111 xxxxxxxx
            //       ee eeee    
            _buffer |= (byte << 8);
            
            value = (_buffer >> 12) & 0x3F;
            [_output appendFormat:@"%c", encodingTable[value]];
            
            _state = BYTE_2;
            break;
            
        case BYTE_2:
            // 00000000 11111111 22222222
            //              eeee eeEEEEEE
            _buffer |= (byte);
            value = (_buffer >> 6) & 0x3F;
            [_output appendFormat:@"%c", encodingTable[value]];
            value = (_buffer) & 0x3F;
            [_output appendFormat:@"%c", encodingTable[value]];
            
            _state = BYTE_0;
            break;
    }
}

- (void)encodeData:(NSData *)data;
{
    const uint8_t * bytes = [data bytes];
    unsigned length = [data length];
    unsigned i;
    for (i = 0; i < length; i++)
    {
        [self encodeByte:bytes[i]];
    }
}

@end
