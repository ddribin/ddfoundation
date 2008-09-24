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
- (void)advanceByteIndex;

@end

static const int kMaxByteIndex = 4;
static const int kMaxGroupIndex = 7;

static const char kRfc4648EncodingTable[] =   "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
static const char kCrockfordEncodingTable[] = "0123456789ABCDEFGHJKMNPQRSTVWXYZ";

@implementation DDBase32Encoder

+ (NSString *)crockfordEncodeData:(NSData *)data;
{
    DDAbstractBaseEncoder * encoder = [[self alloc] initWithOptions:DDBaseEncoderOptionNoPadding
                                                  useCrockfordTable:YES];
    [encoder autorelease];
    [encoder encodeData:data];
    return [encoder finishEncoding];
}

- (id)initWithOptions:(DDBaseEncoderOptions)options
{
    return [self initWithOptions:options useCrockfordTable:NO];
}

- (id)initWithOptions:(DDBaseEncoderOptions)options
    useCrockfordTable:(BOOL)useCrockfordTable;
{
    self = [super initWithOptions:options];
    if (self == nil)
        return nil;
    
    if (useCrockfordTable)
        _encodeTable = kCrockfordEncodingTable;
    else
        _encodeTable = kRfc4648EncodingTable;
    
    return self;
}

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

typedef struct
{
    int encodeGroup1;
    int encodeGroup2;
    int finishGroup;
    int padBytes;
} DDBase32EncoderEntry;

#define X -1
static DDBase32EncoderEntry kBase32EncoderTable[] = {
//   E1 E2 F  P
    {0, X, X, X},    // byteIndex = 0
    {1, 2, 1, 6},    // byteIndex = 1
    {3, X, 3, 4},    // byteIndex = 2
    {4, 5, 4, 3},    // byteIndex = 3
    {6, 7, 6, 1},    // byteIndex = 4
};
#undef X

- (void)encodeByte:(uint8_t)byte
{
    [self addByteToBuffer:byte];

    DDBase32EncoderEntry * entry = &kBase32EncoderTable[_byteIndex];
    [self encodeGroup:entry->encodeGroup1];
    [self encodeGroup:entry->encodeGroup2];

    [self advanceByteIndex];
}

- (NSString *)finishEncoding;
{
    DDBase32EncoderEntry * entry = &kBase32EncoderTable[_byteIndex];
    [self encodeGroup:entry->finishGroup];
    [self appendPadCharacters:entry->padBytes];
    
    NSString * output = [[_output retain] autorelease];
    [self reset];
    return output;
}

- (void)addByteToBuffer:(uint8_t)byte;
{
    int bitsToShift = (kMaxByteIndex - _byteIndex) * 8;
    _buffer |= (((uint64_t)byte) << bitsToShift);
}

- (void)encodeGroup:(int)group
{
    if (group == -1)
        return;
    
    unsigned bitsToShift = (kMaxGroupIndex - group) * 5;
    uint8_t value = (_buffer >> bitsToShift) & 0x1F;
    [self appendCharacter:_encodeTable[value]];
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
