//
//  DDAbstractBaseEncoder.m
//  DDFoundation
//
//  Created by Dave Dribin on 9/23/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import "DDAbstractBaseEncoder.h"
#import "DDBaseXInputBuffer.h"
#import "DDBaseXOutputBuffer.h"

static const char kBase64Rfc4648Alphabet[] =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

static const char kRfc4648EncodingTable[] =   "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
static const char kCrockfordEncodingTable[] = "0123456789ABCDEFGHJKMNPQRSTVWXYZ";
static const char kZBase32EncodingTable[] =   "YBNDRFG8EJKMCPQXOT1UWISZA345H769";

@interface DDAbstractBaseEncoder ()

- (id)initWithOptions:(DDBaseEncoderOptions)options
          inputBuffer:(DDBaseXInputBuffer *)inputBuffer
             alphabet:(const char *)alphabet;
- (void)encodeGroup:(int)group;
- (void)encodeNumberOfGroups:(int)group;

@end

@implementation DDAbstractBaseEncoder

#pragma mark -
#pragma mark Base64 Convenience Methods

+ (NSString *)base64EncodeData:(NSData *)data;
{
    DDAbstractBaseEncoder * encoder = [self base64EncoderWithOptions:0];
    return [encoder encodeDataAndFinish:data];
}

+ (NSString *)base64EncodeData:(NSData *)data options:(DDBaseEncoderOptions)options;
{
    DDAbstractBaseEncoder * encoder = [self base64EncoderWithOptions:options];
    return [encoder encodeDataAndFinish:data];
}

+ (id)base64EncoderWithOptions:(DDBaseEncoderOptions)options;
{
    DDAbstractBaseEncoder * encoder = [[self alloc] initWithOptions:options
                                                        inputBuffer:[DDBaseXInputBuffer base64InputBuffer]
                                                           alphabet:kBase64Rfc4648Alphabet];
    return [encoder autorelease];
}

#pragma mark -
#pragma mark Base32 Convenience Methods

+ (NSString *)base32EncodeData:(NSData *)data;
{
    return [self base32EncodeData:data options:0 alphabet:DDBase32EncoderAlphabetRfc];
}

+ (NSString *)crockfordBase32EncodeData:(NSData *)data;
{
    return [self base32EncodeData:data options:DDBaseEncoderOptionNoPadding alphabet:DDBase32EncoderAlphabetCrockford];
}

+ (NSString *)zbase32EncodeData:(NSData *)data;
{
    return [self base32EncodeData:data options:DDBaseEncoderOptionNoPadding alphabet:DDBase32EncoderAlphabetZBase32];
}

+ (NSString *)base32EncodeData:(NSData *)data
                       options:(DDBaseEncoderOptions)options;
{
    return [self base32EncodeData:data options:options alphabet:DDBase32EncoderAlphabetRfc];
}

+ (NSString *)base32EncodeData:(NSData *)data
                       options:(DDBaseEncoderOptions)options
                      alphabet:(DDBase32EncoderAlphabet)alphabet;
{
    DDAbstractBaseEncoder * encoder = [self base32EncoderWithOptions:options
                                                            alphabet:alphabet];
    return [encoder encodeDataAndFinish:data];
}

+ (id)base32EncoderWithOptions:(DDBaseEncoderOptions)options
                      alphabet:(DDBase32EncoderAlphabet)alphabet;
{
    const char * alphabetTable;
    if (alphabet == DDBase32EncoderAlphabetCrockford)
        alphabetTable = kCrockfordEncodingTable;
    else if (alphabet == DDBase32EncoderAlphabetZBase32)
        alphabetTable = kZBase32EncodingTable;
    else
        alphabetTable = kRfc4648EncodingTable;
    
    DDAbstractBaseEncoder * encoder = [[self alloc] initWithOptions:options
                                                        inputBuffer:[DDBaseXInputBuffer base32InputBuffer]
                                                           alphabet:alphabetTable];
    return [encoder autorelease];
}

#pragma mark -

- (id)init;
{
    return [self initWithOptions:0
                     inputBuffer:[DDBaseXInputBuffer base64InputBuffer]
                        alphabet:kBase64Rfc4648Alphabet];
}

- (id)initWithOptions:(DDBaseEncoderOptions)options
          inputBuffer:(DDBaseXInputBuffer *)inputBuffer
             alphabet:(const char *)alphabet;
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _inputBuffer = [inputBuffer retain];
    
    BOOL addPadding = ((options & DDBaseEncoderOptionNoPadding) == 0);
    BOOL addLineBreaks = ((options & DDBaseEncoderOptionAddLineBreaks) != 0);
    _outputBuffer = [[DDBaseXOutputBuffer alloc] initWithAddPadding:addPadding
                                                      addLineBreaks:addLineBreaks];
    
    _alphabet = alphabet;
    
    [self reset];
    
    return self;
}

- (void)dealloc
{
    [_outputBuffer release];
    [_inputBuffer release];
    [super dealloc];
}

- (void)reset;
{
    [_inputBuffer reset];
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
    [_inputBuffer addByte:byte];
    if ([_inputBuffer isFull])
    {
        [self encodeNumberOfGroups:[_inputBuffer numberOfGroups]];
        [_inputBuffer reset];
    }
}

- (NSString *)finishEncoding;
{
    unsigned numberOfFilledGroups = [_inputBuffer numberOfFilledGroups];
    [self encodeNumberOfGroups:numberOfFilledGroups];
    if (numberOfFilledGroups > 0)
        [_outputBuffer appendPadCharacters:[_inputBuffer numberOfGroups] - numberOfFilledGroups];
    
    NSString * output = [_outputBuffer finalStringAndReset];
    return output;
}

- (NSString *)encodeDataAndFinish:(NSData *)data;
{
    [self encodeData:data];
    return [self finishEncoding];
}

- (void)encodeNumberOfGroups:(int)group;
{
    int i;
    for (i = 0; i < group; i++)
    {
        [self encodeGroup:i];
    }
}

- (void)encodeGroup:(int)group
{
    uint8_t value = [_inputBuffer valueAtGroupIndex:group];
    [_outputBuffer appendCharacter:_alphabet[value]];
}

@end
