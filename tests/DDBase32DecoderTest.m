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

@end
