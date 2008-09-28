/*
 * Copyright (c) 2007-2008 Dave Dribin
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import "DDBaseNInputBuffer.h"


static int ceildiv(int x, int y)
{
    return (x + y - 1)/y;
}

@interface DDBaseNInputBuffer ()

- (unsigned)byteBufferBitFromInputBufferBit:(unsigned)inputBufferBit;

@end

@implementation DDBaseNInputBuffer

- (id)initWithCapacityInBits:(unsigned)capacityInBits
                bitsPerGroup:(unsigned)bitsPerGroup;
{
    self = [super init];
    if (self == nil)
        return nil;
    
    NSAssert(capacityInBits <= 64, @"Maximum buffer is 64 bits");
    NSAssert(bitsPerGroup <= 8, @"Maximum bits per buffer is 8 bits");

    _capacityInBits = capacityInBits;
    _bitsPerGroup = bitsPerGroup;
    
    _groupBitMask = (1 << _bitsPerGroup) - 1;
    _numberOfGroups = _capacityInBits / _bitsPerGroup;
    
    [self reset];
    
    return self;
}

- (unsigned)numberOfGroups;
{
    return _numberOfGroups;
}

- (unsigned)numberOfFilledGroups;
{
    return ceildiv(_lengthInBits, _bitsPerGroup);
}

- (BOOL)isFull;
{
    return (_lengthInBits == _capacityInBits);
}

- (void)reset;
{
    _byteBuffer = 0;
    _lengthInBits = 0;
}

- (void)appendByte:(uint8_t)byte;
{
    NSAssert(![self isFull], @"Cannot insert into full buffer");

    _lengthInBits += 8;
    int bitsToShift = [self byteBufferBitFromInputBufferBit:_lengthInBits];
    _byteBuffer |= ((uint64_t)byte << bitsToShift);
}

- (uint8_t)valueAtGroupIndex:(unsigned)groupIndex;
{
    unsigned lowestBitForGroup = (groupIndex+1) * _bitsPerGroup;
    unsigned bitsToShift = [self byteBufferBitFromInputBufferBit:lowestBitForGroup];
    uint8_t value = (_byteBuffer >> bitsToShift) & _groupBitMask;
    return value;
}


- (unsigned)byteBufferBitFromInputBufferBit:(unsigned)inputBufferBit;
{
    // Input bit zero starts from the high order bit in the byte buffer
    return _capacityInBits - inputBufferBit;
}

@end
