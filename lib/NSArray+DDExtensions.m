//
//  NSArray+DDExtensions.m
//  DDFoundation
//
//  Created by Dave Dribin on 6/28/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NSArray+DDExtensions.h"


NSArray * DDNumberArrayFromIntegerArray(int * integers, int count)
{
    id * numberObjects = alloca(sizeof(id)*count);
    int i;
    for (i = 0; i < count; i++)
    {
        numberObjects[i] = [NSNumber numberWithInt:integers[i]];
    }
    return [NSArray arrayWithObjects:numberObjects count:count];
}

@implementation NSMutableArray (DDExtensions)

- (void)dd_addObjectOrNull:(id)object;
{
    object = object == nil? [NSNull null] : object;
    [self addObject:object];
}

- (void)dd_replaceObjectAtIndex:(unsigned)index withObjectOrNull:(id)object;
{
    object = object == nil? [NSNull null] : object;
    [self replaceObjectAtIndex:index withObject:object];
}

@end
