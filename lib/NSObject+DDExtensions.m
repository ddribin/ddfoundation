//
//  NSObject+DDExtensions.m
//  DDFoundation
//
//  Created by Dave Dribin on 5/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NSObject+DDExtensions.h"
#import "DDInvocationGrabber.h"

@implementation NSObject (DDExtensions)

- (id)dd_invokeOnMainThread;
{
    return [self dd_invokeOnMainThreadAndWaitUntilDone:YES];
}

- (id)dd_invokeOnMainThreadAndWaitUntilDone:(BOOL)waitUntilDone;
{
    DDInvocationGrabber * grabber = [DDInvocationGrabber invocationGrabber];
    [grabber setForwardInvokesOnMainThread:YES];
    [grabber setWaitUntilDone:YES];
    return [grabber prepareWithInvocationTarget:self];
}

@end
