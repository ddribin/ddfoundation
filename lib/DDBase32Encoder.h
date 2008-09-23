//
//  DDBase32Encoder.h
//  DDFoundation
//
//  Created by Dave Dribin on 9/23/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <Foundation/Foundation.h>
#import "DDAbstractBaseEncoder.h"

@interface DDBase32Encoder : DDAbstractBaseEncoder
{
    // A 40-bit buffer. Holds 5 bytes and 8 5-bit groups.
    uint64_t _buffer;
    const char * _encodeTable;
}

+ (NSString *)crockfordEncodeData:(NSData *)data;

- (id)initWithOptions:(DDBaseEncoderOptions)options useCrockfordTable:(BOOL)crockford;


@end
