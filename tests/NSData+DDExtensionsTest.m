//
//  NSData+DDExtensionsTest.m
//  DDFoundation
//
//  Created by Dave Dribin on 9/23/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import "NSData+DDExtensionsTest.h"
#import "NSData+DDExtensions.h"


@implementation NSData_DDExtensionsTest

- (void)testDataMacro
{
    NSData * actual = dddata('f', 'o', 'o');
    uint8_t expectedBytes[] = {'f', 'o', 'o'};
    NSData * expected = [NSData dataWithBytes:expectedBytes length:sizeof(expectedBytes)];
    STAssertEqualObjects(actual, expected, nil);
}

- (void)testDataMacroWithString
{
    NSData * actual = dddata("foo");
    uint8_t expectedBytes[] = {'f', 'o', 'o', 0};
    NSData * expected = [NSData dataWithBytes:expectedBytes length:sizeof(expectedBytes)];
    STAssertEqualObjects(actual, expected, nil);
}

- (void)testAppendUTF8String
{
    NSMutableData * actual = [NSMutableData data];
    [actual dd_appendUTF8String:@"foo"];
    NSData * expected = dddata('f', 'o', 'o');
    STAssertEqualObjects(actual, expected, nil);
}

- (void)testAppendUTF8Format
{
    NSMutableData * actual = [NSMutableData data];
    [actual dd_appendUTF8Format:@"foo %d %@", 5, @"bar"];
    NSData * expected = dddata('f', 'o', 'o', ' ', '5', ' ', 'b', 'a', 'r');
    STAssertEqualObjects(actual, expected, nil);
}

- (void)testEncodeBase64
{
    STAssertEqualObjects(@"", [dddata() dd_encodeBase64], nil);
    STAssertEqualObjects(@"Zg==", [dddata('f') dd_encodeBase64], nil);
    STAssertEqualObjects(@"Zm8=", [dddata('f', 'o') dd_encodeBase64], nil);
    STAssertEqualObjects(@"Zm9v", [dddata('f', 'o', 'o') dd_encodeBase64], nil);
    STAssertEqualObjects(@"Zm9vYg==", [dddata('f', 'o', 'o', 'b') dd_encodeBase64], nil);
    STAssertEqualObjects(@"Zm9vYmE=", [dddata('f', 'o', 'o', 'b', 'a') dd_encodeBase64], nil);
    STAssertEqualObjects(@"Zm9vYmFy", [dddata('f', 'o', 'o', 'b', 'a', 'r') dd_encodeBase64], nil);
}

- (void)testEncodeBase32
{
    STAssertEqualObjects(@"", [dddata() dd_encodeBase32], nil);
    STAssertEqualObjects(@"MY======", [dddata('f') dd_encodeBase32], nil);
    STAssertEqualObjects(@"MZXQ====", [dddata('f', 'o') dd_encodeBase32], nil);
    STAssertEqualObjects(@"MZXW6===", [dddata('f', 'o', 'o') dd_encodeBase32], nil);
    STAssertEqualObjects(@"MZXW6YQ=", [dddata('f', 'o', 'o', 'b') dd_encodeBase32], nil);
    STAssertEqualObjects(@"MZXW6YTB", [dddata('f', 'o', 'o', 'b', 'a') dd_encodeBase32], nil);
    STAssertEqualObjects(@"MZXW6YTBOI======", [dddata('f', 'o', 'o', 'b', 'a', 'r') dd_encodeBase32], nil);
}

@end
