/*
 * Copyright (c) 2007-2009 Dave Dribin
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

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
