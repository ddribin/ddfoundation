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

#import "DDBaseNDecoder.h"
#import "DDBaseNInputBuffer.h"
#import "DDBaseNDecoderAlphabet.h";


@interface DDBaseNDecoder ()

- (void)decodeAllBytes;
- (void)decodeFilledBytes;
- (void)decodeNumberOfBytes:(unsigned)numberOfBytes;
- (int)lookupCharacter:(char)character;

@end

@implementation DDBaseNDecoder

- (id)initWithInputBuffer:(DDBaseNInputBuffer *)inputBuffer
                 alphabet:(DDBaseNDecoderAlphabet *)alphabet;
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _inputBuffer = [inputBuffer retain];
    _outputBuffer = [[NSMutableData alloc] init];
    _alphabet = [alphabet retain];
    
    return self;
}

- (void)dealloc
{
    [_alphabet release];
    [_outputBuffer release];
    [_inputBuffer release];
    [super dealloc];
}

- (NSData *)decodeStringAndFinish:(NSString *)string;
{
    [self decodeString:string];
    return [self finishDecoding];
}

- (void)decodeString:(NSString *)string;
{
    unsigned stringLength = [string length];
    unsigned i;
    for (i = 0; i < stringLength; i++)
    {
        [self decodeCharacter:[string characterAtIndex:i]];
    }
}

- (void)decodeCharacter:(unichar)character;
{
    NSAssert(character <= 127, @"Only ASCII characters allowed in base-N string");

    unsigned decodedValue = [self lookupCharacter:character];
    if (decodedValue == NSNotFound)
        return;
    
    [_inputBuffer appendGroupValue:decodedValue];
    if ([_inputBuffer isFull])
    {
        [self decodeAllBytes];
        [_inputBuffer reset];
    }
}

- (void)decodeAllBytes;
{
    [self decodeNumberOfBytes:[_inputBuffer numberOfBytes]];
}

- (void)decodeNumberOfBytes:(unsigned)numberOfBytes;
{
    unsigned byteIndex = 0;
    for (byteIndex = 0; byteIndex < numberOfBytes; byteIndex++)
    {
        uint8_t byteValue = [_inputBuffer valueAtByteIndex:byteIndex];;
        [_outputBuffer appendBytes:&byteValue length:1];
    }
}

- (NSData *)finishDecoding;
{
    [self decodeFilledBytes];
    
    NSData * result = [[_outputBuffer retain] autorelease];
    [_outputBuffer release];
    _outputBuffer = [[NSMutableData alloc] init];
    
    return result;
}

- (void)decodeFilledBytes;
{
    unsigned numberOfFilledBytes = [_inputBuffer numberOfFilledBytes];
    if (numberOfFilledBytes > 0)
    {
        [self decodeNumberOfBytes:numberOfFilledBytes];
    }
}

- (int)lookupCharacter:(char)character;
{
    return [_alphabet decodeValue:character];
}

@end
