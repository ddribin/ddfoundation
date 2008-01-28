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

- (NSMutableDictionary *) keyPathsForObject: (NSObject *) object;

- (void) removeObserverForAllKeyPaths: (NSMutableDictionary *) keyPaths
                      ofObjectWrapper: (NSArray *) objectWrapper;

@end

@implementation DDObserverDispatcher

- (id) initWithTarget: (id) target;
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _target = target;
    _keyPathsByObject = [[NSMutableDictionary alloc] init];
    
    return self;
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
    NSMutableDictionary * actionsByKeyPath = [self keyPathsForObject: object];
    if ([actionsByKeyPath objectForKey: keyPath] == nil)
    {
        [actionsByKeyPath setObject: [NSValue valueWithPointer: action] forKey: keyPath];
        [object addObserver: self
                 forKeyPath: keyPath
                    options: 0
                    context: NULL];
    }
    else
        [actionsByKeyPath setObject: [NSValue valueWithPointer: action] forKey: keyPath];
}

- (void) removeDispatchActionForKeyPath: (NSString *) keyPath
                               ofObject: (NSObject *) object;
{
    NSMutableDictionary * actionsByKeyPath = [self keyPathsForObject: object];
    if ([actionsByKeyPath objectForKey: keyPath] != nil)
    {
        [actionsByKeyPath removeObjectForKey: keyPath];
        [object removeObserver: self forKeyPath: keyPath];
    }
}

- (void) removeAllDispatchActions
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

- (void) removeAllDispatchActionsOfObject: (NSObject *) object;
{
    NSArray * objectWrapper = [NSArray arrayWithObject: object];
    NSMutableDictionary * keyPaths = [_keyPathsByObject objectForKey: objectWrapper];
    [self removeObserverForAllKeyPaths: keyPaths ofObjectWrapper: objectWrapper];
    [_keyPathsByObject removeObjectForKey: objectWrapper];
}

-(void) observeValueForKeyPath: (NSString *) keyPath ofObject: (id) object
                       change: (NSDictionary *) change context: (void *) context
{
    NSMutableDictionary * keyPaths = [self keyPathsForObject: object];
    NSValue * actionValue = [keyPaths objectForKey: keyPath];
    if (actionValue != nil)
    {
        SEL action = [actionValue pointerValue];
        [_target performSelector: action withObject: object];
    }
}

@end

@implementation DDObserverDispatcher (Private)

- (NSMutableDictionary *) keyPathsForObject: (NSObject *) object;
{
    NSArray * objectWrapper = [NSArray arrayWithObject: object];
    NSMutableDictionary * keyPaths = [_keyPathsByObject objectForKey: objectWrapper];
    if (keyPaths == nil)
    {
        keyPaths = [NSMutableDictionary dictionary];
        [_keyPathsByObject setObject: keyPaths forKey: objectWrapper];
    }
    return keyPaths;
}

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
