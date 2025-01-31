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

#import "NSData+DDExtensions.h"
#import "DDBase64Encoder.h"
#import "DDBase32Encoder.h"


NSData * DDStringData(NSString * string)
{
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

@implementation NSData (DDExtensions)

+ (NSData *)dd_randomDataOfLength:(unsigned)length;
{
    return [[NSFileHandle fileHandleForReadingAtPath:@"/dev/random"]
            readDataOfLength:length];
}

- (NSString *)dd_encodeBase64;
{
    return [DDBase64Encoder base64EncodeData:self];
}

- (NSString *)dd_encodeBase32
{
    return [DDBase32Encoder base32EncodeData:self];
}

@end

@implementation NSMutableData (DDExtensions)

- (void) dd_appendUTF8String: (NSString *) string;
{
    [self appendData: [string dataUsingEncoding: NSUTF8StringEncoding]];
}

- (void) dd_appendUTF8Format: (NSString *) format, ...;
{
    va_list argList;
    va_start(argList, format);
    NSString * string = [[[NSString alloc] initWithFormat: format
                                                arguments: argList]
        autorelease];
    va_end(argList);
    [self dd_appendUTF8String: string];
}

@end
