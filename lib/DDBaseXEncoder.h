//
//  DDAbstractBaseEncoder.h
//  DDFoundation
//
//  Created by Dave Dribin on 9/23/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    DDBaseEncoderOptionNoPadding = 0x01,
    DDBaseEncoderOptionAddLineBreaks = 0x02,
};
typedef unsigned DDBaseEncoderOptions;

enum
{
    DDBase32EncoderAlphabetRfc,
    DDBase32EncoderAlphabetCrockford,
    DDBase32EncoderAlphabetZBase32,
};
typedef unsigned DDBase32EncoderAlphabet;

@class DDBaseXInputBuffer;
@class DDBaseXOutputBuffer;


@interface DDBaseXEncoder : NSObject
{
  @protected
    int _byteIndex;
    DDBaseXInputBuffer * _inputBuffer;
    DDBaseXOutputBuffer * _outputBuffer;
    const char * _alphabet;
}

#pragma mark -
#pragma mark Base64 Convenience Methods

+ (NSString *)base64EncodeData:(NSData *)data;

+ (NSString *)base64EncodeData:(NSData *)data options:(DDBaseEncoderOptions)options;

+ (id)base64EncoderWithOptions:(DDBaseEncoderOptions)options;

#pragma mark -
#pragma mark Base32 Convenience Methods

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

#pragma mark -

- (void)reset;

- (void)encodeByte:(uint8_t)byte;

- (void)encodeData:(NSData *)data;

- (NSString *)finishEncoding;

- (NSString *)encodeDataAndFinish:(NSData *)data;

@end
