//
//  DDAbstractBaseEncoder.m
//  DDFoundation
//
//  Created by Dave Dribin on 9/23/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import "DDAbstractBaseEncoder.h"


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
    
    _addPadding = ((options & DDBaseEncoderOptionNoPadding) == 0);
    _addLineBreaks = ((options & DDBaseEncoderOptionAddLineBreaks) != 0);
    
    [self reset];
    
    return self;
}

- (void)dealloc
{
    [_output release];
    [super dealloc];
}

- (void)reset;
{
    [_output release];
    _output = [[NSMutableString alloc ]init];
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

@implementation DDAbstractBaseEncoder (Protected)

- (void)appendPadCharacters:(int)count;
{
    if (!_addPadding)
        return;
    
    int i;
    for (i = 0; i < count; i++)
    {
        [self appendCharacter:'='];
    }
}

- (void)appendCharacter:(char)ch;
{
    [_output appendFormat:@"%c", ch];
    _currentLineLength++;
    if (_addLineBreaks && (_currentLineLength >= 64))
    {
        [_output appendString:@"\n"];
        _currentLineLength = 0;
    }
}

@end
