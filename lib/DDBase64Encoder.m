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

#import "DDBase64Encoder.h"
#import "DDBaseNInputBuffer.h"

static const char kBase64Rfc4648Alphabet[] =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation DDBase64Encoder

+ (NSString *)base64EncodeData:(NSData *)data;
{
    DDBaseNEncoder * encoder = [self base64EncoderWithOptions:0];
    return [encoder encodeDataAndFinish:data];
}

+ (NSString *)base64EncodeData:(NSData *)data options:(DDBaseEncoderOptions)options;
{
    DDBaseNEncoder * encoder = [self base64EncoderWithOptions:options];
    return [encoder encodeDataAndFinish:data];
}

+ (id)base64EncoderWithOptions:(DDBaseEncoderOptions)options;
{
    DDBaseNEncoder * encoder = [[self alloc] initWithOptions:options];
    return [encoder autorelease];
}

- (id)initWithOptions:(DDBaseEncoderOptions)options;
{
    return [super initWithOptions:options
                      inputBuffer:[DDBaseNInputBuffer base64InputBuffer]
                         alphabet:kBase64Rfc4648Alphabet];
}

@end


@implementation DDBaseNInputBuffer (DDBase64Encoder)

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
    id inputBuffer = [[self alloc] initWithCapacityInBits:24 bitsPerGroup:6];
    return [inputBuffer autorelease];
}

@end
