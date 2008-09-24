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
- (void)advanceByteIndex;

@end

static const int kMaxByteIndex = 2;
static const int kMaxGroupIndex = 3;

static const char kRfc4648EncodingTable[] =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation DDBase64Encoder

- (void)reset;
{
    [super reset];
    _buffer = 0;
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
    }
    else if (_byteIndex == 2)
    {
        [self encodeGroup:2];
        [self encodeGroup:3];
    }
    
    [self advanceByteIndex];
}

- (NSString *)finishEncoding;
{
    if (_byteIndex == 1)
    {
        [self encodeGroup:1];
        [self appendPadCharacters:2];
    }
    else if (_byteIndex == 2)
    {
        [self encodeGroup:2];
        [self appendPadCharacters:1];
    }
    
    NSString * output = [[_output retain] autorelease];
    [self reset];
    return output;
}

- (void)addByteToBuffer:(uint8_t)byte;
{
    int bitsToShift = (kMaxByteIndex - _byteIndex) * 8;
    _buffer |= (byte << bitsToShift);
}

- (void)encodeGroup:(int)group
{
    unsigned bitsToShift = (kMaxGroupIndex - group) * 6;
    uint8_t value = (_buffer >> bitsToShift) & 0x3F;
    [self appendCharacter:kRfc4648EncodingTable[value]];
}

- (void)advanceByteIndex;
{
    _byteIndex++;
    if (_byteIndex > kMaxByteIndex)
    {
        _byteIndex = 0;
        _buffer = 0;
    }
}

@end
