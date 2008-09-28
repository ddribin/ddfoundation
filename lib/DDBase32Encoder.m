//
//  DDBase32Encoder.m
//  DDFoundation
//
//  Created by Dave Dribin on 9/23/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import "DDBase32Encoder.h"
#import "DDBaseXOutputBuffer.h"

@interface DDBase32Encoder ()

- (void)addByteToBuffer:(uint8_t)byte;
- (void)encodeUpToAndIncludingGroup:(int)group;
- (void)encodeGroup:(int)group;
- (void)advanceByteIndex;

@end

static const int kMaxByteIndex = 4;
static const int kMaxGroupIndex = 7;

static const char kRfc4648EncodingTable[] =   "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
static const char kCrockfordEncodingTable[] = "0123456789ABCDEFGHJKMNPQRSTVWXYZ";
static const char kZBase32EncodingTable[] =   "YBNDRFG8EJKMCPQXOT1UWISZA345H769";

@implementation DDBase32Encoder

+ (NSString *)crockfordEncodeData:(NSData *)data;
{
    DDAbstractBaseEncoder * encoder =
        [[self alloc] initWithOptions:DDBaseEncoderOptionNoPadding
                             alphabet:DDBase32EncoderAlphabetCrockford];
    [encoder autorelease];
    [encoder encodeData:data];
    return [encoder finishEncoding];
}

+ (NSString *)zbase32EncodeData:(NSData *)data;
{
    DDAbstractBaseEncoder * encoder =
        [[self alloc] initWithOptions:DDBaseEncoderOptionNoPadding
                             alphabet:DDBase32EncoderAlphabetZBase32];
    [encoder autorelease];
    [encoder encodeData:data];
    return [encoder finishEncoding];
}

+ (NSString *)encodeData:(NSData *)data
                alphabet:(DDBase32EncoderAlphabet)alphabet;
{
    DDAbstractBaseEncoder * encoder = [[self alloc] initWithOptions:DDBaseEncoderOptionNoPadding
                                                           alphabet:alphabet];
    [encoder autorelease];
    [encoder encodeData:data];
    return [encoder finishEncoding];
}

- (id)initWithOptions:(DDBaseEncoderOptions)options
{
    return [self initWithOptions:options alphabet:DDBase32EncoderAlphabetRfc];
}

- (id)initWithOptions:(DDBaseEncoderOptions)options
             alphabet:(DDBase32EncoderAlphabet)alphabet;
{
    self = [super initWithOptions:options];
    if (self == nil)
        return nil;
    
    if (alphabet == DDBase32EncoderAlphabetCrockford)
        _encodeTable = kCrockfordEncodingTable;
    else if (alphabet == DDBase32EncoderAlphabetZBase32)
        _encodeTable = kZBase32EncodingTable;
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

- (void)encodeByte:(uint8_t)byte
{
    [self addByteToBuffer:byte];

    BOOL bufferIsFull = (_byteIndex == kMaxByteIndex);
    if (bufferIsFull)
        [self encodeUpToAndIncludingGroup:kMaxGroupIndex];

    [self advanceByteIndex];
}

- (NSString *)finishEncoding;
{
    if (_byteIndex == 1)
    {
        [self encodeUpToAndIncludingGroup:1];
        [_outputBuffer appendPadCharacters:6];
    }
    else if (_byteIndex == 2)
    {
        [self encodeUpToAndIncludingGroup:3];
        [_outputBuffer appendPadCharacters:4];
    }
    else if (_byteIndex == 3)
    {
        [self encodeUpToAndIncludingGroup:4];
        [_outputBuffer appendPadCharacters:3];
    }
    else if (_byteIndex == 4)
    {
        [self encodeUpToAndIncludingGroup:6];
        [_outputBuffer appendPadCharacters:1];
    }
    
    NSString * output = [_outputBuffer finalStringAndReset];
    return output;
}

- (void)addByteToBuffer:(uint8_t)byte;
{
    int bitsToShift = (kMaxByteIndex - _byteIndex) * 8;
    _buffer |= (((uint64_t)byte) << bitsToShift);
}

- (void)encodeUpToAndIncludingGroup:(int)group;
{
    int i;
    for (i = 0; i <= group; i++)
    {
        [self encodeGroup:i];
    }
}

- (void)encodeGroup:(int)group
{
    if (group == -1)
        return;
    
    unsigned bitsToShift = (kMaxGroupIndex - group) * 5;
    uint8_t value = (_buffer >> bitsToShift) & 0x1F;
    [_outputBuffer appendCharacter:_encodeTable[value]];
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
