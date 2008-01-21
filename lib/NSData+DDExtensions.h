//
//  NSData+DDExtensions.h
//  nsurl
//
//  Created by Dave Dribin on 5/14/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableData (DDExtensions)

- (void) dd_appendUTF8String: (NSString *) string;
- (void) dd_appendUTF8Format: (NSString *) format, ...;

@end
