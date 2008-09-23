//
//  DDBase32Encoder.m
//  DDFoundation
//
//  Created by Dave Dribin on 9/23/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import "DDBase32Encoder.h"

@interface DDBase32Encoder ()

- (void)addByteToBuffer:(uint8_t)byte;
- (void)encodeGroup:(int)group;
- (void)appendPadCharacters:(int)count;
- (void)appendCharacter:(char)character;

@end


@implementation DDBase32Encoder

+ (NSString *)encodeData:(NSData *)data;
{
    DDBase32Encoder * encoder = [[[self alloc] init] autorelease];
    [encoder encodeData:data];
    return [encoder finishEncoding];
}

+ (NSString *)encodeData:(NSData *)data options:(DDBase32EncoderOptions)options;
{
    DDBase32Encoder * encoder = [[[self alloc] initWithOptions:options] autorelease];
    [encoder encodeData:data];
    return [encoder finishEncoding];
}


- (id)init;
{
    return [self initWithOptions:0];
}

- (id)initWithOptions:(DDBase32EncoderOptions)options;
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _addPadding = ((options & DDBase32EncoderOptionNoPadding) == 0);
    _addLineBreaks = ((options & DDBase32EncoderOptionAddLineBreaks) != 0);
    
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
        [self encodeGroup:2];
        _byteIndex = 2;
    }
    else if (_byteIndex == 2)
    {
        [self encodeGroup:3];
        _byteIndex = 3;
    }
    else if (_byteIndex == 3)
    {
        [self encodeGroup:4];
        [self encodeGroup:5];
        _byteIndex = 4;
    }
    else if (_byteIndex == 4)
    {
        [self encodeGroup:6];
        [self encodeGroup:7];
        _byteIndex = 0;
        _buffer = 0;
    }
}

/*
 The 40-bit buffer layout:
 
  3                 3                   2                   1                   0
  9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
 +----byte 0-----+-----byte 1----+----byte 2-----+----byte 3-----+----byte 4-----+
 |7 6 5 4 3 2 1 0|7 6 5 4 3 2 1 0|7 6 5 4 3 2 1 0|7 6 5 4 3 2 1 0|7 6 5 4 3 2 1 0|
 +---------+-----+---+-----------+-------+-------+-+---------+---+-----+---------+
 |4 3 2 1 0|4 3 2 1 0|4 3 2 1 0|4 3 2 1 0|4 3 2 1 0|4 3 2 1 0|4 3 2 1 0|4 3 2 1 0|
 +-group 0-+-group 1-+-group 2-+-group 3-+-group 4-+-group 5-+-group 6-+-group 7-+
 */

- (void)addByteToBuffer:(uint8_t)byte;
{
    int bitsToShift = (4 - _byteIndex) * 8;
    _buffer |= (((uint64_t)byte) << bitsToShift);
}

- (void)encodeGroup:(int)group
{
    static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ23456789+/";
    
    unsigned bitsToShift = (7 - group) * 5;
    uint8_t value = (_buffer >> bitsToShift) & 0x1F;
    [self appendCharacter:encodingTable[value]];
}

- (NSString *)finishEncoding;
{
    if (_byteIndex == 1)
    {
        [self encodeGroup:1];
        [self appendPadCharacters:6];
    }
    else if (_byteIndex == 2)
    {
        [self encodeGroup:3];
        [self appendPadCharacters:4];
    }
    else if (_byteIndex == 3)
    {
        [self encodeGroup:4];
        [self appendPadCharacters:3];
    }
    else if (_byteIndex == 4)
    {
        [self encodeGroup:6];
        [self appendPadCharacters:1];
    }
    
    return _output;
    [self reset];
}

- (void)appendPadCharacters:(int)count;
{
    if (!_addPadding)
        return;
    
    int i;
    for (i = 0; i < count; i++)
    {
        [self appendCharacter:'='];
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
