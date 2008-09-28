//
//  DDBaseInputBuffer.h
//  DDFoundation
//
//  Created by Dave Dribin on 9/27/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DDBaseXInputBuffer : NSObject
{
    uint64_t _byteBuffer;
    unsigned _capacity;
    unsigned _length;
    unsigned _bitsPerGroup;
    unsigned _numberOfGroups;
    uint8_t _groupBitMask;
}

+ (id)base64InputBuffer;

- (id)initWithCapacity:(unsigned)capacity bitsPerGroup:(unsigned)bitsPerGroup;

- (unsigned)length;

- (unsigned)numberOfGroups;

- (unsigned)numberOfFilledGroups;

- (BOOL)isFull;

- (void)addByte:(uint8_t)byte;

- (void)reset;

- (uint8_t)valueAtGroupIndex:(unsigned)groupIndex;

@end
