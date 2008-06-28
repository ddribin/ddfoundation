//
//  NSArray+DDExtensions.h
//  DDFoundation
//
//  Created by Dave Dribin on 6/28/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#define ddarray(OBJS...)     ({id objs[]={OBJS}; \
    [NSArray arrayWithObjects: objs count: sizeof(objs)/sizeof(id)];})

#define ddmarray(OBJS...)    ({id objs[]={OBJS}; \
    [NSMutableArray arrayWithObjects: objs count: sizeof(objs)/sizeof(id)];})

#define ddint_array(_INTS_...) ({ int _ints[] = {_INTS_}; \
    DDNumberArrayFromIntegerArray(_ints, sizeof(_ints)/sizeof(int)); })

NSArray * DDNumberArrayFromIntegerArray(int * days, int count);

@interface NSMutableArray (DDExtensions)

- (void)dd_addObjectOrNull:(id)object;
- (void)dd_replaceObjectAtIndex:(unsigned)index withObjectOrNull:(id)object;

@end
