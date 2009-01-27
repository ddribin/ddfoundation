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

#import "DDBase64DecoderTest.h"
#import "DDBase64Decoder.h"
#import "NSData+DDExtensions.h"

@implementation DDBase64DecoderTest

static NSData * decode64(NSString * base64)
{
    return [DDBase64Decoder base64DecodeString:base64];
}

- (void)testBase64Decode
{
    STAssertEqualObjects(decode64(@""),
                         dddata(), nil);
    STAssertEqualObjects(decode64(@"Zg=="),
                         dddata('f'), nil);
    STAssertEqualObjects(decode64(@"Zm8="),
                         dddata('f', 'o'), nil);
    STAssertEqualObjects(decode64(@"Zm9v"),
                         dddata('f', 'o', 'o'), nil);
    STAssertEqualObjects(decode64(@"Zm9vYg=="),
                         dddata('f', 'o', 'o', 'b'), nil);
    STAssertEqualObjects(decode64(@"Zm9vYmE="),
                         dddata('f', 'o', 'o', 'b', 'a'), nil);
    STAssertEqualObjects(decode64(@"Zm9vYmFy"),
                         dddata('f', 'o', 'o', 'b', 'a', 'r'), nil);
}
@end
