//
//  DDBaseXOutputBuffer.h
//  DDFoundation
//
//  Created by Dave Dribin on 9/28/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DDBaseXOutputBuffer : NSObject
{
    NSMutableString * _output;
    BOOL _addPadding;
    BOOL _addLineBreaks;
    unsigned _currentLineLength;
}

- (id)initWithAddPadding:(BOOL)addPadding addLineBreaks:(BOOL)addLineBreaks;

- (void)reset;

- (void)appendCharacter:(char)ch;
- (void)appendPadCharacters:(int)count;
- (NSString *)finalStringAndReset;

@end
