//

#import <Foundation/Foundation.h>


@interface DDDelegateProxy : NSObject
{
    id _delegate;
    id _defaultImplementation;
}

- (id)initWithDelegate:(id)delegate defaultImplementation:(id)defaultImplementation;

@end
