//
//  DDBase32Encoder.h
//  DDFoundation
//
//  Created by Dave Dribin on 9/28/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDBaseXEncoder.h"
#import "DDBaseXInputBuffer.h"

enum
{
    DDBase32EncoderAlphabetRfc,
    DDBase32EncoderAlphabetCrockford,
    DDBase32EncoderAlphabetZBase32,
};
typedef unsigned DDBase32EncoderAlphabet;

@interface DDBase32Encoder : DDBaseXEncoder
{
}

+ (NSString *)base32EncodeData:(NSData *)data;

+ (NSString *)crockfordBase32EncodeData:(NSData *)data;

+ (NSString *)zbase32EncodeData:(NSData *)data;

+ (NSString *)base32EncodeData:(NSData *)data
                       options:(DDBaseEncoderOptions)options;

+ (NSString *)base32EncodeData:(NSData *)data
                       options:(DDBaseEncoderOptions)options
                      alphabet:(DDBase32EncoderAlphabet)alphabet;

+ (id)base32EncoderWithOptions:(DDBaseEncoderOptions)options
                      alphabet:(DDBase32EncoderAlphabet)alphabet;

- (id)initWithOptions:(DDBaseEncoderOptions)options
             alphabet:(DDBase32EncoderAlphabet)alphabet;


@end


@interface DDBaseXInputBuffer (DDBase32Encoder)

+ (id)base32InputBuffer;

@end
