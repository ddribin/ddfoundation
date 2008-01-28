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

- (NSMutableArray *) observersForKeyPath: (NSString *) keyPath
                                ofObject: (NSObject *) object;

@end

@implementation DDObserverDispatcher

+ (id) defaultNotifier;
{
    static DDObserverDispatcher * sDefaultNotifier = nil;
    if (sDefaultNotifier == nil)
        sDefaultNotifier = [[DDObserverDispatcher alloc] init];
    return sDefaultNotifier;
}

- (id) init;
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _observedObjects = [[NSMutableDictionary alloc] init];
    
    return self;
}

- (void) dealloc
{
    [self removeAllObservers];
    [_observedObjects release];
    _observedObjects = nil;

    [super dealloc];
}

- (void) addObserver: (id) notificationObserver
            selector: (SEL) selector
          forKeyPath: (NSString *) keyPath
            ofObject: (NSObject *) object;
{
    NSMutableArray * observers = [self observersForKeyPath: keyPath ofObject: object];
    
    if ([observers count] == 0)
    {
        [object addObserver: self
                 forKeyPath: keyPath
                    options: 0
                    context: NULL];
    }
        
    NSArray * oberverContext = [NSArray arrayWithObjects: notificationObserver,
                                  [NSValue valueWithPointer: selector], nil];
    [observers addObject: oberverContext];
}

- (void) removeAllObservers;
{
    NSArray * keys = [_observedObjects allKeys];
    NSArray * observerKeyPath;
    unsigned i;
    for (i = 0; i < [keys count]; i++)
    {
        observerKeyPath = [keys objectAtIndex: i];
        NSString * keyPath = [observerKeyPath objectAtIndex: 0];
        NSObject * object = [observerKeyPath objectAtIndex: 1];
        [object removeObserver: self forKeyPath: keyPath];
    }
    [_observedObjects removeAllObjects];
}

- (void) removeObserver: (id) observer
             forKeyPath: (NSString *) keyPath
               ofObject: (NSObject *) object;
{
    NSMutableArray * observers = [self observersForKeyPath: keyPath ofObject: object];
    
    NSMutableIndexSet * indexesToRemove = [NSMutableIndexSet indexSet];
    NSArray * oberverContext;
    unsigned i;
    for (i = 0; i < [observers count]; i++)
    {
        oberverContext = [observers objectAtIndex: i];
        id observerTest = [oberverContext objectAtIndex: 0];
        if (observer == observerTest)
        {
            [indexesToRemove addIndex: i];
            break;
        }
    }
    [observers removeObjectsAtIndexes: indexesToRemove];
    if ([observers count] == 0)
    {
        [object removeObserver: self forKeyPath: keyPath];
        NSArray * key = [NSArray arrayWithObjects: keyPath, object, nil];
        [_observedObjects removeObjectForKey: key];
    }
}

- (void) removeObserver: (id) observer;
{
    NSArray * keys = [_observedObjects allKeys];
    NSArray * observerKeyPath;
    unsigned i;
    for (i = 0; i < [keys count]; i++)
    {
        observerKeyPath = [keys objectAtIndex: i];
        NSString * keyPath = [observerKeyPath objectAtIndex: 0];
        NSObject * object = [observerKeyPath objectAtIndex: 1];

        NSMutableArray * observers = [self observersForKeyPath: keyPath ofObject: object];
        NSMutableIndexSet * indexesToRemove = [NSMutableIndexSet indexSet];
        int j;
        for (j = 0; j < [observers count]; j++)
        {
            NSArray * oberverContext = [observers objectAtIndex: j];
            id observerTest = [oberverContext objectAtIndex: 0];
            if (observerTest == observer)
            {
                [indexesToRemove addIndex: j];
            }
        }

        [observers removeObjectsAtIndexes: indexesToRemove];
        if ([observers count] == 0)
        {
            [object removeObserver: self forKeyPath: keyPath];
            NSArray * key = [NSArray arrayWithObjects: keyPath, object, nil];
            [_observedObjects removeObjectForKey: key];
        }
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                       change:(NSDictionary *)change context:(void *)context_
{
    NSMutableArray * observers = [self observersForKeyPath: keyPath ofObject: object];
    unsigned i;
    for (i = 0; i < [observers count]; i++)
    {
        NSArray * context = [observers objectAtIndex: i];
        id target = [context objectAtIndex: 0];
        SEL action = [[context objectAtIndex: 1] pointerValue];
    
        [target performSelector: action withObject: object];
    }
}

@end

@implementation DDObserverDispatcher (Private)

- (NSMutableArray *) observersForKeyPath: (NSString *) keyPath
                                ofObject: (NSObject *) object;
{
    NSArray * key = [NSArray arrayWithObjects: keyPath, object, nil];
    NSMutableArray * observers = [_observedObjects objectForKey: key];
    if (observers == nil)
    {
        observers = [NSMutableArray array];
        [_observedObjects setObject: observers forKey: key];
    }
    return observers;
}

@end
