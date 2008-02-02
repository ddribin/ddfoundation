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

@interface DDObserverDispatcher (Private)

- (void) removeObserverForAllKeyPaths: (NSMutableDictionary *) keyPaths
                      ofObjectWrapper: (NSArray *) objectWrapper;

@end

@implementation DDObserverDispatcher

- (id) initWithTarget: (id) target
       dispatchOption: (DDObserverDispatchOption) dispatchOption;
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _target = target;
    _keyPathsByObject = [[NSMutableDictionary alloc] init];
    _dispatchOption = dispatchOption;
    
    return self;
}

- (id) initWithTarget: (id) target;
{
    return [self initWithTarget: target dispatchOption: DDObserverDispatchOnCallingThread];
}

- (id) init;
{
    return [self initWithTarget: nil];
}

- (void) dealloc
{
    [self removeAllDispatchActions];
    [_keyPathsByObject release];
    _keyPathsByObject = nil;

    [super dealloc];
}

- (void) finalize
{
    [self removeAllDispatchActions];
    [super finalize];
}

- (void) setDispatchAction: (SEL) action
                forKeyPath: (NSString *) keyPath
                  ofObject: (NSObject *) object;
{
    @synchronized (self)
    {
        NSArray * objectWrapper = [NSArray arrayWithObject: object];
        NSMutableDictionary * actionsByKeyPath =
            [_keyPathsByObject objectForKey: objectWrapper];
        
        // Create if it does not yet exist
        if (actionsByKeyPath == nil)
        {
            actionsByKeyPath = [NSMutableDictionary dictionary];
            [_keyPathsByObject setObject: actionsByKeyPath forKey: objectWrapper];
        }
        
        if ([actionsByKeyPath objectForKey: keyPath] == nil)
        {
            [actionsByKeyPath setObject:
             [NSValue valueWithPointer: action] forKey: keyPath];
            [object addObserver: self
                     forKeyPath: keyPath
                        options: 0
                        context: NULL];
        }
        else
            [actionsByKeyPath setObject: [NSValue valueWithPointer: action] forKey: keyPath];
    }
}

- (void) removeDispatchActionForKeyPath: (NSString *) keyPath
                               ofObject: (NSObject *) object;
{
    @synchronized (self)
    {
        NSArray * objectWrapper = [NSArray arrayWithObject: object];
        NSMutableDictionary * actionsByKeyPath =
            [_keyPathsByObject objectForKey: objectWrapper];
        
        if ([actionsByKeyPath objectForKey: keyPath] == nil)
            return;
        
        [actionsByKeyPath removeObjectForKey: keyPath];
        [object removeObserver: self forKeyPath: keyPath];
        
        if ([actionsByKeyPath count] == 0)
        {
            [_keyPathsByObject removeObjectForKey: objectWrapper];
        }
    }
}

- (void) removeAllDispatchActions
{
    @synchronized (self)
    {
        NSEnumerator * e = [_keyPathsByObject keyEnumerator];
        NSArray * objectWrapper;
        while (objectWrapper = [e nextObject])
        {
            NSMutableDictionary * keyPaths = [_keyPathsByObject objectForKey: objectWrapper];
            [self removeObserverForAllKeyPaths: keyPaths ofObjectWrapper: objectWrapper];
        }
        [_keyPathsByObject removeAllObjects];
    }
}

- (void) removeAllDispatchActionsOfObject: (NSObject *) object;
{
    @synchronized (self)
    {
        NSArray * objectWrapper = [NSArray arrayWithObject: object];
        NSMutableDictionary * keyPaths = [_keyPathsByObject objectForKey: objectWrapper];
        [self removeObserverForAllKeyPaths: keyPaths ofObjectWrapper: objectWrapper];
        [_keyPathsByObject removeObjectForKey: objectWrapper];
    }
}

-(void) observeValueForKeyPath: (NSString *) keyPath ofObject: (id) object
                       change: (NSDictionary *) change context: (void *) context
{
    NSArray * objectWrapper = [NSArray arrayWithObject: object];
    SEL action;
    @synchronized (self)
    {
        NSMutableDictionary * actionsByKeyPath;
        actionsByKeyPath = [_keyPathsByObject objectForKey: objectWrapper];
        if (actionsByKeyPath == nil)
            return;
    
        NSValue * actionValue = [actionsByKeyPath objectForKey: keyPath];
        if (actionValue == nil)
            return;
        
        action = [actionValue pointerValue];
    }

    if (_dispatchOption == DDObserverDispatchOnMainThreadAndWait)
        [_target performSelectorOnMainThread: action withObject: object waitUntilDone: YES];
    else if (_dispatchOption == DDObserverDispatchOnMainThread)
        [_target performSelectorOnMainThread: action withObject: object waitUntilDone: NO];
    else // (_dispatchOption == DDObserverDispatchOnCallingThread)
        [_target performSelector: action withObject: object];
}

@end

@implementation DDObserverDispatcher (Private)

- (void) removeObserverForAllKeyPaths: (NSMutableDictionary *) keyPaths
                      ofObjectWrapper: (NSArray *) objectWrapper;
{
    NSObject * object = [objectWrapper objectAtIndex: 0];
    NSEnumerator * e = [keyPaths keyEnumerator];
    NSString * keyPath;
    while (keyPath = [e nextObject])
    {
        [object removeObserver: self forKeyPath: keyPath];
    }
}

@end

