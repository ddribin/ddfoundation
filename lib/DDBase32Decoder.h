//
//  DDBase32Decoder.h
//  DDFoundation
//
//  Created by Dave Dribin on 9/29/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDBase32Encoder.h"

@interface DDBase32Decoder : NSObject
{
    DDBaseNInputBuffer * _inputBuffer;
    NSMutableData * _outputBuffer;
}

+ (NSData *)base32DecodeString:(NSString *)string;

+ (id)base32Decoder;

- (id)init;

- (NSData *)decodeStringAndFinish:(NSString *)string;

- (void)decodeString:(NSString *)string;

- (void)decodeCharacter:(unichar)character;

- (NSData *)finishDecoding;

@end
