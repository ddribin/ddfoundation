//
//  DDBase64EncoderTest.m
//  DDFoundation
//
//  Created by Dave Dribin on 9/23/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import "DDBase64EncoderTest.h"
#import "DDBase64Encoder.h"
#import "NSData+DDExtensions.h"

@implementation DDBase64EncoderTest

- (void)testEncodeBase64
{
    STAssertEqualObjects(@"",
                         [DDBase64Encoder encodeData:dddata()], nil);
    STAssertEqualObjects(@"Zg==",
                         [DDBase64Encoder encodeData:dddata('f')], nil);
    STAssertEqualObjects(@"Zm8=",
                         [DDBase64Encoder encodeData:dddata('f', 'o')], nil);
    STAssertEqualObjects(@"Zm9v",
                         [DDBase64Encoder encodeData:dddata('f', 'o', 'o')], nil);
    STAssertEqualObjects(@"Zm9vYg==",
                         [DDBase64Encoder encodeData:dddata('f', 'o', 'o', 'b')], nil);
    STAssertEqualObjects(@"Zm9vYmE=",
                         [DDBase64Encoder encodeData:dddata('f', 'o', 'o', 'b', 'a')], nil);
    STAssertEqualObjects(@"Zm9vYmFy",
                         [DDBase64Encoder encodeData:dddata('f', 'o', 'o', 'b', 'a', 'r')], nil);
}

@end
