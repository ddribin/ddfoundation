//
//  DDBaseNDecoder.h
//  DDFoundation
//
//  Created by Dave Dribin on 9/29/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>


@class DDBaseNInputBuffer;
@class DDBaseNDecoderAlphabet;

@interface DDBaseNDecoder : NSObject
{
    DDBaseNInputBuffer * _inputBuffer;
    NSMutableData * _outputBuffer;
    DDBaseNDecoderAlphabet * _alphabet;
}

- (id)initWithInputBuffer:(DDBaseNInputBuffer *)inputBuffer
                 alphabet:(DDBaseNDecoderAlphabet *)alphabet;

- (NSData *)decodeStringAndFinish:(NSString *)string;

- (void)decodeString:(NSString *)string;

- (void)decodeCharacter:(unichar)character;

- (NSData *)finishDecoding;

@end
