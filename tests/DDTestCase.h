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

#import <SenTestingKit/SenTestingKit.h>


@interface DDTestCase : SenTestCase
{
}

- (NSBundle *) myBundle;
- (NSString *) resourcePath;
- (NSString *) pathForResource: (NSString *) resource ofType: (NSString *) type;

- (NSString *) stringForResource: (NSString *) resource ofType: (NSString *) type;
- (NSData *) dataForResource: (NSString *) resource ofType: (NSString *) type;
- (id) plistForResource: (NSString *) resource;

@end

#define DD_TEST(_NAME_) DD_TEST2(_NAME_, __LINE__)

#define DD_TEST2(_NAME_, _LINE_) DD_TEST3(_NAME_, _LINE_)

#define DD_TEST3(_NAME_, _LINE_) \
+ (NSString *)testLine_ ## _LINE_ { return _NAME_; } \
- (void)testLine_ ## _LINE_

