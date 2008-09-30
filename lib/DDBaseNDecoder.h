//
//  DDBaseNDecoder.h
//  DDFoundation
//
//  Created by Dave Dribin on 9/29/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>


@class DDBaseNInputBuffer;

@interface DDBaseNDecoder : NSObject
{
    DDBaseNInputBuffer * _inputBuffer;
    NSMutableData * _outputBuffer;
    const char * _alphabet;
    unsigned _alphabetLength;
}

- (id)initWithInputBuffer:(DDBaseNInputBuffer *)inputBuffer
                 alphabet:(const char *)alphabet
           alphabetLength:(unsigned)alphabetLength;

- (NSData *)decodeStringAndFinish:(NSString *)string;

- (void)decodeString:(NSString *)string;

- (void)decodeCharacter:(unichar)character;

- (NSData *)finishDecoding;

@end
