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

#import "DDBaseNEncoder.h"
#import "DDBaseNInputBuffer.h"
#import "DDBaseNOutputBuffer.h"

static const char kBase64Rfc4648Alphabet[] =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@interface DDBaseNEncoder ()

- (void)encodeValueAtGroupIndex:(int)group;
- (void)encodeNumberOfGroups:(int)group;

@end

@implementation DDBaseNEncoder

- (id)init;
{
    return nil;
}

- (id)initWithOptions:(DDBaseEncoderOptions)options
          inputBuffer:(DDBaseNInputBuffer *)inputBuffer
             alphabet:(const char *)alphabet;
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _inputBuffer = [inputBuffer retain];
    
    BOOL addPadding = ((options & DDBaseEncoderOptionNoPadding) == 0);
    BOOL addLineBreaks = ((options & DDBaseEncoderOptionAddLineBreaks) != 0);
    _outputBuffer = [[DDBaseNOutputBuffer alloc] initWithAddPadding:addPadding
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
