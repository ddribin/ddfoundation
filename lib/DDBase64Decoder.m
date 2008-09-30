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
    self = [super initWithInputBuffer:inputBuffer
                             alphabet:kBase64Rfc4648Alphabet
                       alphabetLength:sizeof(kBase64Rfc4648Alphabet)];
    return self;
}

@end
