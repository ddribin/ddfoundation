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


static void encodeData(NSData * data)
{
    NSString * encoded = [DDBase32Encoder crockfordBase32EncodeData:data];
    printf("c: %s\n", [encoded UTF8String]);
    encoded = [DDBase32Encoder zbase32EncodeData:data];
    printf("z: %s\n", [encoded UTF8String]);
}

static void decodeString(NSString * string)
{
    NSData * decoded = [DDBase32Decoder crockfordBase32DecodeString:string];
    printf("c: %s\n", [[decoded description] UTF8String]);
    NSString * decodedString = [[NSString alloc] initWithData:decoded encoding:NSUTF8StringEncoding];
    [decodedString autorelease];
    printf("c: %s\n", [decodedString UTF8String]);
}

int main(int argc, char * argv[])
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    NSProcessInfo * processInfo = [NSProcessInfo processInfo];
    NSEnumerator * arguments = [[processInfo arguments] objectEnumerator];
    BOOL encode = YES;
    [arguments nextObject];
    for (NSString * argument in arguments)
    {
        if ([argument isEqualToString:@"-d"])
        {
            encode = NO;
            continue;
        }
        
        if (encode)
        {
            NSData * argumentData = [argument dataUsingEncoding:NSUTF8StringEncoding];
            encodeData(argumentData);
        }
        else
        {
            decodeString(argument);
        }
    }
    
    NSFileHandle * standardInput = [NSFileHandle fileHandleWithStandardInput];
    if (!isatty([standardInput fileDescriptor]))
    {
        NSData * input = [standardInput readDataToEndOfFile];
        if (encode)
        {
            encodeData(input);
        }
        else
        {
            NSString * string = [[NSString alloc] initWithData:input encoding:NSUTF8StringEncoding];
            [string autorelease];
            decodeString(string);
        }
    }
    
    [pool release];
    
    return 0;
}
