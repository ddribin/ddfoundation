//
//  DDObserverNotifier.m
//  DDFoundation
//
//  Created by Dave Dribin on 1/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DDObserverNotifier.h"

@implementation DDObserverNotifier

NSString * DDObserverKeyPathChangedNotification = @"DDObserverKeyPathChanged";

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
    NSLog(@"addObserver Observers: %@", _observedObjects);
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
    NSLog(@"Observers: %@", _observedObjects);
    NSMutableArray * observers = [self observersForKeyPath: keyPath ofObject: object];
    
    NSMutableIndexSet * indexesToRemove = [NSMutableIndexSet indexSet];
    NSArray * oberverContext;
    unsigned i;
    for (i = 0; i < [observers count]; i++)
    {
        oberverContext = [observers objectAtIndex: i];
        NSLog(@"Remove observer: %@, test: %@", observer, oberverContext);
        id observerTest = [oberverContext objectAtIndex: 0];
        if (observer == observerTest)
        {
            NSLog(@"Remove: %@", observer);
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

    NSLog(@"Observers post: %@", _observedObjects);
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
