//

#import "DDDelegateProxyTest.h"
#import "DDDelegateProxy.h"

@protocol DDDelegateProxyTestProtocol

- (void)doSomething;

@optional

- (int)optionalOne;

- (int)optionalTwo;

@end

@interface TestDDDelegate : NSObject <DDDelegateProxyTestProtocol>
{
    int _doSomethingCallCount;
}

@property (readonly) int doSomethingCallCount;

- (void)doSomething;

@end

@implementation TestDDDelegate

@synthesize doSomethingCallCount = _doSomethingCallCount;

- (void)doSomething;
{
    _doSomethingCallCount++;
}

@end


@implementation DDDelegateProxyTest

- (int)optionalOne;
{
    return 43;
}

- (void)testForward
{
    TestDDDelegate * delegate = [[[TestDDDelegate alloc] init] autorelease];
    id<DDDelegateProxyTestProtocol> forwarder = [[DDDelegateProxy alloc] initWithDelegate:delegate
                                                                    defaultImplementation:self];
    [forwarder doSomething];
    [forwarder doSomething];
    STAssertEquals([delegate doSomethingCallCount], 2 ,nil);

    int result;
    result = [forwarder optionalOne];
    STAssertEquals(result, 43, nil);
}

@end
