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

#import "DDObserverNotification.h"


@implementation DDObserverNotification

+ (id)notificationWithObject:(NSObject *)object
                     keyPath:(NSString *)keyPath
                      change:(NSDictionary *)change;
{
    id o = [[self alloc] initWithObject:object keyPath:keyPath change:change];
    return [o autorelease];
}

- (id)initWithObject:(NSObject *)object
             keyPath:(NSString *)keyPath
              change:(NSDictionary *)change;
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _object = [object retain];
    _keyPath = [keyPath copy];
    _change = [change copy];
    
    return self;
}

- (void)dealloc
{
    [_change release];
    [_keyPath release];
    [_object release];
    
    [super dealloc];
}

- (id)object;
{
    return _object;
}

- (NSString *)keyPath;
{
    return _keyPath;
}

- (NSDictionary *)change;
{
    return _change;
}

@end
