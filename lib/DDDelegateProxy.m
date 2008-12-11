//

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
