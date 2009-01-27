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

#import "DDDelegateProxy.h"

#if MAC_OS_X_VERSION_MIN_REQUIRED <= MAC_OS_X_VERSION_10_4

@implementation DDDelegateProxy

- (id)initWithDelegate:(id)delegate defaultImplementation:(id)defaultImplementation;
{
    _delegate = delegate;
    _defaultImplementation = defaultImplementation;
    
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
	NSMethodSignature * sig;
	sig = [[_delegate class] instanceMethodSignatureForSelector:selector];
	if(sig == nil)
	{
        sig = [[_defaultImplementation class] instanceMethodSignatureForSelector:selector];
	}
	return sig;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL selector = [invocation selector];
    id target = _delegate;
    if ([_delegate respondsToSelector:selector])
        target = _delegate;
    else if ([_defaultImplementation respondsToSelector:selector])
        target = _defaultImplementation;
    
    [invocation invokeWithTarget:target];
}

@end

#else

#import <objc/runtime.h>

@implementation DDDelegateProxy

+ (Class)classForDelegate:(id)delegate defaultImplementatin:(id)defaultImplementation;
{
    NSString * className = [NSString stringWithFormat:@"DDDelegateProxy_%@_%@",
                            (delegate != nil)? [delegate className] : @"",
                            [defaultImplementation className]];
    Class dynamicClass = objc_getClass([className UTF8String]);
    if (dynamicClass != nil)
        return dynamicClass;
    
    dynamicClass = objc_allocateClassPair([self class], [className UTF8String], 0);
    if (dynamicClass == nil)
    {
        NSLog(@"objc_allocateClassPair returned NULL");
        return nil;
    }
    
    objc_registerClassPair(dynamicClass);
    
    return dynamicClass;
}

- (id)initWithDelegate:(id)delegate defaultImplementation:(id)defaultImplementation;
{
    Class dynamicClass = [[self class] classForDelegate:delegate
                                   defaultImplementatin:defaultImplementation];
    
    [self dealloc];
    self = nil;
    if (dynamicClass == nil)
        return nil;
    
    self = [dynamicClass alloc];
    
    _delegate = delegate;
    _defaultImplementation = defaultImplementation;
    
    return self;
}

- (id)forwardingTargetForSelector:(SEL)selector;
{
    id target = _delegate;
    if ([_delegate respondsToSelector:selector])
        target = _delegate;
    else if ([_defaultImplementation respondsToSelector:selector])
        target = _defaultImplementation;
    
    return target;
}

@end

#endif
