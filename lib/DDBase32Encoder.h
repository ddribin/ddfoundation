//
//  DDBase32Encoder.h
//  DDFoundation
//
//  Created by Dave Dribin on 9/23/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <Foundation/Foundation.h>

enum {
    DDBase32EncoderOptionNoPadding = 0x01,
    DDBase32EncoderOptionAddLineBreaks = 0x02,
};
typedef unsigned DDBase32EncoderOptions;


@interface DDBase32Encoder : NSObject
{
    int _byteIndex;
    NSMutableString * _output;
    // A 40-bit buffer. Holds 5 bytes and 8 5-bit groups.
    uint64_t _buffer;
    BOOL _addPadding;
    BOOL _addLineBreaks;
    unsigned _currentLineLength;
}

+ (NSString *)encodeData:(NSData *)data;

+ (NSString *)encodeData:(NSData *)data options:(DDBase32EncoderOptions)options;

- (id)init;

- (id)initWithOptions:(DDBase32EncoderOptions)options;

- (void)reset;

- (NSString *)finishEncoding;

- (void)encodeByte:(uint8_t)byte;

- (void)encodeData:(NSData *)data;

@end
