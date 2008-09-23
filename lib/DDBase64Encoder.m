//
//  DDBase64Encoder.m
//  DDFoundation
//
//  Created by Dave Dribin on 9/23/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import "DDBase64Encoder.h"

@interface DDBase64Encoder ()

- (void)addByteToBuffer:(uint8_t)byte;
- (void)encodeGroup:(int)group;
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
    _byteIndex = 0;
    _buffer = 0;
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

- (void)encodeByte:(uint8_t)byte;
{
    [self addByteToBuffer:byte];
    if (_byteIndex == 0)
    {
        [self encodeGroup:0];
        
        _byteIndex = 1;
    }
    else if (_byteIndex == 1)
    {
        [self encodeGroup:1];
        
        _byteIndex = 2;
    }
    else if (_byteIndex == 2)
    {
        [self encodeGroup:2];
        [self encodeGroup:3];
        
        _byteIndex = 0;
        _buffer = 0;
    }
}

/*
 The 24-bit buffer:
 
  2     2                   1                   0 
  3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
 +----byte 0-----+-----byte 1----+----byte 2-----+
 |7 6 5 4 3 2 1 0|7 6 5 4 3 2 1 0|7 6 5 4 3 2 1 0|
 +-----------+---+-------+-------+---+-----------+
 |5 4 3 2 1 0|5 4 3 2 1 0|5 4 3 2 1 0|5 4 3 2 1 0|
 +--group 0--+--group 1--+--group 2--+--group 3--+
 */

- (void)addByteToBuffer:(uint8_t)byte;
{
    int bytesToShift = (2 - _byteIndex);
    _buffer |= (byte << (bytesToShift * 8));
}

- (void)encodeGroup:(int)group
{
    static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    unsigned bitsToShift = (3 - group) * 6;
    uint8_t value = (_buffer >> bitsToShift) & 0x3F;
    [self appendCharacter:encodingTable[value]];
}

- (NSString *)finishEncoding;
{
    if (_byteIndex == 1)
    {
        [self encodeGroup:1];
        if (_addPadding)
            [self appendCharacters:"=="];
    }
    else if (_byteIndex == 2)
    {
        [self encodeGroup:2];
        if (_addPadding)
            [self appendCharacter:'='];
    }
    
    return _output;
    [self reset];
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
