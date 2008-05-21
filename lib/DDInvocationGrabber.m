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

#import "DDInvocationGrabber.h"


@implementation DDInvocationGrabber

+ (id)invocationGrabber
{
    return([[[self alloc] init] autorelease]);
}

- (id)init
{
    _target = nil;
    _invocation = nil;
    _forwardInvokesOnMainThread = NO;
    _waitUntilDone = NO;
    
    return self;
}

- (void)dealloc
{
    [self setTarget:NULL];
    [self setInvocation:NULL];
    //
    [super dealloc];
}

#pragma mark -

- (id)target
{
    return _target;
}

- (void)setTarget:(id)inTarget
{
    if (_target != inTarget)
	{
        [_target autorelease];
        _target = [inTarget retain];
	}
}

- (NSInvocation *)invocation
{
    return _invocation;
}

- (void)setInvocation:(NSInvocation *)inInvocation
{
    if (_invocation != inInvocation)
	{
        [_invocation autorelease];
        _invocation = [inInvocation retain];
	}
}

- (BOOL)forwardInvokesOnMainThread;
{
    return _forwardInvokesOnMainThread;
}

- (void)setForwardInvokesOnMainThread:(BOOL)forwardInvokesOnMainThread;
{
    _forwardInvokesOnMainThread = forwardInvokesOnMainThread;
}

- (BOOL)waitUntilDone;
{
    return _waitUntilDone;
}

- (void)setWaitUntilDone:(BOOL)waitUntilDone;
{
    _waitUntilDone = waitUntilDone;
}

#pragma mark -

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    return [[self target] methodSignatureForSelector:selector];
}

- (void)forwardInvocation:(NSInvocation *)ioInvocation
{
    [ioInvocation setTarget:[self target]];
    [self setInvocation:ioInvocation];
    if (_forwardInvokesOnMainThread)
    {
        if (!_waitUntilDone)
            [_invocation retainArguments];
        [_invocation performSelectorOnMainThread:@selector(invoke)
                                      withObject:nil
                                   waitUntilDone:_waitUntilDone];
    }
}

@end

#pragma mark -

@implementation DDInvocationGrabber (DDnvocationGrabber_Conveniences)

- (id)prepareWithInvocationTarget:(id)inTarget
{
    [self setTarget:inTarget];
    return(self);
}

@end
