//
//  DDBaseNAlphabet.m
//  DDFoundation
//
//  Created by Dave Dribin on 9/30/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

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
