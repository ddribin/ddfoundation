//
//  DDBase64EncoderTest.m
//  DDFoundation
//
//  Created by Dave Dribin on 9/23/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import "DDBaseXEncoderTest.h"
#import "DDBaseXEncoder.h"
#import "NSData+DDExtensions.h"

@implementation DDBaseXEncoderTest

#pragma mark -
#pragma mark Base64 Tests

static NSString * encode64(NSData * data)
{
    return [DDBaseXEncoder base64EncodeData:data];
}

static NSString * encode64NoPadding(NSData * data)
{
    return [DDBaseXEncoder base64EncodeData:data
                                           options:DDBaseEncoderOptionNoPadding];
}

static NSString * encode64WithLineBreaks(NSData * data)
{
    return [DDBaseXEncoder base64EncodeData:data
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

#pragma mark -
#pragma mark Base64 Tests

static NSString * encode32(NSData * data)
{
    return [DDBaseXEncoder base32EncodeData:data];
}

static NSString * crockfordEncode32(NSData * data)
{
    return [DDBaseXEncoder crockfordBase32EncodeData:data];
}

static NSString * zbase32Encode32(NSData * data)
{
    return [DDBaseXEncoder zbase32EncodeData:data];
}

- (void)testEncodeBase32
{
    STAssertEqualObjects(@"", encode32(dddata()), nil);
    STAssertEqualObjects(@"MY======", encode32(dddata('f')), nil);
    STAssertEqualObjects(@"MZXQ====", encode32(dddata('f', 'o')), nil);
    STAssertEqualObjects(@"MZXW6===", encode32(dddata('f', 'o', 'o')), nil);
    STAssertEqualObjects(@"MZXW6YQ=", encode32(dddata('f', 'o', 'o', 'b')), nil);
    STAssertEqualObjects(@"MZXW6YTB", encode32(dddata('f', 'o', 'o', 'b', 'a')), nil);
    STAssertEqualObjects(@"MZXW6YTBOI======",
                         encode32(dddata('f', 'o', 'o', 'b', 'a', 'r')), nil);
}

- (void)testEncodeBase32Crockford
{
    STAssertEqualObjects(@"CSQPYRK1E800", crockfordEncode32(dddata("foobar")), nil);
}

- (void)testEncodeBase32ZBase32
{
    STAssertEqualObjects(@"C3ZS6AUBQEYY", zbase32Encode32(dddata("foobar")), nil);
}

@end
