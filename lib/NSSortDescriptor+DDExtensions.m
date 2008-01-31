//
//  NSSortDescriptor+DDExtensions.m
//  textcast
//
//  Created by Dave Dribin on 1/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NSSortDescriptor+DDExtensions.h"


@implementation NSSortDescriptor (DDExtensions)

+ (NSArray *) dd_sortDescriptorsWithKey: (NSString *) key
                              ascending: (BOOL) ascending;
{
    NSSortDescriptor * descriptor = 
        [[NSSortDescriptor alloc] initWithKey: key
                                    ascending: ascending];
    NSArray * descriptors = [NSArray arrayWithObject: descriptor];
    [descriptor release];
    return descriptors;
}

@end
