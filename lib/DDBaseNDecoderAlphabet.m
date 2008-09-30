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

#import "DDBaseNDecoderAlphabet.h"


@interface DDBaseNDecoderAlphabet ()

- (void)setupDecodeTable:(const char *)stringTable length:(unsigned)tableLength;

@end


@implementation DDBaseNDecoderAlphabet

+ (id)alphabetWithCStringTable:(const char *)stringTable;
{
    id o = [[self alloc] initWithCStringTable:stringTable];
    return [o autorelease];
}

- (id)initWithCStringTable:(const char *)stringTable;
{
    unsigned tableLength = strlen(stringTable);
    NSAssert(tableLength <= DDBaseNDecoderAlphabetMaxTableSize,
             @"String is too big for decode table");
    
    self = [super init];
    if (self == nil)
        return nil;
    
    unsigned int i;
    for (i = 0; i < DDBaseNDecoderAlphabetMaxTableSize; i++)
    {
        _decodeTable[i] = NSNotFound;
    }
    
    [self setupDecodeTable:stringTable length:tableLength];
    
    return self;
}

- (void)setupDecodeTable:(const char *)stringTable length:(unsigned)tableLength;
{
    unsigned int i;
    for (i = 0; i < tableLength; i++)
    {
        unsigned decodedVale = stringTable[i];
        _decodeTable[decodedVale] = i;
    }
}

- (unsigned)decodeValue:(uint8_t)value;
{
    unsigned index = (unsigned)value;
    if (index >= sizeof(_decodeTable))
        return NSNotFound;
    
    return _decodeTable[index];
}

@end
