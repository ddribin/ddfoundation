//
//  DDInvocationGrabberTest.h
//  DDFoundation
//
//  Created by Dave Dribin on 5/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "DDTestCase.h"

@interface DDInvocationGrabberTest : DDTestCase {
    NSThread * _thread;
    NSCondition * _condition;
}

@end
