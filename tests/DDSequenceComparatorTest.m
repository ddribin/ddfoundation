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

#import "DDSequenceComparatorTest.h"
#import "DDSequenceComparator.h"


#define DIM(_X_) (sizeof(_X_)/sizeof(_X_[0]))

static int A = DDSequenceComparatorAdd;
static int D = DDSequenceComparatorDelete;
static int U = DDSequenceComparatorUpdate;

@implementation DDSequenceComparatorTest

static NSEnumerator * sequenceOfStrings(NSArray * strings, NSString * key)
{
    NSMutableArray * arrayOfStrings = [NSMutableArray array];
    for (NSString * string in strings)
    {
        NSDictionary * item = [NSDictionary dictionaryWithObject: string forKey: key];
        [arrayOfStrings addObject: item];
    }
    return [arrayOfStrings objectEnumerator];
}

static DDSequenceComparator * newComparator(NSArray * sourceArray, NSString * sourceKey,
                                            NSArray * finalArray, NSString * finalKey)
{
    NSEnumerator * finalSequence = sequenceOfStrings(finalArray, @"title");
    
    NSEnumerator * sourceSequence = sequenceOfStrings(sourceArray, @"name");
    
    DDSequenceComparator * comparator =
        [[DDSequenceComparator alloc] initWithSourceEnumerator: sourceSequence
                                                     sourceKey: @"name"
                                               finalEnumerator: finalSequence
                                                      finalKey: @"title"];
    return comparator;
}

#define RUN_COMPARISON(_S_, _F_, _R_) \
{ \
    DDSequenceComparator * comparator = newComparator(_S_, @"name", _F_, @"title"); \
    size_t i = 0;\
    NSNumber * comparisonValue;\
    while (comparisonValue = [comparator nextObject])\
    {\
        NSComparisonResult actualResult = [comparisonValue intValue];\
        STAssertEquals(actualResult, expectedResults[i], [NSString stringWithFormat: @"i = %d", i]);\
        i++;\
    }\
    STAssertEquals(i, DIM(expectedResults), nil);\
    [comparator release];\
}

- (void) testDeletingMiddleItems;
{
    NSArray * sourceArray = [NSArray arrayWithObjects: @"A", @"B", @"C", @"D", @"E", nil];
    NSArray * finalArray = [NSArray arrayWithObjects:  @"A",       @"C",       @"E", nil];
    NSComparisonResult expectedResults[] = {U,D,U,D,U};
    RUN_COMPARISON(sourceArray, finalArray, expectedResults);
}

- (void) testDeletingStartingItems;
{
    NSArray * sourceArray = [NSArray arrayWithObjects: @"A", @"B", @"C", @"D", @"E", nil];
    NSArray * finalArray = [NSArray arrayWithObjects:              @"C", @"D", @"E", nil];
    NSComparisonResult expectedResults[] = {D,D,U,U,U};
    RUN_COMPARISON(sourceArray, finalArray, expectedResults);
}

- (void) testDeletingEndingtems;
{
    NSArray * sourceArray = [NSArray arrayWithObjects: @"A", @"B", @"C", @"D", @"E", nil];
    NSArray * finalArray = [NSArray arrayWithObjects:  @"A", @"B", @"C",             nil];
    NSComparisonResult expectedResults[] = {U,U,U,D,D};
    RUN_COMPARISON(sourceArray, finalArray, expectedResults);
}

- (void) testAddingMiddleItems;
{
    NSArray * sourceArray = [NSArray arrayWithObjects: @"A",       @"C",       @"E", nil];
    NSArray * finalArray = [NSArray arrayWithObjects:  @"A", @"B", @"C", @"D", @"E", nil];
    NSComparisonResult expectedResults[] = {U,A,U,A,U};
    RUN_COMPARISON(sourceArray, finalArray, expectedResults);
}

- (void) testAddingStartingItems;
{
    NSArray * sourceArray = [NSArray arrayWithObjects:            @"C",  @"D", @"E", nil];
    NSArray * finalArray = [NSArray arrayWithObjects:  @"A", @"B", @"C", @"D", @"E", nil];
    NSComparisonResult expectedResults[] = {A,A,U,U,U};
    RUN_COMPARISON(sourceArray, finalArray, expectedResults);
}

- (void) testAddingEndingItems;
{
    NSArray * sourceArray = [NSArray arrayWithObjects: @"A", @"B", @"C",             nil];
    NSArray * finalArray = [NSArray arrayWithObjects:  @"A", @"B", @"C", @"D", @"E", nil];
    NSComparisonResult expectedResults[] = {U,U,U,A,A};
    RUN_COMPARISON(sourceArray, finalArray, expectedResults);
}

- (void) testComplexComparisons
{
    NSArray * sourceArray = [NSArray arrayWithObjects:       @"B", @"C",             nil];
    NSArray * finalArray = [NSArray arrayWithObjects:  @"A", @"B",       @"D", @"E", nil];
    NSComparisonResult expectedResults[] = {A,U,D,A,A};
    RUN_COMPARISON(sourceArray, finalArray, expectedResults);
}

@end
