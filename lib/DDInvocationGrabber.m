//
//  DDInvocationGrabber.m
//  DDFoundation
//
//  Created by Dave Dribin on 5/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DDInvocationGrabber.h"


@implementation DDInvocationGrabber

+ (id)invocationGrabber
{
    return([[[self alloc] init] autorelease]);
}

- (id)init
{
    self = [super init];
    if (self == nil)
        return nil;
    
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

- (NSMethodSignature *)methodSignatureForSelector:(SEL)inSelector
{
    /* Let's see if our super class has a signature for this selector. */
    NSMethodSignature *theMethodSignature = [super methodSignatureForSelector:inSelector];
    if (theMethodSignature == NULL)
    {
        theMethodSignature = [[self target] methodSignatureForSelector:inSelector];
    }
	
    
    return(theMethodSignature);
}

- (void)forwardInvocation:(NSInvocation *)ioInvocation
{
    [ioInvocation setTarget:[self target]];
    [self setInvocation:ioInvocation];
    if (_forwardInvokesOnMainThread)
    {
        NSLog(@"Forwarding performSelectorOnMainThread");
        [[self invocation] performSelectorOnMainThread:@selector(invoke)
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