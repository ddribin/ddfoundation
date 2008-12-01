//

#import "SomeTest.h"


#if 0

@implementation SomeTest

- (void)testSomeLongDescription
{
    STFail(@"failed", nil);
}

- (void)testAnotherLongDescription
{
    STFail(@"failed", nil);
}

@end

#elif 0

@implementation SomeTest

DD_TEST(@"some long description")
{
    STFail(@"failed", nil);
}

DD_TEST(@"another long description")
{
    STFail(@"failed", nil);
}

@end

#endif