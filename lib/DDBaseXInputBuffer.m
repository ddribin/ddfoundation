//
//  DDBaseInputBuffer.m
//  DDFoundation
//
//  Created by Dave Dribin on 9/27/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import "DDBaseXInputBuffer.h"


static int ceildiv(int x, int y)
{
    return (x + y - 1)/y;
}

@implementation DDBaseXInputBuffer


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

+ (id)base64InputBuffer;
{
    id inputBuffer = [[self alloc] initWithCapacity:3 bitsPerGroup:6];
    return [inputBuffer autorelease];
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

+ (id)base32InputBuffer;
{
    id inputBuffer = [[self alloc] initWithCapacity:5 bitsPerGroup:5];
    return [inputBuffer autorelease];
}


- (id)initWithCapacity:(unsigned)capacity bitsPerGroup:(unsigned)bitsPerGroup;
{
    self = [super init];
    if (self == nil)
        return nil;
    
    NSAssert(capacity <= 8, @"Maximum buffer is 8 bytes");
    NSAssert(bitsPerGroup <= 8, @"Maximum bits per buffer is 8 bits");

    _capacity = capacity;
    _bitsPerGroup = bitsPerGroup;
    
    _groupBitMask = (1 << _bitsPerGroup) - 1;
    _numberOfGroups = (_capacity * 8) / _bitsPerGroup;
    
    [self reset];
    
    return self;
}

- (unsigned)length;
{
    return _length;
}

- (unsigned)numberOfGroups;
{
    return _numberOfGroups;
}

- (unsigned)numberOfFilledGroups;
{
    unsigned numberOfFilledBits = 8 * _length;
    return ceildiv(numberOfFilledBits, _bitsPerGroup);
}

- (BOOL)isFull;
{
    return (_length == _capacity);
}

- (void)addByte:(uint8_t)byte;
{
    NSAssert(![self isFull], @"Cannot insert into full buffer");

    int bitsToShift = (_capacity - _length - 1) * 8;
    _byteBuffer |= ((uint64_t)byte << bitsToShift);
    _length++;
}

- (void)reset;
{
    _byteBuffer = 0;
    _length = 0;
}

- (uint8_t)valueAtGroupIndex:(unsigned)groupIndex;
{
    unsigned bitsToShift = (_numberOfGroups - groupIndex - 1) * _bitsPerGroup;
    uint8_t value = (_byteBuffer >> bitsToShift) & _groupBitMask;
    return value;
}

@end
