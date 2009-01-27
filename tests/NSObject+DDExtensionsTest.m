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

#import "NSObject+DDExtensionsTest.h"
#import "NSObject+DDExtensions.h"


@implementation NSObject_DDExtensionsTest

@synthesize done = _done;
@synthesize invoked = _invoked;

- (int)incrementByInt:(int)count
{
    _count += count;
    self.invoked = YES;
    return _count;
}

- (void)backgroundMethod:(NSNumber *)waitUntilDoneNumber
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    BOOL wait = [waitUntilDoneNumber boolValue];
    
    id grabber = 
        [self dd_invokeOnMainThreadAndWaitUntilDone:wait];
    [grabber incrementByInt:10];
    
    if (wait)
        [[grabber invocation] getReturnValue:&_result];
    
    self.done = YES;
    [pool release];
}

- (void)testForwardInvokesOnMainThreadWait
{
    _count = 0;
    _result = 0;
    self.done = NO;
    self.invoked = NO;
    
    [self performSelectorInBackground:@selector(backgroundMethod:)
                           withObject:[NSNumber numberWithBool:YES]];
    while (!self.done)
    {
        [[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode
                                 beforeDate: [NSDate date]];
    }
    STAssertEquals(_count, 10, nil);
    STAssertEquals(_result, 10, nil);
}

- (void)testForwardInvokesOnMainThreadNoWait
{
    _count = 0;
    _result = 0;
    self.done = NO;
    self.invoked = NO;
    
    [self performSelectorInBackground:@selector(backgroundMethod:)
                           withObject:[NSNumber numberWithBool:NO]];
    while (!self.invoked)
    {
        [[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode
                                 beforeDate: [NSDate date]];
    }
    STAssertEquals(_count, 10, nil);
}

- (void)mainThreadMethod:(NSNumber *)number;
{
    // If arguments were not retained, this will dereference a released
    // object, and cause a crash.
    _count = [number intValue];
    self.invoked = YES;
}

- (void)backgroundMethodWithObject
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    NSNumber * number = [NSNumber numberWithInt:42];
    
    [[self dd_invokeOnMainThreadAndWaitUntilDone:NO] mainThreadMethod:number];
    
    self.done = YES;
    [pool release];
}

- (void)testForwardNoWaitRetainsArguments
{
    _count = 0;
    _result = 0;
    self.done = NO;
    self.invoked = NO;
    
    [self performSelectorInBackground:@selector(backgroundMethodWithObject)
                           withObject:nil];
    while (!self.invoked)
    {
        [[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode
                                 beforeDate: [NSDate date]];
    }
    STAssertEquals(_count, 42, nil);
}

@end
