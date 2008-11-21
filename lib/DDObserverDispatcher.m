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

#import "DDObserverDispatcher.h"
#import "DDObserverDispatcherEntry.h"
#import "DDObserverNotification.h"


@interface DDObserverDispatcher (Private)

- (void) addDispatchEntry: (DDObserverDispatcherEntry *) entry
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
    [self removeAllDispatchActions];
    [_observerEntries release];
    
    [super dealloc];
}

- (void) finalize
{
    [self removeAllDispatchActions];
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

- (void) setDispatchAction: (SEL) action
                forKeyPath: (NSString *) keyPath
                  ofObject: (NSObject *) object;
{
    [self setDispatchAction:action
                 forKeyPath:keyPath
                   ofObject:object
             dispatchOption:_defaultDispatchOption
                 kvoOptions:_defaultKvoOptions];
}

- (void) setDispatchAction: (SEL) action
                forKeyPath: (NSString *) keyPath
                  ofObject: (NSObject *) object
            dispatchOption: (DDObserverDispatchOption) dispatchOption;
{
    [self setDispatchAction:action
                 forKeyPath:keyPath
                   ofObject:object
             dispatchOption:dispatchOption
                 kvoOptions:_defaultKvoOptions];
}

- (void) setDispatchAction: (SEL) action
                forKeyPath: (NSString *) keyPath
                  ofObject: (NSObject *) object
                kvoOptions: (NSKeyValueObservingOptions) kvoOptions;
{
    [self setDispatchAction:action
                 forKeyPath:keyPath
                   ofObject:object
             dispatchOption:_defaultDispatchOption
                 kvoOptions:kvoOptions];
}

- (void) setDispatchAction: (SEL) action
                forKeyPath: (NSString *) keyPath
                  ofObject: (NSObject *) object
            dispatchOption: (DDObserverDispatchOption) dispatchOption
                kvoOptions: (NSKeyValueObservingOptions) kvoOptions;
{
    DDObserverDispatcherEntry * entry =
    [[DDObserverDispatcherEntry alloc] initWithObserved:object
                                                keyPath:keyPath
                                                 target:_target
                                                 action:action
                                         dispatchOption:dispatchOption];
    [entry autorelease];
    [self addDispatchEntry:entry kvoOptions:kvoOptions];
}

- (void) removeDispatchActionForKeyPath: (NSString *) keyPath
                               ofObject: (NSObject *) object;
{
    @synchronized (self)
    {
        NSEnumerator * entries = [_observerEntries objectEnumerator];
        DDObserverDispatcherEntry * entry;
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

- (void) removeAllDispatchActions
{
    [self removeDispatchActionForKeyPath:nil ofObject:nil];
}

- (void) removeAllDispatchActionsOfObject: (NSObject *) object;
{
    [self removeDispatchActionForKeyPath:nil ofObject:object];
}

@end

@implementation DDObserverDispatcher (Private)

- (void) addDispatchEntry: (DDObserverDispatcherEntry *) entry
               kvoOptions: (NSKeyValueObservingOptions) kvoOptions;
{
    @synchronized (self)
    {
        [self removeDispatchActionForKeyPath:[entry keyPath] ofObject:[entry observed]];
        [_observerEntries addObject:entry];
        [entry startObservingWithOptions:kvoOptions];
    }
}

@end

