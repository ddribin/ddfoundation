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
#import "DDBaseNEncoder.h"
#import "DDBaseNInputBuffer.h"

enum
{
    DDBase32EncoderAlphabetRfc,
    DDBase32EncoderAlphabetCrockford,
    DDBase32EncoderAlphabetZBase32,
};
typedef unsigned DDBase32EncoderAlphabet;

@interface DDBase32Encoder : DDBaseNEncoder
{
}

+ (NSString *)base32EncodeData:(NSData *)data;

+ (NSString *)crockfordBase32EncodeData:(NSData *)data;

+ (NSString *)zbase32EncodeData:(NSData *)data;

+ (NSString *)base32EncodeData:(NSData *)data
                       options:(DDBaseEncoderOptions)options;

+ (NSString *)base32EncodeData:(NSData *)data
                       options:(DDBaseEncoderOptions)options
                      alphabet:(DDBase32EncoderAlphabet)alphabet;

+ (id)base32EncoderWithOptions:(DDBaseEncoderOptions)options
                      alphabet:(DDBase32EncoderAlphabet)alphabet;

- (id)initWithOptions:(DDBaseEncoderOptions)options
             alphabet:(DDBase32EncoderAlphabet)alphabet;


@end


@interface DDBaseNInputBuffer (DDBase32Encoder)

+ (id)base32InputBuffer;

@end
