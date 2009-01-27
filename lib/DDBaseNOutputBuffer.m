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

#import "DDBaseNOutputBuffer.h"


@implementation DDBaseNOutputBuffer

- (id)initWithAddPadding:(BOOL)addPadding addLineBreaks:(BOOL)addLineBreaks;
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _addPadding = addPadding;
    _addLineBreaks = addLineBreaks;
    [self reset];
    
    return self;
}

- (void)dealloc
{
    [_output release];
    [super dealloc];
}

- (void)reset;
{
    [_output release];
    _output = [[NSMutableString alloc ]init];
    _currentLineLength = 0;
}

- (NSString *)finalStringAndReset
{
    NSString * finalString = [[_output retain] autorelease];
    [self reset];
    return finalString;
}

- (void)appendPadCharacters:(int)count;
{
    if (!_addPadding)
        return;
    
    int i;
    for (i = 0; i < count; i++)
    {
        [self appendCharacter:'='];
    }
}

- (void)appendCharacter:(char)ch;
{
    [_output appendFormat:@"%c", ch];
    _currentLineLength++;
    if (_addLineBreaks && (_currentLineLength >= 64))
    {
        [_output appendString:@"\n"];
        _currentLineLength = 0;
    }
}

@end
