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

- (void) addObserver: (id) notificationObserver
            selector: (SEL) selector
          forKeyPath: (NSString *) keyPath
            ofObject: (id) object;
{
    [object addObserver: self
             forKeyPath: keyPath
                options: 0
                context: NULL];
    [[NSNotificationCenter defaultCenter] addObserver: notificationObserver
                                             selector: selector
                                                 name: DDObserverKeyPathChangedNotification
                                               object: object];
}

- (void) removeObserver: (id) notificationObserver
             forKeyPath: (NSString *) keyPath
               ofObject: (id) object;
{
    [object removeObserver: self forKeyPath: keyPath];
    [[NSNotificationCenter defaultCenter] removeObserver: notificationObserver
                                                    name: DDObserverKeyPathChangedNotification
                                                  object: object];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                       change:(NSDictionary *)change context:(void *)context
{
    [[NSNotificationCenter defaultCenter] postNotificationName: DDObserverKeyPathChangedNotification
                                                        object: object];
}


@end
