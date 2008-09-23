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

@end


@implementation DDBase64Encoder

- (void)reset;
{
    [super reset];
    _buffer = 0;
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
    int bitsToShift = (2 - _byteIndex) * 8;
    _buffer |= (byte << bitsToShift);
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
        [self appendPadCharacters:2];
    }
    else if (_byteIndex == 2)
    {
        [self encodeGroup:2];
        [self appendPadCharacters:1];
    }
    
    return _output;
    [self reset];
}

@end
