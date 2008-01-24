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
}

- (BOOL) isFlagged;
- (void) setFlagged: (BOOL) flagged;
- (void) toggleFlagged;

@end

@implementation DDObserverNotifierTestObject

- (BOOL) isFlagged { return _flagged; }
- (void) setFlagged: (BOOL) flagged; { _flagged = flagged; }
- (void) toggleFlagged; { [self setFlagged: !_flagged]; }

@end

@implementation DDObserverNotifierTest

- (void) gotNotification: (NSNotification *) note
{
    _notificationsSent++;
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
    
    [object toggleFlagged];

    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate: [NSDate date]];
    STAssertEquals(_notificationsSent, 1, nil);
    
    [notifier removeObserver: self forKeyPath: @"flagged" ofObject: object];
    [object toggleFlagged];
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate: [NSDate date]];
    STAssertEquals(_notificationsSent, 1, nil);
}

@end
