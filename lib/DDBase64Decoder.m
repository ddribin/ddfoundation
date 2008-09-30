//
//  DDBase64Decoder.m
//  DDFoundation
//
//  Created by Dave Dribin on 9/29/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import "DDBase64Decoder.h"
#import "DDBase64Encoder.h"


static const char kBase64Rfc4648Alphabet[] =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@interface DDBase64Decoder ()

- (int)lookupCharacter:(char)character;

@end

@implementation DDBase64Decoder

+ (NSData *)base64DecodeString:(NSString *)base64;
{
    DDBase64Decoder * decoder = [self base64Decoder];
    return [decoder decodeStringAndFinish:base64];
}

+ (id)base64Decoder;
{
    id object =[[self alloc] init];
    return [object autorelease];
}

- (id)init;
{
    DDBaseNInputBuffer * inputBuffer = [DDBaseNInputBuffer base64InputBuffer];
    self = [super initWithInputBuffer:inputBuffer];
    return self;
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
    NSAssert(character <= 127, @"Only ASCII characters allowed in base64 string");
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
    for (value = 0; value < sizeof(kBase64Rfc4648Alphabet); value++)
    {
        if (character == kBase64Rfc4648Alphabet[value])
            return value;
    }
    return -1;
}

@end
