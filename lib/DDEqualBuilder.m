//
//  DDEqualBuilder.m
//  DDFoundation
//
//  Created by Dave Dribin on 11/22/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import "DDEqualBuilder.h"


@implementation DDEqualBuilder

+ (id)builder;
{
    id o = [[self alloc] init];
    return [o autorelease];
}

- (id)init;
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _result = YES;
    
    return self;
}

- (BOOL)result;
{
    return _result;
}

- (BOOL)appendInstanceAndKindOf:(id)lhs :(id)rhs;
{
    if (_result)
        _result = (rhs != nil);
    if (_result)
        _result = [rhs isKindOfClass:[lhs class]];
    return _result;
}

- (void)appendObject:(id)lhs :(id)rhs;
{
    if (_result)
        _result = [lhs isEqual:rhs];
}

- (void)appendString:(NSString *)lhs :(NSString *)rhs;
{
    if (_result)
        _result = [lhs isEqualToString:rhs];
}

- (void)appendBool:(BOOL)lhs :(BOOL)rhs;
{
    if (_result)
        _result = (lhs == rhs);
}

@end
