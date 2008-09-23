//
//  DDBase32EncoderTest.m
//  DDFoundation
//
//  Created by Dave Dribin on 9/23/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import "DDBase32EncoderTest.h"
#import "DDBase32Encoder.h"
#import "NSData+DDExtensions.h"


@implementation DDBase32EncoderTest

static NSString * encode32(NSData * data)
{
    return [DDBase32Encoder encodeData:data];
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

@end
