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
    
    _observedObjects = [[NSMutableArray alloc] init];
    
    return self;
}

- (void) dealloc
{
    [_observedObjects release];
    _observedObjects = nil;

    [super dealloc];
}

- (void) addObserver: (id) notificationObserver
            selector: (SEL) selector
          forKeyPath: (NSString *) keyPath
            ofObject: (NSObject *) object;
{
    NSArray * context = [NSArray arrayWithObjects: notificationObserver,
                         [NSValue valueWithPointer: selector], nil];
    [object addObserver: self
             forKeyPath: keyPath
                options: 0
                context: context];

    NSArray * observer =  [NSArray arrayWithObjects: object, keyPath, nil];
    [_observedObjects addObject: observer];
}

- (void) removeObserver: (id) notificationObserver
             forKeyPath: (NSString *) keyPath
               ofObject: (NSObject *) object;
{
    [object removeObserver: self forKeyPath: keyPath];

    NSArray * observer =  [NSArray arrayWithObjects: object, keyPath, nil];
    [_observedObjects removeObject: observer];
}

- (void) removeAllObservers;
{
    NSArray * observer;
    NSEnumerator * e = [_observedObjects objectEnumerator];
    while (observer = [e nextObject])
    {
        NSObject * object = [observer objectAtIndex: 0];
        NSString * keyPath = [observer objectAtIndex: 1];
        [object removeObserver: self forKeyPath: keyPath];
    }
}

- (void) removeObserver: (id) notificationObserver;
{
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                       change:(NSDictionary *)change context:(void *)context_
{
    NSArray * context = (NSArray *) context_;
    id target = [context objectAtIndex: 0];
    SEL action = [[context objectAtIndex: 1] pointerValue];
    
    [target performSelector: action withObject: object];
}


@end
