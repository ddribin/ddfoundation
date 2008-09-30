//
//  DDBaseNAlphabet.h
//  DDFoundation
//
//  Created by Dave Dribin on 9/30/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DDBaseNDecoderAlphabetMaxTableSize 128

@interface DDBaseNDecoderAlphabet : NSObject
{
    unsigned _decodeTable[DDBaseNDecoderAlphabetMaxTableSize];
}

+ (id)alphabetWithCStringTable:(const char *)stringTable;

- (id)initWithCStringTable:(const char *)stringTable;

- (unsigned)decodeValue:(uint8_t)value;

@end
