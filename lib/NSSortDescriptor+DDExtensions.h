//
//  NSSortDescriptor+DDExtensions.h
//  textcast
//
//  Created by Dave Dribin on 1/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSSortDescriptor (DDExtensions)

+ (NSArray *) dd_sortDescriptorsWithKey: (NSString *) key
                              ascending: (BOOL) ascending;

@end
