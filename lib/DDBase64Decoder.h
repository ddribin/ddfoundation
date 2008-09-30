//
//  DDBase64Decoder.h
//  DDFoundation
//
//  Created by Dave Dribin on 9/29/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDBaseNDecoder.h"


@interface DDBase64Decoder : DDBaseNDecoder
{
}

+ (NSData *)base64DecodeString:(NSString *)base64;

+ (id)base64Decoder;

- (id)init;

@end
