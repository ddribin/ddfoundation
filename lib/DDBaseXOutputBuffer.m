//
//  DDBaseXOutputBuffer.m
//  DDFoundation
//
//  Created by Dave Dribin on 9/28/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import "DDBaseXOutputBuffer.h"


@implementation DDBaseXOutputBuffer

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
