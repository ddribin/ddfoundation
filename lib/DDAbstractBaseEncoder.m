//
//  DDAbstractBaseEncoder.m
//  DDFoundation
//
//  Created by Dave Dribin on 9/23/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import "DDAbstractBaseEncoder.h"
#import "DDBaseXOutputBuffer.h"


@implementation DDAbstractBaseEncoder

+ (NSString *)encodeData:(NSData *)data;
{
    DDAbstractBaseEncoder * encoder = [[[self alloc] init] autorelease];
    [encoder encodeData:data];
    return [encoder finishEncoding];
}

+ (NSString *)encodeData:(NSData *)data options:(DDBaseEncoderOptions)options;
{
    DDAbstractBaseEncoder * encoder = [[[self alloc] initWithOptions:options] autorelease];
    [encoder encodeData:data];
    return [encoder finishEncoding];
}


- (id)init;
{
    return [self initWithOptions:0];
}

- (id)initWithOptions:(DDBaseEncoderOptions)options;
{
    self = [super init];
    if (self == nil)
        return nil;
    
    BOOL addPadding = ((options & DDBaseEncoderOptionNoPadding) == 0);
    BOOL addLineBreaks = ((options & DDBaseEncoderOptionAddLineBreaks) != 0);
    _outputBuffer = [[DDBaseXOutputBuffer alloc] initWithAddPadding:addPadding
                                                      addLineBreaks:addLineBreaks];
    
    [self reset];
    
    return self;
}

- (void)dealloc
{
    [_outputBuffer release];
    [super dealloc];
}

- (void)reset;
{
    [_outputBuffer reset];
    _byteIndex = 0;
}

- (void)encodeData:(NSData *)data;
{
    const uint8_t * bytes = [data bytes];
    unsigned length = [data length];
    unsigned i;
    for (i = 0; i < length; i++)
    {
        [self encodeByte:bytes[i]];
    }
}

- (void)encodeByte:(uint8_t)byte;
{
    NSException * exception = [NSException exceptionWithName:@"Not implemented"
                                                      reason:@"abstract interface"
                                                    userInfo:nil];
    @throw exception;
}

- (NSString *)finishEncoding;
{
    NSException * exception = [NSException exceptionWithName:@"Not implemented"
                                                      reason:@"abstract interface"
                                                    userInfo:nil];
    @throw exception;
}

@end
