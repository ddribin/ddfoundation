//
//  DDBase64DecoderTest.m
//  DDFoundation
//
//  Created by Dave Dribin on 9/29/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import "DDBase64DecoderTest.h"
#import "DDBase64Decoder.h"
#import "NSData+DDExtensions.h"

@implementation DDBase64DecoderTest

static NSData * decode64(NSString * base64)
{
    return [DDBase64Decoder base64DecodeString:base64];
}

- (void)testBase64Decode
{
    STAssertEqualObjects(decode64(@""),
                         dddata(), nil);
    STAssertEqualObjects(decode64(@"Zg=="),
                         dddata('f'), nil);
#if 1
    STAssertEqualObjects(decode64(@"Zm8="),
                         dddata('f', 'o'), nil);
    STAssertEqualObjects(decode64(@"Zm9v"),
                         dddata('f', 'o', 'o'), nil);
    STAssertEqualObjects(decode64(@"Zm9vYg=="),
                         dddata('f', 'o', 'o', 'b'), nil);
    STAssertEqualObjects(decode64(@"Zm9vYmE="),
                         dddata('f', 'o', 'o', 'b', 'a'), nil);
    STAssertEqualObjects(decode64(@"Zm9vYmFy"),
                         dddata('f', 'o', 'o', 'b', 'a', 'r'), nil);
#endif
}
@end
