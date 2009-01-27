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
