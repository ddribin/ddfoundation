//
//  DDBase64Encoder.h
//  DDFoundation
//
//  Created by Dave Dribin on 9/23/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DDBase64Encoder : NSObject
{
    int _state;
    NSMutableString * _output;
    uint32_t _buffer;
}

+ (NSString *)encodeData:(NSData *)data;

- (void)reset;

- (NSString *)finishEncoding;

- (void)encodeByte:(uint8_t)byte;

- (void)encodeData:(NSData *)data;

@end
