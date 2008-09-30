//
//  DDBase64Decoder.h
//  DDFoundation
//
//  Created by Dave Dribin on 9/29/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDBase64Encoder.h"


@interface DDBase64Decoder : NSObject
{
    DDBaseNInputBuffer * _inputBuffer;
    NSMutableData * _outputBuffer;
}

+ (NSData *)base64DecodeString:(NSString *)base64;

+ (id)base64Decoder;

- (id)init;

- (NSData *)decodeStringAndFinish:(NSString *)data;

- (void)decodeString:(NSString *)string;

- (void)decodeCharacter:(unichar)character;

- (NSData *)finishDecoding;

@end
