//
//  DDSequenceComparator.m
//  DDFoundation
//
//  Created by Dave Dribin on 1/31/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DDSequenceComparator.h"


@implementation DDSequenceComparator

+ (id) comparatorWithSourceEnumerator: (NSEnumerator *) sourceEnumerator
                            sourceKey: (NSString *) sourceKey
                      finalEnumerator: (NSEnumerator *) finalEnumerator
                             finalKey: (NSString *) finalKey;
{
    id comparator = 
        [[self alloc] initWithSourceEnumerator: sourceEnumerator
                                     sourceKey: (NSString *) sourceKey
                               finalEnumerator: finalEnumerator
                                      finalKey: (NSString *) finalKey];
    return [comparator autorelease];
}

- (id) initWithSourceEnumerator: (NSEnumerator *) sourceEnumerator
                      sourceKey: (NSString *) sourceKey
                finalEnumerator: (NSEnumerator *) finalEnumerator
                       finalKey: (NSString *) finalKey;
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _sourceSequence = [sourceEnumerator retain];
    _sourceKey = [sourceKey retain];
    _finalSequence = [finalEnumerator retain];
    _finalKey = [finalKey retain];
    
    _advanceSource = YES;
    _advanceFinal = YES;
    
    return self;
}

- (id) nextObject;
{
    NSAssert((_advanceSource == YES) || (_advanceFinal == YES),
             @"Must advance at least one sequence");

    if (_advanceSource)
    {
        [_currentSourceObject release];
        _currentSourceObject = [[_sourceSequence nextObject] retain];
    }
    if (_advanceFinal)
    {
        [_currentFinalObject release];
        _currentFinalObject = [[_finalSequence nextObject] retain];
    }
    
    if ((_currentSourceObject == nil) && (_currentFinalObject == nil))
        return nil;

    NSComparisonResult result;
    if (_currentSourceObject == nil)
    {
        result = DDSequenceComparatorAdd;
    }
    else if (_currentFinalObject == nil)
    {
        result = DDSequenceComparatorDelete;
    }
    else
    {
        id sourceValue = [_currentSourceObject valueForKey: _sourceKey];
        id finalValue = [_currentFinalObject valueForKey: _finalKey];
        NSLog(@"sourceValue: %@, finalValue: %@", sourceValue, finalValue);
        result = [sourceValue compare: finalValue];
    }

    if (result == DDSequenceComparatorAdd)
    {
        _advanceSource = NO;
        _advanceFinal = YES;
    }
    else if (result == DDSequenceComparatorDelete)
    {
        _advanceSource = YES;
        _advanceFinal = NO;
    }
    else
    {
        _advanceSource = YES;
        _advanceFinal = YES;
    }
    NSLog(@"Result: %d", result);
    
    return [NSNumber numberWithInt: result];
}

- (id) currentSourceObject;
{
    return _currentSourceObject;
}

- (id) currentFinalObject;
{
    return _currentFinalObject;
}

@end
