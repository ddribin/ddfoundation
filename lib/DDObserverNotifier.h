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

- (void) notify: (id) notificationObserver
       selector: (SEL) selector
     forKeyPath: (NSString *) keyPath
       onObject: (id) object;

@end
