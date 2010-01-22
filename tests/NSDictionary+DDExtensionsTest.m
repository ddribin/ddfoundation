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

#import "NSDictionary+DDExtensionsTest.h"
#import "NSDictionary+DDExtensions.h"


@implementation NSDictionary_DDExtensionsTest

- (void)testHelperMacroCreatesDictionary
{
    NSDictionary * dictionary = dd_dict(@"color1", @"red",
                                        @"color2", @"green");
    NSDictionary * expected = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"red", @"color1",
                               @"green", @"color2",
                               nil];
    STAssertEqualObjects(dictionary, expected, nil);
}

- (void)testUnevenNumberOfArgumentsThrows
{
    @try
    {
        dd_dict(@"color1", @"red",
                @"color2");
        STFail(@"should have thrown exception");;
    }
    @catch (NSException * e)
    {
        // Expected
    }
}

- (void)testNilKeyThrows
{
    @try
    {
        dd_dict(nil, @"red");
        STFail(@"should have thrown exception");;
    }
    @catch (NSException * e)
    {
        // Expected
    }
}

- (void)testMdictMacroCreatesMutableDictionary
{
    NSMutableDictionary * dictionary = dd_mdict(@"color1", @"red",
                                                @"color2", @"green");
    [dictionary setObject:@"blue" forKey:@"color3"];

    NSDictionary * expected = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"red", @"color1",
                               @"green", @"color2",
                               @"blue", @"color3",
                               nil];
    STAssertEqualObjects(dictionary, expected, nil);
}

@end
