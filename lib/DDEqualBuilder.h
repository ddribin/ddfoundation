//
//  DDEqualBuilder.h
//  DDFoundation
//
//  Created by Dave Dribin on 11/22/08.
//  Copyright 2008 Bit Maki, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DDEqualBuilder : NSObject
{
    BOOL _result;
}

+ (id)builder;

- (id)init;

- (BOOL)result;

- (BOOL)appendInstanceAndKindOf:(id)lhs :(id)rhs;

- (void)appendObject:(id)lhs :(id)rhs;

- (void)appendString:(NSString *)lhs :(NSString *)rhs;

- (void)appendBool:(BOOL)lhs :(BOOL)rhs;

@end
