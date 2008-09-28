/*
 * Copyright (c) 2007-2008 Dave Dribin
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

#import <Foundation/Foundation.h>
#import "DDFoundation.h"


int main(int argc, char * argv[])
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    NSFileHandle * standardInput = [NSFileHandle fileHandleWithStandardInput];
    if (!isatty([standardInput fileDescriptor]))
    {
        NSData * input = [standardInput readDataToEndOfFile];
        NSString * encoded = [DDBase32Encoder crockfordBase32EncodeData:input];
        printf("c: %s\n", [encoded UTF8String]);
        encoded = [DDBase32Encoder zbase32EncodeData:input];
        printf("z: %s\n", [encoded UTF8String]);
    }
    
    NSProcessInfo * processInfo = [NSProcessInfo processInfo];
    NSEnumerator * arguments = [[processInfo arguments] objectEnumerator];
    [arguments nextObject];
    for (NSString * argument in arguments)
    {
        NSData * argumentData = [argument dataUsingEncoding:NSUTF8StringEncoding];
        NSString * encoded = [DDBase32Encoder crockfordBase32EncodeData:argumentData];
        printf("c: %s\n", [encoded UTF8String]);
        encoded = [DDBase32Encoder zbase32EncodeData:argumentData];
        printf("z: %s\n", [encoded UTF8String]);
    }
    
    [pool release];
    
    return 0;
}
