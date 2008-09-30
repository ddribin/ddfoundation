//
//  DDBaseNDecoder.m
//  DDFoundation
//
//  Created by Dave Dribin on 9/29/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import "DDBaseNDecoder.h"
#import "DDBaseNInputBuffer.h"
#import "DDBaseNDecoderAlphabet.h";


@interface DDBaseNDecoder ()

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
    NSAssert(character <= 127, @"Only ASCII characters allowed in base32 string");
    unsigned decodedValue = [self lookupCharacter:character];
    NSLog(@"Decode %C to %u %u %d", character, decodedValue, NSNotFound, NSNotFound);
    if (decodedValue == NSNotFound)
    {
        return;
    }
    
    [_inputBuffer appendGroupValue:decodedValue];
    if ([_inputBuffer isFull])
    {
        unsigned byteIndex = 0;
        for (byteIndex = 0; byteIndex < [_inputBuffer numberOfBytes]; byteIndex++)
        {
            uint8_t byteValue = [_inputBuffer valueAtByteIndex:byteIndex];;
            [_outputBuffer appendBytes:&byteValue length:1];
        }
        [_inputBuffer reset];
    }
}

- (NSData *)finishDecoding;
{
    unsigned numberOfFilledBytes = [_inputBuffer numberOfFilledBytes];
    if (numberOfFilledBytes > 0)
    {
        unsigned byteIndex = 0;
        for (byteIndex = 0; byteIndex < numberOfFilledBytes; byteIndex++)
        {
            uint8_t byteValue = [_inputBuffer valueAtByteIndex:byteIndex];;
            [_outputBuffer appendBytes:&byteValue length:1];
        }
    }
    
    NSData * result = [[_outputBuffer retain] autorelease];
    [_outputBuffer release];
    _outputBuffer = [[NSMutableData alloc] init];
    
    return result;
}

- (int)lookupCharacter:(char)character;
{
    return [_alphabet decodeValue:character];
}

@end
