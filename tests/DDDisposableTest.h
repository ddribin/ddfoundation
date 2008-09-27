//
//  DDDisposableTest.h
//  DDFoundation
//
//  Created by Dave Dribin on 9/27/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "DDTestCase.h"

@interface DDDisposableTest : DDTestCase {
    int _startDisposeCount;
}

@end
