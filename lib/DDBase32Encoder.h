//
//  DDBase32Encoder.h
//  DDFoundation
//
//  Created by Dave Dribin on 9/23/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <Foundation/Foundation.h>
#import "DDAbstractBaseEncoder.h"

enum
{
    DDBase32EncoderAlphabetRfc,
    DDBase32EncoderAlphabetCrockford,
    DDBase32EncoderAlphabetZBase32,
};

typedef unsigned DDBase32EncoderAlphabet;

@interface DDBase32Encoder : DDAbstractBaseEncoder
{
    // A 40-bit buffer. Holds 5 bytes and 8 5-bit groups.
    uint64_t _buffer;
    const char * _encodeTable;
}

+ (NSString *)crockfordEncodeData:(NSData *)data;
+ (NSString *)zbase32EncodeData:(NSData *)data;

+ (NSString *)encodeData:(NSData *)data
                alphabet:(DDBase32EncoderAlphabet)alphabet;

- (id)initWithOptions:(DDBaseEncoderOptions)options
             alphabet:(DDBase32EncoderAlphabet)alphabet;

@end
