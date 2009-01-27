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

#import "DDBase64EncoderTest.h"
#import "DDBase64Encoder.h"
#import "NSData+DDExtensions.h"

@implementation DDBase64EncoderTest

static NSString * encode64(NSData * data)
{
    return [DDBase64Encoder base64EncodeData:data];
}

static NSString * encode64NoPadding(NSData * data)
{
    return [DDBase64Encoder base64EncodeData:data
                                     options:DDBaseEncoderOptionNoPadding];
}

static NSString * encode64WithLineBreaks(NSData * data)
{
    return [DDBase64Encoder base64EncodeData:data
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

@end
