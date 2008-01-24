//
//  DDObserverNotifier.h
//  DDFoundation
//
//  Created by Dave Dribin on 1/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DDObserverNotifier : NSObject
{
    NSMutableDictionary * _observedObjects;
}

- (void) addObserver: (id) notificationObserver
            selector: (SEL) selector
          forKeyPath: (NSString *) keyPath
            ofObject: (id) object;

- (void) removeObserver: (id) notificationObserver
             forKeyPath: (NSString *) keyPath
               ofObject: (id) object;

@end

extern NSString * DDObserverKeyPathChangedNotification;
