//
//  DDBase64Encoder.h
//  DDFoundation
//
//  Created by Dave Dribin on 9/28/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDBaseXEncoder.h"
#import "DDBaseXInputBuffer.h"

@interface DDBase64Encoder : DDBaseXEncoder
{
}

+ (NSString *)base64EncodeData:(NSData *)data;

+ (NSString *)base64EncodeData:(NSData *)data options:(DDBaseEncoderOptions)options;

+ (id)base64EncoderWithOptions:(DDBaseEncoderOptions)options;

- (id)initWithOptions:(DDBaseEncoderOptions)options;

@end


@interface DDBaseXInputBuffer (DDBase64Encoder)

+ (id)base64InputBuffer;

@end
