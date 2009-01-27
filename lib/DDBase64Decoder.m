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

#import "DDBase64Decoder.h"
#import "DDBase64Encoder.h"
#import "DDBaseNDecoderAlphabet.h"


static const char kBase64Rfc4648Alphabet[] =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation DDBase64Decoder

+ (NSData *)base64DecodeString:(NSString *)base64;
{
    DDBase64Decoder * decoder = [self base64Decoder];
    return [decoder decodeStringAndFinish:base64];
}

+ (id)base64Decoder;
{
    id object =[[self alloc] init];
    return [object autorelease];
}

- (id)init;
{
    DDBaseNInputBuffer * inputBuffer = [DDBaseNInputBuffer base64InputBuffer];
    DDBaseNDecoderAlphabet * alphabet = [DDBaseNDecoderAlphabet alphabetWithCStringTable:kBase64Rfc4648Alphabet];
    self = [super initWithInputBuffer:inputBuffer
                             alphabet:alphabet];
    return self;
}

@end
