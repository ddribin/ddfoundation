//
//  DDBase32Decoder.m
//  DDFoundation
//
//  Created by Dave Dribin on 9/29/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import "DDBase32Decoder.h"
#import "DDBase32Encoder.h"


static const char kBase32Rfc4648Alphabet[] =   "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
static const char kBase32CrockfordAlphabet[] = "0123456789ABCDEFGHJKMNPQRSTVWXYZ";

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


- (id)initWithAlphabet:(DDBase32EncoderAlphabet)alphabet;
{
    DDBaseNInputBuffer * inputBuffer = [DDBaseNInputBuffer base32InputBuffer];
    
    const char * alphabetTable;
    if (alphabet == DDBase32EncoderAlphabetCrockford)
        alphabetTable = kBase32CrockfordAlphabet;
    else
        alphabetTable = kBase32Rfc4648Alphabet;
    
    self = [super initWithInputBuffer:inputBuffer
                             alphabet:alphabetTable
                       alphabetLength:sizeof(kBase32Rfc4648Alphabet)];
    return self;
}

@end
