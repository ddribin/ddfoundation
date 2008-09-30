//
//  DDBase32Decoder.h
//  DDFoundation
//
//  Created by Dave Dribin on 9/29/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDBaseNDecoder.h"

@interface DDBase32Decoder : DDBaseNDecoder
{
}

+ (NSData *)base32DecodeString:(NSString *)string;

+ (id)base32Decoder;

- (id)init;

@end
