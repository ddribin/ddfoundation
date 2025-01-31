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

#import <Foundation/Foundation.h>


NSString * DDMimeTypeForExtension(NSString * extension);
NSString * DDNSStringFromBOOL(BOOL b);

@interface NSString (DDExtensions)

+ (NSString *) dd_stringFromOSType:(OSType)type;

+ (NSString *) dd_stringWithUtf8Data:(NSData *)data;

- (NSString *) dd_pathMimeType;

- (OSType) dd_osType;

- (NSData *) dd_utf8Data;

@end

#define ddsprintf(FORMAT, ARGS... )  [NSString stringWithFormat: (FORMAT), ARGS]

NSString * DDToStringFromTypeAndValue(const char * typeCode, void * value);

#define DDToNString(_X_) ({typeof(_X_) _Y_ = (_X_);\
    DDToStringFromTypeAndValue(@encode(typeof(_X_)), &_Y_);})

