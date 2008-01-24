//
//  DDObserverNotifierTest.m
//  DDFoundation
//
//  Created by Dave Dribin on 1/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DDObserverNotifierTest.h"
#import "DDObserverNotifier.h"


@interface DDObserverNotifierTestObject : NSObject
{
    BOOL _flagged;
    BOOL _flagged2;
}

- (BOOL) isFlagged;
- (void) setFlagged: (BOOL) flagged;
- (void) toggleFlagged;

- (BOOL) isFlagged2;
- (void) setFlagged2: (BOOL) flagged2;
- (void) toggleFlagged2;


@end

@implementation DDObserverNotifierTestObject

- (BOOL) isFlagged { return _flagged; }
- (void) setFlagged: (BOOL) flagged; { _flagged = flagged; }
- (void) toggleFlagged; { [self setFlagged: !_flagged]; }

- (BOOL) isFlagged2 { return _flagged2; }
- (void) setFlagged2: (BOOL) flagged2; { _flagged2 = flagged2; }
- (void) toggleFlagged2; { [self setFlagged2: !_flagged2]; }

@end

@implementation DDObserverNotifierTest

- (void) gotNotification: (NSNotification *) note
{
    _notificationsSent++;
}

- (void) ignoreNotification: (NSNotification *) note;
{
}

- (void) setUp
{
    [super setUp];
    _notificationsSent = 0;
}

- (void) testAddAndRemoveObserver;
{
    DDObserverNotifierTestObject * object =
        [[[DDObserverNotifierTestObject alloc] init] autorelease];
    [object setFlagged: NO];
    
    [object toggleFlagged];
    STAssertEquals(_notificationsSent, 0, nil);
    
    DDObserverNotifier * notifier = [[[DDObserverNotifier alloc] init] autorelease];
    [notifier addObserver: self
                 selector: @selector(gotNotification:)
               forKeyPath: @"flagged" ofObject: object];
    [notifier addObserver: self
                 selector: @selector(ignoreNotification:)
               forKeyPath: @"flagged2" ofObject: object];
    
    [object toggleFlagged];
    [object toggleFlagged2];

    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate: [NSDate date]];
    STAssertEquals(_notificationsSent, 1, nil);
    
    [notifier removeObserver: self forKeyPath: @"flagged" ofObject: object];
    [object toggleFlagged];
    [object toggleFlagged2];
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate: [NSDate date]];
    STAssertEquals(_notificationsSent, 1, nil);
    
    [notifier removeObserver: self forKeyPath: @"flagged2" ofObject: object];
    [object toggleFlagged];
    [object toggleFlagged2];
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate: [NSDate date]];
    STAssertEquals(_notificationsSent, 1, nil);
}

@end
