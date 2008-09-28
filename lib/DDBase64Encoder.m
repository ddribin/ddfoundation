//
//  DDBase64Encoder.m
//  DDFoundation
//
//  Created by Dave Dribin on 9/23/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import "DDBase64Encoder.h"
#import "DDBaseXInputBuffer.h"
#import "DDBaseXOutputBuffer.h"

@interface DDBase64Encoder ()

- (void)encodeGroup:(int)group;
- (void)encodeNumberOfGroups:(int)group;

@end

static const int kMaxByteIndex = 2;
static const int kMaxGroupIndex = 3;

static const char kRfc4648EncodingTable[] =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation DDBase64Encoder

- (id)initWithOptions:(DDBaseEncoderOptions)options;
{
    DDBaseXInputBuffer * base64InputBuffer = [[DDBaseXInputBuffer alloc] initWithCapacity:3 bitsPerGroup:6];
    [base64InputBuffer autorelease];
    return [super initWithOptions:options inputBuffer:base64InputBuffer];
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
    [_inputBuffer addByte:byte];
    if ([_inputBuffer isFull])
    {
        [self encodeNumberOfGroups:[_inputBuffer numberOfGroups]];
        [_inputBuffer reset];
    }
}

- (NSString *)finishEncoding;
{
    unsigned numberOfFilledGroups = [_inputBuffer numberOfFilledGroups];
    [self encodeNumberOfGroups:numberOfFilledGroups];
    if (numberOfFilledGroups > 0)
        [_outputBuffer appendPadCharacters:[_inputBuffer numberOfGroups] - numberOfFilledGroups];
    
    NSString * output = [_outputBuffer finalStringAndReset];
    return output;
}

- (void)encodeNumberOfGroups:(int)group;
{
    int i;
    for (i = 0; i < group; i++)
    {
        [self encodeGroup:i];
    }
}

- (void)encodeGroup:(int)group
{
    uint8_t value = [_inputBuffer valueAtGroupIndex:group];
    [_outputBuffer appendCharacter:kRfc4648EncodingTable[value]];
}

@end
