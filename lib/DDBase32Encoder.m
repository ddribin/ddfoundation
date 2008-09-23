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

@end

static const int kMaxByteIndex = 4;
static const int kMaxGroupIndex = 7;

@implementation DDBase32Encoder

- (void)reset;
{
    [super reset];
    _buffer = 0;
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

- (void)encodeByte:(uint8_t)byte;
{
    [self addByteToBuffer:byte];
    if (_byteIndex == 0)
    {
        [self encodeGroup:0];
    }
    else if (_byteIndex == 1)
    {
        [self encodeGroup:1];
        [self encodeGroup:2];
    }
    else if (_byteIndex == 2)
    {
        [self encodeGroup:3];
    }
    else if (_byteIndex == 3)
    {
        [self encodeGroup:4];
        [self encodeGroup:5];
    }
    else if (_byteIndex == 4)
    {
        [self encodeGroup:6];
        [self encodeGroup:7];
    }
    
    _byteIndex++;
    if (_byteIndex > kMaxByteIndex)
    {
        _byteIndex = 0;
        _buffer = 0;
    }
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

- (void)addByteToBuffer:(uint8_t)byte;
{
    int bitsToShift = (kMaxByteIndex - _byteIndex) * 8;
    _buffer |= (((uint64_t)byte) << bitsToShift);
}

- (void)encodeGroup:(int)group
{
    static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ23456789+/";
    
    unsigned bitsToShift = (kMaxGroupIndex - group) * 5;
    uint8_t value = (_buffer >> bitsToShift) & 0x1F;
    [self appendCharacter:encodingTable[value]];
}

@end
