//
//  DDTemporaryDirectory.h
//  nsurl
//
//  Created by Dave Dribin on 5/15/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DDTemporaryDirectory : NSObject
{
    NSString * mFullPath;
}


+ (DDTemporaryDirectory *) temporaryDirectory;

- (id) init;

- (NSString *) fullPath;

@end
