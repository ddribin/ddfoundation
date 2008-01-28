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

#import "DDObserverDispatcherTest.h"
#import "DDObserverDispatcher.h"


@interface DDObserverNotifierTestObject : NSObject
{
    BOOL _flagged;
    BOOL _flagged2;
}

+ (id) object;

- (BOOL) isFlagged;
- (void) setFlagged: (BOOL) flagged;
- (void) toggleFlagged;

- (BOOL) isFlagged2;
- (void) setFlagged2: (BOOL) flagged2;
- (void) toggleFlagged2;


@end

@implementation DDObserverNotifierTestObject

+ (id) object
{
    return [[[self alloc] init] autorelease];
}

- (BOOL) isFlagged { return _flagged; }
- (void) setFlagged: (BOOL) flagged; { _flagged = flagged; }
- (void) toggleFlagged; { [self setFlagged: !_flagged]; }

- (BOOL) isFlagged2 { return _flagged2; }
- (void) setFlagged2: (BOOL) flagged2; { _flagged2 = flagged2; }
- (void) toggleFlagged2; { [self setFlagged2: !_flagged2]; }

@end

@interface DDObserverNotifierTestObserver : NSObject
{
    int _notificationCount;
}

+ (id) observer;

- (void) countNotification: (NSNotification *) note;
- (void) ignoreNotification: (NSNotification *) note;
- (int) notificationCount;

@end

@implementation DDObserverNotifierTestObserver : NSObject

+ (id) observer;
{
    return [[[self alloc] init] autorelease];
}

- (void) countNotification: (NSNotification *) note;
{
    _notificationCount++;
}

- (void) ignoreNotification: (NSNotification *) note;
{
}

- (int) notificationCount;
{
    return _notificationCount;
}

@end

@implementation DDObserverDispatcherTest

- (void) testSimpleAddAndRemoveObserver;
{
    DDObserverNotifierTestObject * object = [DDObserverNotifierTestObject object];
    DDObserverNotifierTestObserver * observer = [DDObserverNotifierTestObserver observer];
    
    [object toggleFlagged];
    STAssertEquals([observer notificationCount], 0, nil);
    
    DDObserverDispatcher * notifier = [[[DDObserverDispatcher alloc] init] autorelease];
    [notifier addObserver: observer
                 selector: @selector(countNotification:)
               forKeyPath: @"flagged" ofObject: object];
    
    [object toggleFlagged];
    [object toggleFlagged2];
    
    STAssertEquals([observer notificationCount], 1, nil);
    
    [notifier removeObserver: observer forKeyPath: @"flagged" ofObject: object];
    [object toggleFlagged];
    [object toggleFlagged2];
    STAssertEquals([observer notificationCount], 1, nil);
}

- (void) testMultipleAddAndRemoveObserver;
{
    DDObserverNotifierTestObject * object = [DDObserverNotifierTestObject object];
    DDObserverNotifierTestObserver * observer = [DDObserverNotifierTestObserver observer];
    
    [object toggleFlagged];
    STAssertEquals([observer notificationCount], 0, nil);
    
    DDObserverDispatcher * notifier = [[[DDObserverDispatcher alloc] init] autorelease];
    [notifier addObserver: observer
                 selector: @selector(countNotification:)
               forKeyPath: @"flagged" ofObject: object];
    [notifier addObserver: observer
                 selector: @selector(countNotification:)
               forKeyPath: @"flagged" ofObject: object];
    [notifier addObserver: observer
                 selector: @selector(ignoreNotification:)
               forKeyPath: @"flagged2" ofObject: object];
    
    [object toggleFlagged];
    [object toggleFlagged2];

    STAssertEquals([observer notificationCount], 2, nil);
    
    [notifier removeObserver: observer forKeyPath: @"flagged" ofObject: object];
    [object toggleFlagged];
    [object toggleFlagged2];
    STAssertEquals([observer notificationCount], 3, nil);
    
    [notifier removeObserver: observer forKeyPath: @"flagged" ofObject: object];
    [object toggleFlagged];
    [object toggleFlagged2];
    STAssertEquals([observer notificationCount], 3, nil);
    
    [notifier removeObserver: observer forKeyPath: @"flagged2" ofObject: object];
    [object toggleFlagged];
    [object toggleFlagged2];
    STAssertEquals([observer notificationCount], 3, nil);
}

- (void) testMultipleObservers;
{
    DDObserverNotifierTestObject * object = [DDObserverNotifierTestObject object];
    DDObserverNotifierTestObserver * observer1 = [DDObserverNotifierTestObserver observer];
    DDObserverNotifierTestObserver * observer2 = [DDObserverNotifierTestObserver observer];
    
    [object toggleFlagged];
    [object toggleFlagged2];
    STAssertEquals([observer1 notificationCount], 0, nil);
    STAssertEquals([observer2 notificationCount], 0, nil);
    
    DDObserverDispatcher * notifier = [[[DDObserverDispatcher alloc] init] autorelease];
    [notifier addObserver: observer1
                 selector: @selector(countNotification:)
               forKeyPath: @"flagged" ofObject: object];
    
    [object toggleFlagged];
    [object toggleFlagged2];
    STAssertEquals([observer1 notificationCount], 1, nil);
    STAssertEquals([observer2 notificationCount], 0, nil);
    
    [notifier removeObserver: observer1 forKeyPath: @"flagged" ofObject: object];
    [object toggleFlagged];
    [object toggleFlagged2];
    STAssertEquals([observer1 notificationCount], 1, nil);
    STAssertEquals([observer2 notificationCount], 0, nil);
}

- (void) testRemoveAllObservers;
{
    DDObserverNotifierTestObject * object = [DDObserverNotifierTestObject object];
    DDObserverNotifierTestObserver * observer1 = [DDObserverNotifierTestObserver observer];
    DDObserverNotifierTestObserver * observer2 = [DDObserverNotifierTestObserver observer];
    
    [object toggleFlagged];
    STAssertEquals([observer1 notificationCount], 0, nil);
    STAssertEquals([observer2 notificationCount], 0, nil);
    
    DDObserverDispatcher * notifier = [[[DDObserverDispatcher alloc] init] autorelease];
    [notifier addObserver: observer1
                 selector: @selector(countNotification:)
               forKeyPath: @"flagged" ofObject: object];
    [notifier addObserver: observer1
                 selector: @selector(countNotification:)
               forKeyPath: @"flagged2" ofObject: object];
    [notifier addObserver: observer2
                 selector: @selector(countNotification:)
               forKeyPath: @"flagged" ofObject: object];
    
    [object toggleFlagged];
    [object toggleFlagged2];
    STAssertEquals([observer1 notificationCount], 2, nil);
    STAssertEquals([observer2 notificationCount], 1, nil);
    
    [notifier removeAllObservers];
    [object toggleFlagged];
    [object toggleFlagged2];
    STAssertEquals([observer1 notificationCount], 2, nil);
    STAssertEquals([observer2 notificationCount], 1, nil);
}

- (void) testRemoveObserver;
{
    DDObserverNotifierTestObject * object = [DDObserverNotifierTestObject object];
    DDObserverNotifierTestObserver * observer1 = [DDObserverNotifierTestObserver observer];
    DDObserverNotifierTestObserver * observer2 = [DDObserverNotifierTestObserver observer];
    
    [object toggleFlagged];
    STAssertEquals([observer1 notificationCount], 0, nil);
    STAssertEquals([observer2 notificationCount], 0, nil);
    
    DDObserverDispatcher * notifier = [[[DDObserverDispatcher alloc] init] autorelease];
    [notifier addObserver: observer1
                 selector: @selector(countNotification:)
               forKeyPath: @"flagged" ofObject: object];
    [notifier addObserver: observer1
                 selector: @selector(countNotification:)
               forKeyPath: @"flagged2" ofObject: object];
    [notifier addObserver: observer2
                 selector: @selector(countNotification:)
               forKeyPath: @"flagged" ofObject: object];
    
    [object toggleFlagged];
    [object toggleFlagged2];
    STAssertEquals([observer1 notificationCount], 2, nil);
    STAssertEquals([observer2 notificationCount], 1, nil);
    
    [notifier removeObserver: observer1];
    [object toggleFlagged];
    [object toggleFlagged2];
    STAssertEquals([observer1 notificationCount], 2, nil);
    STAssertEquals([observer2 notificationCount], 2, nil);
}

@end
