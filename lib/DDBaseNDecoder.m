//
//  DDBaseNDecoder.m
//  DDFoundation
//
//  Created by Dave Dribin on 9/29/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import "DDBaseNDecoder.h"


@implementation DDBaseNDecoder

- (id)initWithInputBuffer:(DDBaseNInputBuffer *)inputBuffer;
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _inputBuffer = [inputBuffer retain];
    _outputBuffer = [[NSMutableData alloc] init];
    
    return self;
}

- (void)dealloc
{
    [_outputBuffer release];
    [_inputBuffer release];
    [super dealloc];
}

@end
