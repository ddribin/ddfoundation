//
//  DDBase64Encoder.h
//  DDFoundation
//
//  Created by Dave Dribin on 9/23/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDAbstractBaseEncoder.h"

@class DDBaseXInputBuffer;

@interface DDBase64Encoder : DDAbstractBaseEncoder
{
    DDBaseXInputBuffer * _inputBuffer;
}

@end
