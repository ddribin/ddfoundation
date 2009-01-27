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

#import "DDDelegateProxyTest.h"
#import "DDDelegateProxy.h"

@protocol DDDelegateProxyTestProtocol

- (void)doSomething;

@optional

- (int)optionalOne;

- (int)optionalTwo;

@end

@interface TestDDDelegate : NSObject <DDDelegateProxyTestProtocol>
{
    int _doSomethingCallCount;
}

@property (readonly) int doSomethingCallCount;

- (void)doSomething;

@end

@implementation TestDDDelegate

@synthesize doSomethingCallCount = _doSomethingCallCount;

- (void)doSomething;
{
    _doSomethingCallCount++;
}

@end


@implementation DDDelegateProxyTest

- (int)optionalOne;
{
    return 43;
}

- (void)testForward
{
    TestDDDelegate * delegate = [[[TestDDDelegate alloc] init] autorelease];
    id<DDDelegateProxyTestProtocol> forwarder = [[DDDelegateProxy alloc] initWithDelegate:delegate
                                                                    defaultImplementation:self];
    [forwarder doSomething];
    [forwarder doSomething];
    STAssertEquals([delegate doSomethingCallCount], 2 ,nil);

    int result;
    result = [forwarder optionalOne];
    STAssertEquals(result, 43, nil);
}

@end
