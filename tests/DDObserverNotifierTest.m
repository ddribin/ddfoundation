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

@end

@implementation DDObserverNotifierTestObject

- (BOOL) isFlagged
{
    return _flagged;
}

- (void) setFlagged: (BOOL) flagged;
{
    _flagged = flagged;
}

@end

@implementation DDObserverNotifierTest

- (void) flaggedChanged: (NSNotification *) note
{
    _notificationSent = YES;
}

- (void) testNotification;
{
    DDObserverNotifierTestObject * object =
        [[[DDObserverNotifierTestObject alloc] init] autorelease];
    [object setFlagged: NO];
    _notificationSent = NO;
    
    DDObserverNotifier * notifier = [[[DDObserverNotifier alloc] init] autorelease];
    [notifier notify: self
            selector: @selector(flaggedChanged:)
          forKeyPath: @"flagged" onObject: object];
    [object setFlagged: YES];

    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate: [NSDate dateWithTimeIntervalSinceNow: .1]];
    STAssertTrue(_notificationSent, nil);
}

@end
