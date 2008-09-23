//
//  DDBase64Encoder.h
//  DDFoundation
//
//  Created by Dave Dribin on 9/23/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDAbstractBaseEncoder.h"


@interface DDBase64Encoder : DDAbstractBaseEncoder
{
    // A 24-bit buffer. Holds 3 octest and 4 groups.
    uint32_t _buffer;
}

@end
