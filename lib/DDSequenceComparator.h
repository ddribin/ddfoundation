//
//  DDSequenceComparator.h
//  DDFoundation
//
//  Created by Dave Dribin on 1/31/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@class DDSequenceComparatorItem;

@interface DDSequenceComparator : NSEnumerator
{
    NSEnumerator * _sourceSequence;
    NSString * _sourceKey;
    NSEnumerator * _finalSequence;
    NSString * _finalKey;

    id _currentSourceObject;
    id _currentFinalObject;
    BOOL _advanceSource;
    BOOL _advanceFinal;
}

+ (id) comparatorWithSourceEnumerator: (NSEnumerator *) sourceEnumerator
                            sourceKey: (NSString *) sourceKey
                      finalEnumerator: (NSEnumerator *) finalEnumerator
                             finalKey: (NSString *) finalKey;

- (id) initWithSourceEnumerator: (NSEnumerator *) sourceEnumerator
                      sourceKey: (NSString *) sourceKey
                finalEnumerator: (NSEnumerator *) finalEnumerator
                       finalKey: (NSString *) finalKey;

- (id) nextObject;

- (id) currentSourceObject;

- (id) currentFinalObject;

@end

#define DDSequenceComparatorDelete NSOrderedAscending
#define DDSequenceComparatorUpdate NSOrderedSame
#define DDSequenceComparatorAdd NSOrderedDescending
