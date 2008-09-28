//
//  DDBase64Encoder.m
//  DDFoundation
//
//  Created by Dave Dribin on 9/23/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import "DDBase64Encoder.h"
#import "DDBaseXInputBuffer.h"
#import "DDBaseXOutputBuffer.h"


static const int kMaxByteIndex = 2;
static const int kMaxGroupIndex = 3;

@implementation DDBase64Encoder

- (id)initWithOptions:(DDBaseEncoderOptions)options;
{
    return [super initWithOptions:options inputBuffer:[DDBaseXInputBuffer base64InputBuffer]];
}

@end
