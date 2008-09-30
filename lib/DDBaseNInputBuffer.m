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
#import "NSString+DDExtensions.h"


static int ceildiv(int x, int y)
{
    return (x + y - 1)/y;
}

@interface DDBaseNInputBuffer ()

- (uint64_t)valueOfBitRange:(NSRange)bitRange;
- (void)setValueOfBitRange:(NSRange)bitRange toValue:(uint64_t)value;

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
    _numberOfGroups = _capacityInBits / _bitsPerGroup;
    _numberOfBytes = _capacityInBits / 8;
    
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

- (unsigned)numberOfBytes;
{
    return _numberOfBytes;
}

- (unsigned)numberOfFilledBytes;
{
    return ceildiv(_lengthInBits, 8);
}

- (BOOL)isFull;
{
    return (_lengthInBits == _capacityInBits);
}

- (unsigned)numberOfBitsAvailable;
{
    return _capacityInBits - _lengthInBits;
}

- (void)reset;
{
    _byteBuffer = 0;
    _lengthInBits = 0;
}

- (void)appendByte:(uint8_t)byte;
{
    NSAssert([self numberOfBitsAvailable] >= 8, @"No room to insert byte");

    [self setValueOfBitRange:NSMakeRange(_lengthInBits, 8) toValue:byte];
    _lengthInBits += 8;
}

- (void)appendGroupValue:(uint8_t)groupValue;
{
    NSAssert([self numberOfBitsAvailable] >= _bitsPerGroup, @"No room to insert byte");
    
    [self setValueOfBitRange:NSMakeRange(_lengthInBits, _bitsPerGroup) toValue:groupValue];
    _lengthInBits += _bitsPerGroup;
}

- (uint8_t)valueAtGroupIndex:(unsigned)groupIndex;
{
    return [self valueOfBitRange:NSMakeRange(groupIndex*_bitsPerGroup, _bitsPerGroup)];
}

- (uint8_t)valueAtByteIndex:(unsigned)byteIndex;
{
    return [self valueOfBitRange:NSMakeRange(byteIndex*8, 8)];
}

/*
 * Bit range manipulation
 *
 * Bit range location is relative to most significant bit, thus bit 0 of
 * a 24-bit byte buffer is bit 23 of the byte buffer.  A bit range with
 * location 0, length 4 of a 24-bit byte buffer is bits 23 through 20 of
 * the byte buffer.
 */

- (uint64_t)valueOfBitRange:(NSRange)bitRange;
{
    unsigned bitsToShift = _capacityInBits - bitRange.location - bitRange.length;
    uint64_t shiftedValue = (_byteBuffer >> bitsToShift);

    uint64_t mask = (1 << bitRange.length) - 1;
    return shiftedValue & mask;
}

- (void)setValueOfBitRange:(NSRange)bitRange toValue:(uint64_t)value;
{
    uint64_t mask = (1 << bitRange.length) - 1;
    value &= mask;

    unsigned bitsToShift = _capacityInBits - bitRange.location - bitRange.length;
    uint64_t shiftedValue = (value << bitsToShift);
    _byteBuffer |= shiftedValue;
}

@end
