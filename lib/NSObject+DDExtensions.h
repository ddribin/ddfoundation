//
//  NSObject+DDExtensions.h
//  DDFoundation
//
//  Created by Dave Dribin on 5/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (DDExtensions)

- (id)dd_invokeOnMainThread;
- (id)dd_invokeOnMainThreadAndWaitUntilDone:(BOOL)waitUntilDone;

@end
