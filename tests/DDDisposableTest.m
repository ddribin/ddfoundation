//
//  DDDisposableTest.m
//  DDFoundation
//
//  Created by Dave Dribin on 9/27/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import "DDDisposableTest.h"
#import "DDDisposable.h"

@interface TestDisposable : NSObject <DDDisposable>
{
}

- (void)dd_dispose;

@end

@implementation TestDisposable

static int sTotalDisposeCount = 0;

- (void) dd_dispose;
{
    sTotalDisposeCount++;
}

@end

@interface NSFileHandle (DDDisposable) <DDDisposable>

- (void) dd_dispose;

@end

@implementation NSFileHandle (DDDisposable)

- (void) dd_dispose;
{
    [self closeFile];
    sTotalDisposeCount++;
}

@end


@implementation DDDisposableTest

- (void)setUp
{
    _startDisposeCount = sTotalDisposeCount;
}

- (int)disposeCount
{
    return sTotalDisposeCount - _startDisposeCount;
}

- (void)testUsing
{
    DD_USING(TestDisposable *, object)
    {
        object = [[[TestDisposable alloc] init] autorelease];
    } DD_USING_END;
    STAssertEquals([self disposeCount], 1, nil);
}

- (void)testUsingMultiple
{
    DD_USING(TestDisposable *, object1)
    DD_USING(TestDisposable *, object2)
    {
        object1 = [[[TestDisposable alloc] init] autorelease];
        object2 = [[[TestDisposable alloc] init] autorelease];
    } DD_USING_END; DD_USING_END;
    STAssertEquals([self disposeCount], 2, nil);
}

- (void)testDisposableFileHandleCategory
{
    NSFileHandle * h = [NSFileHandle fileHandleForReadingAtPath:@"/dev/random"];
    DD_USING(NSFileHandle *, handle) {
        handle = h;
        (void) [handle readDataOfLength:1];
    } DD_USING_END;
    STAssertEquals([self disposeCount], 1, nil);
    STAssertThrows([h readDataOfLength:1], nil);
    STAssertThrows([h fileDescriptor], nil);
}

@end
