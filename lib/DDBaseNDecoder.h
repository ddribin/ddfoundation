//
//  DDBaseNDecoder.h
//  DDFoundation
//
//  Created by Dave Dribin on 9/29/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>


@class DDBaseNInputBuffer;

@interface DDBaseNDecoder : NSObject
{
    DDBaseNInputBuffer * _inputBuffer;
    NSMutableData * _outputBuffer;
}

- (id)initWithInputBuffer:(DDBaseNInputBuffer *)inputBuffer;

@end
