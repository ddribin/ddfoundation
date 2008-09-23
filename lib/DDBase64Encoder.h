//
//  DDBase64Encoder.h
//  DDFoundation
//
//  Created by Dave Dribin on 9/23/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    DDBase64EncoderOptionNoPadding = 0x01,
    DDBase64EncoderOptionAddLineBreaks = 0x02,
};
typedef unsigned DDBase64EncoderOptions;


@interface DDBase64Encoder : NSObject
{
    int _byteIndex;
    NSMutableString * _output;
    // A 24-bit buffer. Holds 3 octest and 4 groups.
    uint32_t _buffer;
    BOOL _addPadding;
    BOOL _addLineBreaks;
    unsigned _currentLineLength;
}

+ (NSString *)encodeData:(NSData *)data;

+ (NSString *)encodeData:(NSData *)data options:(DDBase64EncoderOptions)options;

- (id)init;

- (id)initWithOptions:(DDBase64EncoderOptions)options;

- (void)reset;

- (NSString *)finishEncoding;

- (void)encodeByte:(uint8_t)byte;

- (void)encodeData:(NSData *)data;

@end
