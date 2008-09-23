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


@interface DDAbstractBaseEncoder : NSObject
{
  @protected
    int _byteIndex;
    NSMutableString * _output;
    BOOL _addPadding;
    BOOL _addLineBreaks;
    unsigned _currentLineLength;
}

+ (NSString *)encodeData:(NSData *)data;

+ (NSString *)encodeData:(NSData *)data options:(DDBaseEncoderOptions)options;

- (id)init;

- (id)initWithOptions:(DDBaseEncoderOptions)options;

- (void)reset;

- (NSString *)finishEncoding;

- (void)encodeByte:(uint8_t)byte;

- (void)encodeData:(NSData *)data;

@end

@interface DDAbstractBaseEncoder (Protected)

- (void)appendPadCharacters:(int)count;
- (void)appendCharacter:(char)ch;

@end
