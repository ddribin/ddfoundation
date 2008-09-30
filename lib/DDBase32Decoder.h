//
//  DDBase32Decoder.h
//  DDFoundation
//
//  Created by Dave Dribin on 9/29/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDBaseNDecoder.h"
#import "DDBase32Encoder.h"

@interface DDBase32Decoder : DDBaseNDecoder
{
}

+ (NSData *)base32DecodeString:(NSString *)string;
+ (NSData *)crockfordBase32DecodeString:(NSString *)string;

+ (id)base32DecoderWithAlphabet:(DDBase32EncoderAlphabet)alphabet;

- (id)initWithAlphabet:(DDBase32EncoderAlphabet)alphabet;

@end
