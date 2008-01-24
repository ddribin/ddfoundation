//
//  DDObserverNotifier.m
//  DDFoundation
//
//  Created by Dave Dribin on 1/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DDObserverNotifier.h"

@interface DDObserverNotifierSetInfo : NSObject
{
    NSObject * _object;
    NSString * _keyPath;
}

+ (id) infoWithObject: (NSObject *) object keyPath: (NSString *) keyPath;

- (id) initWithObject: (NSObject *) object keyPath: (NSString *) keyPath;

@end

@implementation DDObserverNotifierSetInfo

+ (id) infoWithObject: (NSObject *) object keyPath: (NSString *) keyPath;
{
    return [[[self alloc] initWithObject: object keyPath: keyPath] autorelease];
}

- (id) initWithObject: (NSObject *) object keyPath: (NSString *) keyPath;
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _object = [object retain];
    _keyPath = [keyPath retain];
    
    return self;
}

- (void) dealloc
{
    [_object release];
    [_keyPath release];
    
    _object = nil;
    _keyPath = nil;
    
    [super dealloc];
}

@end

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

- (NSCountedSet *) keyPathsOfObject: (NSObject *) object;
{
#if 0
    NSCountedSet * keyPaths = [mObservedObjects objectForKey: object];
    NSLog(@"keyPaths: %@", keyPaths);
    if (keyPaths == nil)
    {
        keyPaths = [[[NSCountedSet alloc] init] autorelease];
        NSLog(@"keyPaths: %@", keyPaths);
        [mObservedObjects setObject: keyPaths forKey: object];
    }
    NSLog(@"keyPaths: %@", keyPaths);
    return keyPaths;
#else
    return nil;
#endif
}

- (NSString *) notificationForKeyPath: (NSString *) keyPath;
{
    return [NSString stringWithFormat: @"DDObserverNotification %@", keyPath];
}

- (void) addObserver: (id) notificationObserver
            selector: (SEL) selector
          forKeyPath: (NSString *) keyPath
            ofObject: (NSObject *) object;
{
    [object addObserver: self
             forKeyPath: keyPath
                options: 0
                context: NULL];
    
    NSString * name = [self notificationForKeyPath: keyPath];
    [[NSNotificationCenter defaultCenter] addObserver: notificationObserver
                                             selector: selector
                                                 name: name
                                               object: object];
}

- (void) removeObserver: (id) notificationObserver
             forKeyPath: (NSString *) keyPath
               ofObject: (NSObject *) object;
{
    NSString * name = [self notificationForKeyPath: keyPath];
    [[NSNotificationCenter defaultCenter] removeObserver: notificationObserver
                                                    name: name
                                                  object: object];
   
    [object removeObserver: self forKeyPath: keyPath];
}

- (void) removeObserver: (id) notificationObserver;
{
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                       change:(NSDictionary *)change context:(void *)context
{
    NSString * name = [self notificationForKeyPath: keyPath];
    [[NSNotificationCenter defaultCenter] postNotificationName: name
                                                        object: object];
}


@end
