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

#import "DDObserverDispatcher.h"
#import "DDObserverEntry.h"
#import "DDObserverNotification.h"


@interface DDObserverDispatcher (Private)

- (void) addDispatchEntry: (DDObserverEntry *) entry
               kvoOptions: (NSKeyValueObservingOptions) kvoOptions;

@end

@implementation DDObserverDispatcher

- (id) initWithTarget: (id) target
defaultDispatchOption: (DDObserverDispatchOption) dispatchOption;
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _target = target;
    _observerEntries = [[NSMutableArray alloc] init];
    _defaultDispatchOption = dispatchOption;
    _defaultKvoOptions = 0;
    
    return self;
}

- (id) initWithTarget: (id) target;
{
    return [self initWithTarget: target
          defaultDispatchOption: DDObserverDispatchOnCallingThread];
}

- (id) init;
{
    return [self initWithTarget: nil];
}

- (void) dealloc
{
    [self stopObservingAll];
    [_observerEntries release];
    
    [super dealloc];
}

- (void) finalize
{
    [self stopObservingAll];
    [super finalize];
}

#pragma mark -

- (void)setDefaultKvoOptions: (NSKeyValueObservingOptions) kvoOptions;
{
    _defaultKvoOptions = kvoOptions;
}

- (NSKeyValueObservingOptions)defaultKvoOptions;
{
    return _defaultKvoOptions;
}

#pragma mark -

- (void)startObserving:(NSObject *)object
               keyPath:(NSString *)keyPath
                action:(SEL)action;
{
    [self startObserving:object
                 keyPath:keyPath
                  action:action
          dispatchOption:_defaultDispatchOption
              kvoOptions:_defaultKvoOptions];
}

- (void)startObserving:(NSObject *)object
               keyPath:(NSString *)keyPath
                action:(SEL)action
        dispatchOption:(DDObserverDispatchOption)dispatchOption;
{
    [self startObserving:object
                 keyPath:keyPath
                  action:action
          dispatchOption:dispatchOption
              kvoOptions:_defaultKvoOptions];
}

- (void)startObserving:(NSObject *)object
               keyPath:(NSString *)keyPath
                action:(SEL)action
            kvoOptions:(NSKeyValueObservingOptions)kvoOptions;
{
    [self startObserving:object
                 keyPath:keyPath
                  action:action
          dispatchOption:_defaultDispatchOption
              kvoOptions:kvoOptions];
}

- (void)startObserving:(NSObject *)object
               keyPath:(NSString *)keyPath
                action:(SEL)action
        dispatchOption:(DDObserverDispatchOption)dispatchOption
            kvoOptions:(NSKeyValueObservingOptions)kvoOptions;
{
    DDObserverEntry * entry =
        [[DDObserverEntry alloc] initWithObserved:object
                                          keyPath:keyPath
                                           target:_target
                                           action:action
                                   dispatchOption:dispatchOption];
    [entry autorelease];
    [self addDispatchEntry:entry kvoOptions:kvoOptions];
}

#pragma mark -

- (void)stopObservingAll;
{
    [self stopObserving:nil keyPath:nil];
}

- (void)stopObserving:(NSObject *)object;
{
    [self stopObserving:object keyPath:nil];
}

- (void)stopObserving:(NSObject *)object keyPath:(NSString *)keyPath;
{
    @synchronized (self)
    {
        NSEnumerator * entries = [_observerEntries objectEnumerator];
        DDObserverEntry * entry;
        NSMutableArray * entriesToRemove = [NSMutableArray array];
        while ((entry = [entries nextObject]) != nil)
        {
            if ([entry matchesObserved:object keyPath:keyPath])
            {
                [entry stopObserving];
                [entriesToRemove addObject:entry];
            }
        }
        
        [_observerEntries removeObjectsInArray:entriesToRemove];
    }
}

@end

@implementation DDObserverDispatcher (Private)

- (void) addDispatchEntry: (DDObserverEntry *) entry
               kvoOptions: (NSKeyValueObservingOptions) kvoOptions;
{
    @synchronized (self)
    {
        [self stopObserving:[entry observed] keyPath:[entry keyPath]];
        [_observerEntries addObject:entry];
        [entry startObservingWithOptions:kvoOptions];
    }
}

@end

