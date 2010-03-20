/*
 * Copyright (c) 2007-2010 Dave Dribin
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

#import <Foundation/Foundation.h>
#include <objc/objc-runtime.h>
#include <execinfo.h>


@interface NSObject (DDPerformDebugger)

- (void)dd_performSelector:(SEL)selector onThread:(NSThread *)thread withObject:(id)argument waitUntilDone:(BOOL)wait modes:(NSArray *)modes;
- (void)dd_performSelector:(SEL)selector withObject:(id)argument afterDelay:(NSTimeInterval)delay inModes:(NSArray *)modes;

@end

@interface DDPerformDebugger : NSObject
{
    id _target;
    SEL _selector;
    id _argument;
    void * _callstack[128];
    int _frames;
}

- (id)initWithTarget:(id)target selector:(SEL)selector argument:(id)argument;

- (void)perform;
- (NSString *)backtrace;
- (NSString *)description;

@end


/******************************************************************************/


@implementation NSObject (DDPerformDebugger)

+ (void)load
{
    if (self != [NSObject class]) {
        return;
    }
    
    const char * enabledString = getenv("DDPerformDebug");
    BOOL enabled = ((enabledString != NULL) &&
                    ((strcmp(enabledString, "1") == 0) || (strcmp(enabledString, "YES") == 0)));
    if (!enabled) {
        return;
    }
    
    Method originalMethod;
    Method replacedMethod;
    
    originalMethod = class_getInstanceMethod(
        self, @selector(performSelector:onThread:withObject:waitUntilDone:modes:));
    replacedMethod = class_getInstanceMethod(
        self, @selector(dd_performSelector:onThread:withObject:waitUntilDone:modes:));
    method_exchangeImplementations(originalMethod, replacedMethod);
    
    originalMethod = class_getInstanceMethod(
        self, @selector(performSelector:withObject:afterDelay:inModes:));
    replacedMethod = class_getInstanceMethod(
        self, @selector(dd_performSelector:withObject:afterDelay:inModes:));
    method_exchangeImplementations(originalMethod, replacedMethod);
}

- (void)dd_performSelector:(SEL)selector onThread:(NSThread *)thread withObject:(id)argument waitUntilDone:(BOOL)wait modes:(NSArray *)modes;
{
    DDPerformDebugger * debugger = [[DDPerformDebugger alloc] initWithTarget:self
                                                                    selector:selector
                                                                    argument:argument];
    [debugger autorelease];
    
    // This calls the original implementation. It's not recursing.
    [debugger dd_performSelector:@selector(perform)
                        onThread:thread
                      withObject:nil
                   waitUntilDone:wait
                           modes:modes];
}

- (void)dd_performSelector:(SEL)selector withObject:(id)argument afterDelay:(NSTimeInterval)delay inModes:(NSArray *)modes;
{
    DDPerformDebugger * debugger = [[DDPerformDebugger alloc] initWithTarget:self
                                                                    selector:selector
                                                                    argument:argument];
    [debugger autorelease];
    
    // This calls the original implementation. It's not recursing.
    [debugger dd_performSelector:@selector(perform)
                      withObject:nil
                      afterDelay:delay
                         inModes:modes];
}

@end


/******************************************************************************/


const char * DDPerformDescription;

@implementation DDPerformDebugger

- (id)initWithTarget:(id)target selector:(SEL)selector argument:(id)argument;
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _target = [target retain];
    _selector = selector;
    _argument = [argument retain];
    // Capture a backtrace at the time we're created
    _frames = backtrace(_callstack, sizeof(_callstack)/sizeof(*_callstack));
    
    return self;
}

- (void)dealloc
{
    [_target release];
    [_argument release];
    [super dealloc];
}

- (void)perform;
{
    NSString * nsDescription = [self description];
    // These  can be useful if 'po self' can't be performed without a deadlock:
    // (gdb) printf "%s", description
    const char * description = [nsDescription UTF8String];
    DDPerformDescription = description;
    [_target performSelector:_selector withObject:_argument];
    DDPerformDescription = NULL;
}

- (NSString *)backtrace;
{
    NSMutableString * backtrace = [NSMutableString string];
    char** strs = backtrace_symbols(_callstack, _frames);
    for (int i = 0; i < _frames; ++i) {
        [backtrace appendFormat:@"%s\n", strs[i]];
    }
    free(strs);
    return backtrace;
}

- (NSString *)description;
{
    NSMutableString * description = [NSMutableString string];
    [description appendFormat:@"<%@ %p: ",[self class], self];
    [description appendFormat:@"target: <%@ %p>, ", [_target class], _target];
    [description appendFormat:@"selector: <%@>, ", NSStringFromSelector(_selector)];
    [description appendFormat:@"argument: <%@ %p>\n", [_argument class], _argument];
    [description appendFormat:@"%@", [self backtrace]];
    
    return description;
}

@end
