//
//  DDInvocationGrabberTest.m
//  DDFoundation
//
//  Created by Dave Dribin on 5/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DDInvocationGrabberTest.h"
#import "DDInvocationGrabber.h"


@implementation DDInvocationGrabberTest

- (void)testGrabbingValidMethod
{
    NSMutableString *theString = [NSMutableString stringWithString:@""];
    STAssertEqualObjects(theString, @"", @"Inital test data wasn't what we expected.");
    
    DDInvocationGrabber *theGrabber = [DDInvocationGrabber invocationGrabber];
    
    STAssertNotNil(theGrabber, @"Didn't create a grabber.");
    
    [[theGrabber prepareWithInvocationTarget:theString] appendString:@"Hello World"];
    
    STAssertEquals([theGrabber target], theString, @"Target of the grabber isn't what we expected.");
    
    [[theGrabber invocation] invoke];
    
    STAssertEqualObjects(theString, @"Hello World", @"Result of invoking didn't change the test data how we expected.");
}

- (void)testGrabbingInvalidMethod
{
    @try
	{
        NSMutableString *theString = [NSMutableString stringWithString:@""];
        DDInvocationGrabber *theGrabber = [DDInvocationGrabber invocationGrabber];
        [[theGrabber prepareWithInvocationTarget:theString] addObject:@"Hello World"];
        STAssertEquals([theGrabber target], theString, @"Target of the grabber isn't what we expected.");
        [[theGrabber invocation] invoke];
        
        STFail(@"We should have thrown an exception.");
	}
    @catch (NSException *localException)
	{
	}
    @finally
	{
	}
}

@end
