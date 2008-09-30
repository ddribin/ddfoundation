//
//  DDBase32Decoder.m
//  DDFoundation
//
//  Created by Dave Dribin on 9/29/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import "DDBase32Decoder.h"
#import "DDBase32Encoder.h"
#import "DDBaseNDecoderAlphabet.h"


static const char kBase32Rfc4648Alphabet[] =   "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
static const char kBase32CrockfordAlphabet[] = "0123456789ABCDEFGHJKMNPQRSTVWXYZ";

@interface DDBase32DecoderCrockfordAlphabet : DDBaseNDecoderAlphabet

+ (id)crockfordAlphabet;

@end

@implementation DDBase32Decoder

+ (NSData *)base32DecodeString:(NSString *)string;
{
    DDBase32Decoder * decoder = [self base32DecoderWithAlphabet:DDBase32EncoderAlphabetRfc];
    return [decoder decodeStringAndFinish:string];
}

+ (NSData *)crockfordBase32DecodeString:(NSString *)string;
{
    DDBase32Decoder * decoder = [self base32DecoderWithAlphabet:DDBase32EncoderAlphabetCrockford];
    return [decoder decodeStringAndFinish:string];
}

+ (id)base32DecoderWithAlphabet:(DDBase32EncoderAlphabet)alphabet;
{
    id o = [[self alloc] initWithAlphabet:alphabet];
    return [o autorelease];
}

- (id)initWithAlphabet:(DDBase32EncoderAlphabet)alphabetType;
{
    DDBaseNInputBuffer * inputBuffer = [DDBaseNInputBuffer base32InputBuffer];
    
    DDBaseNDecoderAlphabet * alphabet;
    if (alphabetType == DDBase32EncoderAlphabetCrockford)
        alphabet = [DDBase32DecoderCrockfordAlphabet crockfordAlphabet];
    else
        alphabet = [DDBaseNDecoderAlphabet alphabetWithCStringTable:kBase32Rfc4648Alphabet];
    
    self = [super initWithInputBuffer:inputBuffer
                             alphabet:alphabet];
    return self;
}

@end

@implementation DDBase32DecoderCrockfordAlphabet

+ (id)crockfordAlphabet;
{
    return [self alphabetWithCStringTable:kBase32CrockfordAlphabet];
}

- (void)setupDecodeTable:(const char *)stringTable length:(unsigned)tableLength;
{
    unsigned int i;
    for (i = 0; i < tableLength; i++)
    {
        unsigned decodedValue = stringTable[i];
        _decodeTable[decodedValue] = i;

        decodedValue = tolower(stringTable[i]);
        _decodeTable[decodedValue] = i;
    }
    
    _decodeTable['O'] = _decodeTable['o'] = _decodeTable['0'];
    
    _decodeTable['I'] = _decodeTable['i'] = _decodeTable['1'];
    _decodeTable['L'] = _decodeTable['l'] = _decodeTable['1'];
}


@end
