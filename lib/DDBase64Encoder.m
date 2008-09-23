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

@interface DDBase64Encoder ()

- (void)appendCharacter:(char)character;
- (void)appendCharacters:(const char *)characters;

@end


@implementation DDBase64Encoder

+ (NSString *)encodeData:(NSData *)data;
{
    DDBase64Encoder * encoder = [[[self alloc] init] autorelease];
    [encoder encodeData:data];
    return [encoder finishEncoding];
}

+ (NSString *)encodeData:(NSData *)data options:(DDBase64EncoderOptions)options;
{
    DDBase64Encoder * encoder = [[[self alloc] initWithOptions:options] autorelease];
    [encoder encodeData:data];
    return [encoder finishEncoding];
}


- (id)init;
{
    return [self initWithOptions:0];
}

- (id)initWithOptions:(DDBase64EncoderOptions)options;
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _addPadding = ((options & DDBase64EncoderOptionNoPadding) == 0);
    _addLineBreaks = ((options & DDBase64EncoderOptionAddLineBreaks) != 0);
    
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
    _buffer = 0;
}

- (NSString *)finishEncoding;
{
    uint32_t value;
    switch (_state)
    {
        case BYTE_0:
            // xxxx-xxxxx xxxx-xxxxx xxxx-xxxx
            // Buffer is empty
            break;
            
        case BYTE_1:
            // 0000-0000 1111-1111 xxxx-xxxx
            //        ee eeee    
            value = (_buffer >> 12) & 0x3F;
            [self appendCharacter:encodingTable[value]];
            if (_addPadding)
                [self appendCharacters:"=="];
            
            
            break;
            
        case BYTE_2:
            // 0000-0000 1111-1111 xxxx-xxxx
            //                eeee ee
            value = (_buffer >> 6) & 0x3F;
            [_output appendFormat:@"%c", encodingTable[value]];
            if (_addPadding)
                [self appendCharacter:'='];
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
            _buffer |= (byte << 16);
            
            // 0000-0000 xxxx-xxxxx xxxx-xxxx
            // eeee-ee
            value = (_buffer >> 18) & 0x3F;
            [self appendCharacter:encodingTable[value]];
            
            _state = BYTE_1;
            break;
            
        case BYTE_1:
            _buffer |= (byte << 8);
            
            // 0000-0000 1111-1111 xxxx-xxxx
            //        ee eeee    
            value = (_buffer >> 12) & 0x3F;
            [self appendCharacter:encodingTable[value]];
            
            _state = BYTE_2;
            break;
            
        case BYTE_2:
            _buffer |= byte;

            // 0000-0000 1111-1111 2222-2222
            //                eeee eeE-EEEEE
            value = (_buffer >> 6) & 0x3F;
            [self appendCharacter:encodingTable[value]];
            
            value = _buffer & 0x3F;
            [self appendCharacter:encodingTable[value]];
            
            _state = BYTE_0;
            _buffer = 0;
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

- (void)appendCharacters:(const char *)characters;
{
    while (*characters != 0)
    {
        [self appendCharacter:*characters];
        characters++;
    }
}

- (void)appendCharacter:(char)ch;
{
    [_output appendFormat:@"%c", ch];
    _currentLineLength++;
    if (_addLineBreaks && (_currentLineLength >= 64))
    {
        [_output appendString:@"\n"];
        _currentLineLength = 0;
    }
}

@end
