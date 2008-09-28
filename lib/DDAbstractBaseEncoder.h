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

@class DDBaseXOutputBuffer;


@interface DDAbstractBaseEncoder : NSObject
{
  @protected
    int _byteIndex;
    DDBaseXOutputBuffer * _outputBuffer;
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
