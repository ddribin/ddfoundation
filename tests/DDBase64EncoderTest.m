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

static NSString * encode64(NSData * data)
{
    return [DDBase64Encoder base64EncodeData:data];
}

static NSString * encode64NoPadding(NSData * data)
{
    return [DDBase64Encoder base64EncodeData:data
                                     options:DDBaseEncoderOptionNoPadding];
}

static NSString * encode64WithLineBreaks(NSData * data)
{
    return [DDBase64Encoder base64EncodeData:data
                                     options:DDBaseEncoderOptionAddLineBreaks];
}

- (void)testBase64Encode
{
    STAssertEqualObjects(encode64(dddata()),
                         @"", nil);
    STAssertEqualObjects(encode64(dddata('f')),
                         @"Zg==", nil);
    STAssertEqualObjects(encode64(dddata('f', 'o')),
                         @"Zm8=", nil);
    STAssertEqualObjects(encode64(dddata('f', 'o', 'o')),
                         @"Zm9v", nil);
    STAssertEqualObjects(encode64(dddata('f', 'o', 'o', 'b')),
                         @"Zm9vYg==", nil);
    STAssertEqualObjects(encode64(dddata('f', 'o', 'o', 'b', 'a')),
                         @"Zm9vYmE=", nil);
    STAssertEqualObjects(encode64(dddata('f', 'o', 'o', 'b', 'a', 'r')),
                         @"Zm9vYmFy", nil);
}

- (void)testBase64EncodeNoPadding
{
    STAssertEqualObjects(encode64NoPadding(dddata('f')),
                         @"Zg", nil);
    STAssertEqualObjects(encode64NoPadding(dddata('f', 0)),
                         @"ZgA", nil);
    STAssertEqualObjects(encode64NoPadding(dddata('f', 0, 0)),
                         @"ZgAA", nil);
}

- (void)testBase64EncodeWithLineBreaks
{
    NSData * loremIpsum = dddata("Lorem ipsum dolor sit amet, consectetur adipisicing");
    
    STAssertEqualObjects(encode64(loremIpsum),
                         @"TG9yZW0gaXBzdW0gZG9sb3Igc2l0IGFtZXQsIGNvbnNlY3RldHVyIGFkaXBpc2ljaW5nAA==",
                         nil);
                         
    STAssertEqualObjects(encode64WithLineBreaks(loremIpsum),
                         @"TG9yZW0gaXBzdW0gZG9sb3Igc2l0IGFtZXQsIGNvbnNlY3RldHVyIGFkaXBpc2lj\n"
                         "aW5nAA==",
                         nil);
}

@end
