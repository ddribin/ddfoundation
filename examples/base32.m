//
//  base32.m
//  DDFoundation
//
//  Created by Dave Dribin on 9/23/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDFoundation.h"


int main(int argc, char * argv[])
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    NSFileHandle * standardInput = [NSFileHandle fileHandleWithStandardInput];
    if (!isatty([standardInput fileDescriptor]))
    {
        NSData * input = [standardInput readDataToEndOfFile];
        NSString * encoded = [DDBaseXEncoder crockfordBase32EncodeData:input];
        printf("c: %s\n", [encoded UTF8String]);
        encoded = [DDBaseXEncoder zbase32EncodeData:input];
        printf("z: %s\n", [encoded UTF8String]);
    }
    
    NSProcessInfo * processInfo = [NSProcessInfo processInfo];
    NSEnumerator * arguments = [[processInfo arguments] objectEnumerator];
    [arguments nextObject];
    for (NSString * argument in arguments)
    {
        NSData * argumentData = [argument dataUsingEncoding:NSUTF8StringEncoding];
        NSString * encoded = [DDBaseXEncoder crockfordBase32EncodeData:argumentData];
        printf("c: %s\n", [encoded UTF8String]);
        encoded = [DDBaseXEncoder zbase32EncodeData:argumentData];
        printf("z: %s\n", [encoded UTF8String]);
    }
    
    [pool release];
    
    return 0;
}