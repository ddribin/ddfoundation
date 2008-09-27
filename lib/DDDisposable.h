//
//  DDDisposable.h
//  DDFoundation
//
//  Created by Dave Dribin on 9/27/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol DDDisposable

- (void)dd_dispose;

@end

#define DD_USING(_T_, _V_) \
    do { \
        _T_ _V_ = nil; \
        id<DDDisposable> * _O_ = &_V_; \
        @try {

#define DD_USING_END \
        } @finally { \
            [*_O_ dd_dispose]; \
        } \
    } while(0)
