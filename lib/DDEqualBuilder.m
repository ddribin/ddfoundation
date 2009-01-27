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
