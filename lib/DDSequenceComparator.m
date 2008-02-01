/*
 * Copyright (c) 2007-2008 Dave Dribin
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

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
