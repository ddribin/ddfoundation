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
#import "NSString+DDExtensions.h"

@implementation DDBase32EncoderTest

static NSString * encode32(NSString * stringData)
{
    NSData * data = [stringData dd_utf8Data];
    return [DDBase32Encoder base32EncodeData:data];
}

static NSString * crockfordEncode32(NSString * stringData)
{
    NSData * data = [stringData dd_utf8Data];
    return [DDBase32Encoder crockfordBase32EncodeData:data];
}

static NSString * zbase32Encode32(NSString * stringData)
{
    NSData * data = [stringData dd_utf8Data];
    return [DDBase32Encoder zbase32EncodeData:data];
}

- (void)testEncodeBase32
{
    STAssertEqualObjects(@"",         encode32(@""), nil);
    STAssertEqualObjects(@"MY======", encode32(@"f"), nil);
    STAssertEqualObjects(@"MZXQ====", encode32(@"fo"), nil);
    STAssertEqualObjects(@"MZXW6===", encode32(@"foo"), nil);
    STAssertEqualObjects(@"MZXW6YQ=", encode32(@"foob"), nil);
    STAssertEqualObjects(@"MZXW6YTB", encode32(@"fooba"), nil);
    STAssertEqualObjects(@"MZXW6YTBOI======", encode32(@"foobar"), nil);
}

- (void)testEncodeBase32Crockford
{
    STAssertEqualObjects(@"CSQPYRK1E800", crockfordEncode32(@"foobar\0"), nil);
}

- (void)testEncodeBase32ZBase32
{
    STAssertEqualObjects(@"C3ZS6AUBQEYY", zbase32Encode32(@"foobar\0"), nil);
}

@end
