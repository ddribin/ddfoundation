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

@implementation DDObserverDispatcher

- (id) initWithTarget: (id) target;
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _target = target;
    _actionsByKeyPath = [[NSMutableDictionary alloc] init];
    
    return self;
}

- (id) init;
{
    return [self initWithTarget: nil];
}

- (void) dealloc
{
    [self removeAllDispatchActions];
    [_actionsByKeyPath release];
    _actionsByKeyPath = nil;

    [super dealloc];
}

- (void) setDispatchAction: (SEL) action
                forKeyPath: (NSString *) keyPath
                  ofObject: (NSObject *) object;
{
    NSArray * key = [NSArray arrayWithObjects: keyPath, object, nil];
    if ([_actionsByKeyPath objectForKey: key] == nil)
    {
        [_actionsByKeyPath setObject: [NSValue valueWithPointer: action] forKey: key];
        [object addObserver: self
                 forKeyPath: keyPath
                    options: 0
                    context: NULL];
    }
    else
        [_actionsByKeyPath setObject: [NSValue valueWithPointer: action] forKey: key];
}

- (void) removeDispatchActionForKeyPath: (NSString *) keyPath
                               ofObject: (NSObject *) object;
{
    NSArray * key = [NSArray arrayWithObjects: keyPath, object, nil];
    if ([_actionsByKeyPath objectForKey: key] != nil)
    {
        [_actionsByKeyPath removeObjectForKey: key];
        [object removeObserver: self forKeyPath: keyPath];
    }
}

- (void) removeAllDispatchActions
{
    NSEnumerator * e = [_actionsByKeyPath keyEnumerator];
    NSArray * key;
    while (key = [e nextObject])
    {
        NSString * keyPath = [key objectAtIndex: 0];
        NSObject * object = [key objectAtIndex: 1];
        [object removeObserver: self forKeyPath: keyPath];
    }
    [_actionsByKeyPath removeAllObjects];
}

-(void) observeValueForKeyPath: (NSString *) keyPath ofObject: (id) object
                       change: (NSDictionary *) change context: (void *) context
{
    NSArray * key = [NSArray arrayWithObjects: keyPath, object, nil];
    NSValue * actionValue = [_actionsByKeyPath objectForKey: key];
    if (actionValue != nil)
    {
        SEL action = [actionValue pointerValue];
        [_target performSelector: action withObject: object];
    }
}

@end
