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
    _byteBuffer |= (byte << bitsToShift);
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
