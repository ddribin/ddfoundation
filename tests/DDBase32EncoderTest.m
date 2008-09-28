//
//  DDBase32EncoderTest.m
//  DDFoundation
//
//  Created by Dave Dribin on 9/23/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import "DDBase32EncoderTest.h"
#import "DDBaseXEncoder.h"
#import "NSData+DDExtensions.h"


@implementation DDBase32EncoderTest

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
