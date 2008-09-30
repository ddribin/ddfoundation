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
    DDBaseNInputBuffer * inputBuffer = [DDBaseNInputBuffer base32InputBuffer];
    self = [super initWithInputBuffer:inputBuffer
                             alphabet:kBase32Rfc4648Alphabet
                       alphabetLength:sizeof(kBase32Rfc4648Alphabet)];
    return self;
}

@end
