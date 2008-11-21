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

#import "DDObserverDispatcherEntry.h"
#import "DDObserverNotification.h"

@interface NSThread (DDObserverDispatcher)

+ (BOOL)isMainThread;

@end


@implementation DDObserverDispatcherEntry

- (id) initWithObserved:(id)observed
                keyPath:(NSString *)keyPath
                 target:(id)target
                 action:(SEL)action
         dispatchOption: (DDObserverDispatchOption) dispatchOption;
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _observed = observed;
    _keyPath = [keyPath copy];
    _target = target;
    _action = action;
    _hasDispatchOption = YES;
    _dispatchOption = dispatchOption;
    
    return self;
}

- (void)dealloc
{
    [_keyPath release];
    [super dealloc];
}

- (id)observed;
{
    return _observed;
}

- (NSString *)keyPath;
{
    return _keyPath;
}

- (id)target;
{
    return _target;
}

- (SEL) action;
{
    return _action;
}

- (BOOL) hasDispatchOption;
{
    return _hasDispatchOption;
}

- (DDObserverDispatchOption) dispatchOption;
{
    return _dispatchOption;
}

- (void)startObservingWithOptions:(NSKeyValueObservingOptions)kvoOptions
{
    [_observed addObserver:self
                forKeyPath:_keyPath
                   options:kvoOptions
                   context:NULL];
}

- (void)stopObserving;
{
    [_observed removeObserver:self
                   forKeyPath:_keyPath];
}

- (BOOL)matchesObserved:(id)observed keyPath:(NSString *)keyPath;
{
    BOOL matchesObserved = (observed == nil) || (_observed == observed);
    BOOL matchesKeyPath = (keyPath == nil) || ([_keyPath isEqualToString:keyPath]);
    return (matchesObserved && matchesKeyPath);
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    DDObserverNotification * notification =
    [DDObserverNotification notificationWithObject:object
                                           keyPath:_keyPath
                                            change:change];
    
    BOOL dispatchNow = (_dispatchOption == DDObserverDispatchOnCallingThread);
    if ([[NSThread class] respondsToSelector:@selector(isMainThread)])
    {
        BOOL dispatchOnMainThread = ((_dispatchOption == DDObserverDispatchOnMainThreadAndWait) ||
                                     (_dispatchOption == DDObserverDispatchOnMainThread));
        dispatchNow = (dispatchNow ||
                       (dispatchOnMainThread && [NSThread isMainThread]));
    }
    
    if (dispatchNow)
        [_target performSelector: _action withObject: notification];
    else if (_dispatchOption == DDObserverDispatchOnMainThreadAndWait)
        [_target performSelectorOnMainThread: _action withObject: notification waitUntilDone: YES];
    else if (_dispatchOption == DDObserverDispatchOnMainThread)
        [_target performSelectorOnMainThread: _action withObject: notification waitUntilDone: NO];
}

@end

