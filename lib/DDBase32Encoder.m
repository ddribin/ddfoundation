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

#import "DDBase32Encoder.h"
#import "DDBaseXInputBuffer.h"

static const char kBase32Rfc4648Alphabet[] =   "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
static const char kBase32CrockfordAlphabet[] = "0123456789ABCDEFGHJKMNPQRSTVWXYZ";
static const char kBase32ZBase32Alphabet[] =   "YBNDRFG8EJKMCPQXOT1UWISZA345H769";

@implementation DDBase32Encoder

+ (NSString *)base32EncodeData:(NSData *)data;
{
    return [self base32EncodeData:data options:0 alphabet:DDBase32EncoderAlphabetRfc];
}

+ (NSString *)crockfordBase32EncodeData:(NSData *)data;
{
    return [self base32EncodeData:data options:DDBaseEncoderOptionNoPadding alphabet:DDBase32EncoderAlphabetCrockford];
}

+ (NSString *)zbase32EncodeData:(NSData *)data;
{
    return [self base32EncodeData:data options:DDBaseEncoderOptionNoPadding alphabet:DDBase32EncoderAlphabetZBase32];
}

+ (NSString *)base32EncodeData:(NSData *)data
                       options:(DDBaseEncoderOptions)options;
{
    return [self base32EncodeData:data options:options alphabet:DDBase32EncoderAlphabetRfc];
}

+ (NSString *)base32EncodeData:(NSData *)data
                       options:(DDBaseEncoderOptions)options
                      alphabet:(DDBase32EncoderAlphabet)alphabet;
{
    DDBaseXEncoder * encoder = [self base32EncoderWithOptions:options
                                                     alphabet:alphabet];
    return [encoder encodeDataAndFinish:data];
}

+ (id)base32EncoderWithOptions:(DDBaseEncoderOptions)options
                      alphabet:(DDBase32EncoderAlphabet)alphabet;
{
    DDBaseXEncoder * encoder = [[self alloc] initWithOptions:options alphabet:alphabet];
    return [encoder autorelease];
}

- (id)initWithOptions:(DDBaseEncoderOptions)options
             alphabet:(DDBase32EncoderAlphabet)alphabet;
{
    const char * alphabetTable;
    if (alphabet == DDBase32EncoderAlphabetCrockford)
        alphabetTable = kBase32CrockfordAlphabet;
    else if (alphabet == DDBase32EncoderAlphabetZBase32)
        alphabetTable = kBase32ZBase32Alphabet;
    else
        alphabetTable = kBase32Rfc4648Alphabet;
    
    return [super initWithOptions:options
                      inputBuffer:[DDBaseXInputBuffer base32InputBuffer]
                         alphabet:alphabetTable];
}

@end


@implementation DDBaseXInputBuffer (DDBase32Encoder)

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

+ (id)base32InputBuffer;
{
    id inputBuffer = [[self alloc] initWithCapacityInBits:40 bitsPerGroup:5];
    return [inputBuffer autorelease];
}

@end
