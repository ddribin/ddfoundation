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

- (void)testNoPadding
{
    STAssertEqualObjects(@"Zg",
                         [DDBase64Encoder encodeData:dddata('f')
                                             options:DDBaseEncoderOptionNoPadding],
                         nil);
    STAssertEqualObjects(@"ZgA",
                         [DDBase64Encoder encodeData:dddata('f', 0)
                                             options:DDBaseEncoderOptionNoPadding],
                         nil);
    STAssertEqualObjects(@"ZgAA",
                         [DDBase64Encoder encodeData:dddata('f', 0, 0)
                                             options:DDBaseEncoderOptionNoPadding],
                         nil);
}

- (void)testLineBreak
{
    STAssertEqualObjects(@"TG9yZW0gaXBzdW0gZG9sb3Igc2l0IGFtZXQsIGNvbnNlY3RldHVyIGFkaXBpc2ljaW5nAA==",
                         [DDBase64Encoder encodeData:dddata("Lorem ipsum dolor sit amet, consectetur adipisicing")],
                         nil);
                         
    STAssertEqualObjects(@"TG9yZW0gaXBzdW0gZG9sb3Igc2l0IGFtZXQsIGNvbnNlY3RldHVyIGFkaXBpc2lj\n"
                         "aW5nAA==",
                         [DDBase64Encoder encodeData:dddata("Lorem ipsum dolor sit amet, consectetur adipisicing")
                                             options:DDBaseEncoderOptionAddLineBreaks],
                         nil);
}

@end
