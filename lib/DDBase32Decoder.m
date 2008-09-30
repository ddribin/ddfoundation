//
//  DDBase32Decoder.m
//  DDFoundation
//
//  Created by Dave Dribin on 9/29/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import "DDBase32Decoder.h"


static const char kBase32Rfc4648Alphabet[] =   "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";

@interface DDBase32Decoder ()

- (int)lookupCharacter:(char)character;

@end

@implementation DDBase32Decoder

+ (NSData *)base32DecodeString:(NSString *)string;
{
    DDBase32Decoder * decoder = [self base32Decoder];
    return [decoder decodeStringAndFinish:string];
}

+ (id)base32Decoder;
{
    id o = [[self alloc] init];
    return [o autorelease];
}

- (id)init;
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _inputBuffer = [[DDBaseNInputBuffer base32InputBuffer] retain];
    _outputBuffer = [[NSMutableData alloc] init];
    
    return self;
}

- (void)dealloc
{
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
    int decodedValue = [self lookupCharacter:character];
    if (decodedValue < 0)
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
    unsigned value;
    for (value = 0; value < sizeof(kBase32Rfc4648Alphabet); value++)
    {
        if (character == kBase32Rfc4648Alphabet[value])
            return value;
    }
    return -1;
}

@end
