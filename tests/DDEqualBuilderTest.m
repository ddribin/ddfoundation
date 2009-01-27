/*
 * Copyright (c) 2007-2009 Dave Dribin
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

#import "DDEqualBuilderTest.h"
#import "DDEqualBuilder.h"

@interface TestBuilderObject : NSObject
{
    NSString * name;
    NSUInteger age;
}

@property (copy) NSString * name;
@property NSUInteger age;

- (BOOL)isEqual:(id)rhs;

@end

@implementation TestBuilderObject

@synthesize name, age;

- (BOOL)isEqual:(id)object
{
    if (self == object)
        return YES;
    
    DDEqualBuilder * b = [DDEqualBuilder builder];
    if (![b appendInstanceAndKindOf:self :object])
        return NO;

    TestBuilderObject * rhs = object;
    [b appendString:name :rhs->name];
    [b appendBool:age :rhs->age];
    return [b result];
}

@end


@implementation DDEqualBuilderTest

- (void)setUp
{
    _builder = [DDEqualBuilder builder];
}

- (void)testSameInstance;
{
    NSString * o = [NSString stringWithString:@"foo"];
    
    BOOL result = [_builder appendInstanceAndKindOf:o :o];

    STAssertTrue(result, nil);
    STAssertTrue([_builder result], nil);
}

- (void)testDifferentInstance;
{
    NSString * o1 = [NSString stringWithString:@"foo"];
    NSString * o2 = [NSString stringWithString:@"bar"];
    
    [_builder appendInstanceAndKindOf:o1 :o2];

    STAssertTrue([_builder result], nil);
}

- (void)testNil
{
    id o1 = [NSString stringWithString:@"foo"];
    id o2 = nil;
    
    BOOL result = [_builder appendInstanceAndKindOf:o1 :o2];
    
    STAssertFalse(result, nil);
    STAssertFalse([_builder result], nil);
}

- (void)testSubclasses
{
    id o1 = [NSString stringWithString:@"foo"];
    id o2 = [NSMutableString stringWithString:@"bar"];
    
    BOOL result = [_builder appendInstanceAndKindOf:o1 :o2];
    
    STAssertTrue(result, nil);
    STAssertTrue([_builder result], nil);
}

- (void)testDifferentClasses;
{
    NSString * o1 = [NSString stringWithString:@"foo"];
    NSNumber * o2 = [NSNumber numberWithInt:1];
    
    BOOL result = [_builder appendInstanceAndKindOf:o1 :o2];
    
    STAssertFalse(result, nil);
    STAssertFalse([_builder result], nil);
}

- (void)testAppendBoolTrue
{
    [_builder appendBool:YES :YES];
    
    STAssertTrue([_builder result], nil);
}

- (void)testAppendDoubleBoolTrue
{
    [_builder appendBool:YES :YES];
    [_builder appendBool:YES :YES];
    
    STAssertTrue([_builder result], nil);
}

- (void)testAppendBoolFalse
{
    [_builder appendBool:YES :NO];
    [_builder appendBool:YES :YES];
    
    STAssertFalse([_builder result], nil);
}

- (void)testAppendObjectTrue
{
    id o1 = [NSString stringWithString:@"foo"];
    id o2 = [NSString stringWithString:@"foo"];
    
    [_builder appendObject:o1 :o2];
    [_builder appendBool:YES :YES];
    
    STAssertTrue([_builder result], nil);
}

- (void)testAppendObjectFalse
{
    id o1 = [NSString stringWithString:@"foo"];
    id o2 = [NSString stringWithString:@"bar"];
    
    [_builder appendObject:o1 :o2];
    [_builder appendBool:YES :YES];
    
    STAssertFalse([_builder result], nil);
}

- (void)testLHSObjectNil
{
    id o1 = nil;
    id o2 = [NSString stringWithString:@"bar"];
    
    [_builder appendObject:o1 :o2];
    [_builder appendBool:YES :YES];
    
    STAssertFalse([_builder result], nil);
}

- (void)testRHSObjectNil
{
    id o1 = [NSString stringWithString:@"foo"];
    id o2 = nil;
    
    [_builder appendObject:o1 :o2];
    [_builder appendBool:YES :YES];
    
    STAssertFalse([_builder result], nil);
}

- (void)testBothObjectNil
{
    id o1 = nil;
    id o2 = nil;
    
    [_builder appendObject:o1 :o2];
    [_builder appendBool:YES :YES];
    
    STAssertFalse([_builder result], nil);
}

- (void)testAppendStringTrue
{
    NSString * o1 = [NSString stringWithString:@"foo"];
    NSString * o2 = [NSString stringWithString:@"foo"];
    
    [_builder appendString:o1 :o2];
    [_builder appendBool:YES :YES];
    
    STAssertTrue([_builder result], nil);
}

- (void)testAppendStringFalse
{
    NSString * o1 = [NSString stringWithString:@"foo"];
    NSString * o2 = [NSString stringWithString:@"bar"];
    
    [_builder appendString:o1 :o2];
    [_builder appendBool:YES :YES];
    
    STAssertFalse([_builder result], nil);
}

- (void)testInObjectTrue
{
    TestBuilderObject * o1 = [[[TestBuilderObject alloc] init] autorelease];
    o1.name = @"Joe Schmoe";
    o1.age = 35;

    TestBuilderObject * o2 = [[[TestBuilderObject alloc] init] autorelease];
    o2.name = @"Joe Schmoe";
    o2.age = 35;
    
    STAssertTrue([o1 isEqual:o2], nil);
}

- (void)testInObjectFalse
{
    TestBuilderObject * o1 = [[[TestBuilderObject alloc] init] autorelease];
    o1.name = @"Joe Schmoe";
    o1.age = 35;
    
    TestBuilderObject * o2 = [[[TestBuilderObject alloc] init] autorelease];
    o2.name = @"Mickey Mouse";
    o2.age = 30;
    
    STAssertFalse([o1 isEqual:o2], nil);
}

@end
