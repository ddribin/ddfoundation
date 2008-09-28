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

#import "DDBaseXEncoder.h"
#import "DDBaseXInputBuffer.h"
#import "DDBaseXOutputBuffer.h"

static const char kBase64Rfc4648Alphabet[] =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

static const char kBase32Rfc4648Alphabet[] =   "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
static const char kBase32CrockfordAlphabet[] = "0123456789ABCDEFGHJKMNPQRSTVWXYZ";
static const char kBase32ZBase32Alphabet[] =   "YBNDRFG8EJKMCPQXOT1UWISZA345H769";

@interface DDBaseXEncoder ()

- (id)initWithOptions:(DDBaseEncoderOptions)options
          inputBuffer:(DDBaseXInputBuffer *)inputBuffer
             alphabet:(const char *)alphabet;
- (void)encodeValueAtGroupIndex:(int)group;
- (void)encodeNumberOfGroups:(int)group;

@end

@implementation DDBaseXEncoder

#pragma mark -
#pragma mark Base64 Convenience Methods

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
    DDBaseXEncoder * encoder = [[self alloc] initWithOptions:options
                                                        inputBuffer:[DDBaseXInputBuffer base64InputBuffer]
                                                           alphabet:kBase64Rfc4648Alphabet];
    return [encoder autorelease];
}

#pragma mark -
#pragma mark Base32 Convenience Methods

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
    const char * alphabetTable;
    if (alphabet == DDBase32EncoderAlphabetCrockford)
        alphabetTable = kBase32CrockfordAlphabet;
    else if (alphabet == DDBase32EncoderAlphabetZBase32)
        alphabetTable = kBase32ZBase32Alphabet;
    else
        alphabetTable = kBase32Rfc4648Alphabet;
    
    DDBaseXEncoder * encoder = [[self alloc] initWithOptions:options
                                                        inputBuffer:[DDBaseXInputBuffer base32InputBuffer]
                                                           alphabet:alphabetTable];
    return [encoder autorelease];
}

#pragma mark -

- (id)init;
{
    return [self initWithOptions:0
                     inputBuffer:[DDBaseXInputBuffer base64InputBuffer]
                        alphabet:kBase64Rfc4648Alphabet];
}

- (id)initWithOptions:(DDBaseEncoderOptions)options
          inputBuffer:(DDBaseXInputBuffer *)inputBuffer
             alphabet:(const char *)alphabet;
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _inputBuffer = [inputBuffer retain];
    
    BOOL addPadding = ((options & DDBaseEncoderOptionNoPadding) == 0);
    BOOL addLineBreaks = ((options & DDBaseEncoderOptionAddLineBreaks) != 0);
    _outputBuffer = [[DDBaseXOutputBuffer alloc] initWithAddPadding:addPadding
                                                      addLineBreaks:addLineBreaks];
    
    _alphabet = alphabet;
    
    [self reset];
    
    return self;
}

- (void)dealloc
{
    [_outputBuffer release];
    [_inputBuffer release];
    [super dealloc];
}

- (void)reset;
{
    [_inputBuffer reset];
    [_outputBuffer reset];
    _byteIndex = 0;
}

- (NSString *)encodeDataAndFinish:(NSData *)data;
{
    [self encodeData:data];
    return [self finishEncoding];
}

- (void)encodeData:(NSData *)data;
{
    const uint8_t * bytes = [data bytes];
    unsigned length = [data length];
    unsigned i;
    for (i = 0; i < length; i++)
    {
        [self encodeByte:bytes[i]];
    }
}

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
        [self encodeValueAtGroupIndex:i];
    }
}

- (void)encodeValueAtGroupIndex:(int)groupIndex
{
    uint8_t value = [_inputBuffer valueAtGroupIndex:groupIndex];
    [_outputBuffer appendCharacter:_alphabet[value]];
}

@end
