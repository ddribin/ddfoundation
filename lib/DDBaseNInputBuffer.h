/*
 * Copyright (c) 2007-2009 Dave Dribin
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

#import <Foundation/Foundation.h>


@interface DDBaseNInputBuffer : NSObject
{
    uint64_t _byteBuffer;
    unsigned _capacityInBits;
    unsigned _lengthInBits;
    unsigned _bitsPerGroup;
    unsigned _numberOfGroups;
    unsigned _numberOfBytes;
}

- (id)initWithCapacityInBits:(unsigned)capacityInBits
                bitsPerGroup:(unsigned)bitsPerGroup;

- (unsigned)numberOfGroups;

- (unsigned)numberOfFilledGroups;

- (unsigned)numberOfBytes;

- (unsigned)numberOfFilledBytes;

- (BOOL)isFull;

- (unsigned)numberOfBitsAvailable;

- (void)reset;

- (void)appendByte:(uint8_t)byte;

- (void)appendGroupValue:(uint8_t)groupValue;

- (uint8_t)valueAtGroupIndex:(unsigned)groupIndex;

- (uint8_t)valueAtByteIndex:(unsigned)byteIndex;

@end
