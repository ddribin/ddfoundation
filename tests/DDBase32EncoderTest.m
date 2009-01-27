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

#import "DDBase32EncoderTest.h"
#import "DDBase32Encoder.h"
#import "NSData+DDExtensions.h"

@implementation DDBase32EncoderTest

static NSString * encode32(NSData * data)
{
    return [DDBase32Encoder base32EncodeData:data];
}

static NSString * crockfordEncode32(NSData * data)
{
    return [DDBase32Encoder crockfordBase32EncodeData:data];
}

static NSString * zbase32Encode32(NSData * data)
{
    return [DDBase32Encoder zbase32EncodeData:data];
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
