//
//  DDBase32DecoderTest.m
//  DDFoundation
//
//  Created by Dave Dribin on 9/29/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import "DDBase32DecoderTest.h"
#import "DDBase32Decoder.h"
#import "NSData+DDExtensions.h"


@implementation DDBase32DecoderTest

static NSData * decode32(NSString * string)
{
    return [DDBase32Decoder base32DecodeString:string];
}

static NSData * crockfordDecode32(NSString * string)
{
    return [DDBase32Decoder crockfordBase32DecodeString:string];
}

- (void)testDecodeBase32
{
    STAssertEqualObjects(dddata(), decode32(@""), nil);
    STAssertEqualObjects(dddata('f'), decode32(@"MY======"), nil);
    STAssertEqualObjects(dddata('f', 'o'), decode32(@"MZXQ===="), nil);
    STAssertEqualObjects(dddata('f', 'o', 'o'), decode32(@"MZXW6==="), nil);
    STAssertEqualObjects(dddata('f', 'o', 'o', 'b'), decode32(@"MZXW6YQ="), nil);
    STAssertEqualObjects(dddata('f', 'o', 'o', 'b', 'a'),
                         decode32(@"MZXW6YTB"), nil);
    STAssertEqualObjects(dddata('f', 'o', 'o', 'b', 'a', 'r'),
                         decode32(@"MZXW6YTBOI======"), nil);
}

- (void)testDecodeBase32Crockford
{
    STAssertEqualObjects(dddata("foobar"), crockfordDecode32(@"CSQPYRK1E800"), nil);
}

- (void)testDecodeBase32CrockfordLowerCase
{
    STAssertEqualObjects(dddata("foobar"), crockfordDecode32(@"csqpyrk1e800"), nil);
}

- (void)testDecodeBase32CrockfordZeroAliases
{
    STAssertEqualObjects(dddata("foobar"), crockfordDecode32(@"CSQPYRK1E8Oo"), nil);
}

- (void)testDecodeBase32CrockfordOneAliases
{
    STAssertEqualObjects(dddata("foobar"), crockfordDecode32(@"CSQPYRKIE800"), nil);
    STAssertEqualObjects(dddata("foobar"), crockfordDecode32(@"CSQPYRKiE800"), nil);
    STAssertEqualObjects(dddata("foobar"), crockfordDecode32(@"CSQPYRKLE800"), nil);
    STAssertEqualObjects(dddata("foobar"), crockfordDecode32(@"CSQPYRKlE800"), nil);
}

- (void)testDecodeBase32CrockfordDashesIgnored
{
    STAssertEqualObjects(dddata("foobar"), crockfordDecode32(@"CSQPYR-K1E800"), nil);
}

@end
