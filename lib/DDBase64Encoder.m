//
//  DDBase64Encoder.m
//  DDFoundation
//
//  Created by Dave Dribin on 9/28/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import "DDBase64Encoder.h"
#import "DDBaseXInputBuffer.h"

static const char kBase64Rfc4648Alphabet[] =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation DDBase64Encoder

+ (NSString *)base64EncodeData:(NSData *)data;
{
    DDBaseXEncoder * encoder = [self base64EncoderWithOptions:0];
    return [encoder encodeDataAndFinish:data];
}

+ (NSString *)base64EncodeData:(NSData *)data options:(DDBaseEncoderOptions)options;
{
    DDBaseXEncoder * encoder = [self base64EncoderWithOptions:options];
    return [encoder encodeDataAndFinish:data];
}

+ (id)base64EncoderWithOptions:(DDBaseEncoderOptions)options;
{
    DDBaseXEncoder * encoder = [[self alloc] initWithOptions:options];
    return [encoder autorelease];
}

- (id)initWithOptions:(DDBaseEncoderOptions)options;
{
    return [super initWithOptions:options
                      inputBuffer:[DDBaseXInputBuffer base64InputBuffer]
                         alphabet:kBase64Rfc4648Alphabet];
}

@end


@implementation DDBaseXInputBuffer (DDBase64Encoder)

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

@end
