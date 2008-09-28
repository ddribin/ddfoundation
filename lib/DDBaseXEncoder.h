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

#import <Foundation/Foundation.h>

enum {
    DDBaseEncoderOptionNoPadding = 0x01,
    DDBaseEncoderOptionAddLineBreaks = 0x02,
};
typedef unsigned DDBaseEncoderOptions;

enum
{
    DDBase32EncoderAlphabetRfc,
    DDBase32EncoderAlphabetCrockford,
    DDBase32EncoderAlphabetZBase32,
};
typedef unsigned DDBase32EncoderAlphabet;

@class DDBaseXInputBuffer;
@class DDBaseXOutputBuffer;


@interface DDBaseXEncoder : NSObject
{
  @protected
    int _byteIndex;
    DDBaseXInputBuffer * _inputBuffer;
    DDBaseXOutputBuffer * _outputBuffer;
    const char * _alphabet;
}

#pragma mark -
#pragma mark Base64 Convenience Methods

+ (NSString *)base64EncodeData:(NSData *)data;

+ (NSString *)base64EncodeData:(NSData *)data options:(DDBaseEncoderOptions)options;

+ (id)base64EncoderWithOptions:(DDBaseEncoderOptions)options;

#pragma mark -
#pragma mark Base32 Convenience Methods

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

#pragma mark -

- (void)reset;

- (void)encodeByte:(uint8_t)byte;

- (void)encodeData:(NSData *)data;

- (NSString *)finishEncoding;

- (NSString *)encodeDataAndFinish:(NSData *)data;

@end
