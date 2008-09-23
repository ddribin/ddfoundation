/*
 * Copyright (c) 2007-2008 Dave Dribin
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import "NSData+DDExtensions.h"


enum state
{
    BYTE_0_NORMAL,
    BYTE_1_NORMAL,
    BYTE_2_NORMAL,
    BYTE_3_NORMAL,
    BYTE_4_NORMAL,
    
    BYTE_1_END,
    BYTE_2_END,
    BYTE_3_END,
    BYTE_4_END,
    END,
};

@implementation NSData (DDExtensions)

- (NSString *)dd_encodeBase64;
{
    static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

	if ([self length] == 0)
		return @"";
    
    unsigned size = ((([self length] + 2) / 3)  * 4);
    NSMutableString * output = [NSMutableString stringWithCapacity:size];
    
    const uint8_t * bytes = [self bytes];
    unsigned myLength = [self length] - 1;
    int state = BYTE_0_NORMAL;
	
	unsigned i = 0;
    uint32_t buffer = 0;
    uint8_t value;
	while (state != END)
	{
        switch (state)
        {
            case BYTE_0_NORMAL:
                // 00000000 xxxxxxxxx xxxxxxxx
                // eeeeee
                buffer = 0;
                buffer |= (bytes[i] << 16);
                
                value = (buffer >> 18) & 0x3F;
                [output appendFormat:@"%c", encodingTable[value]];
                
                if (i < myLength)
                {
                    i++;
                    state = BYTE_1_NORMAL;
                }
                else
                {
                    state = BYTE_1_END;
                }
                break;
                
            case BYTE_1_NORMAL:
                // 00000000 11111111 xxxxxxxx
                //       ee eeee    
                buffer |= (bytes[i] << 8);
                
                value = (buffer >> 12) & 0x3F;
                [output appendFormat:@"%c", encodingTable[value]];
                
                if (i < myLength)
                {
                    i++;
                    state = BYTE_2_NORMAL;
                }
                else
                {
                    state = BYTE_2_END;
                }
                break;
                
            case BYTE_2_NORMAL:
                // 00000000 11111111 22222222
                //              eeee eeEEEEEE
                buffer |= (bytes[i]);
                value = (buffer >> 6) & 0x3F;
                [output appendFormat:@"%c", encodingTable[value]];
                value = (buffer) & 0x3F;
                [output appendFormat:@"%c", encodingTable[value]];
                
                if (i < myLength)
                {
                    i++;
                    state = BYTE_0_NORMAL;
                }
                else
                {
                    state = END;
                }
                break;
                
            case BYTE_1_END:
                // 00000000 xxxxxxxx xxxxxxxx
                //       ee eeee    
                value = (buffer >> 12) & 0x3F;
                [output appendFormat:@"%c==", encodingTable[value]];
                state = END;
                break;
                
            case BYTE_2_END:
                // 00000000 11111111 xxxxxxxx
                //              eeee ee
                value = (buffer >> 6) & 0x3F;
                [output appendFormat:@"%c=", encodingTable[value]];
                state = END;
                break;
        }
    }
    
    return output;
}

- (NSString *)dd_encodeBase32
{
    static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ23456789+/";

	if ([self length] == 0)
		return @"";
    
    NSMutableString * output = [NSMutableString string];
    
    const uint8_t * bytes = [self bytes];
    unsigned myLength = [self length] - 1;
    int state = BYTE_0_NORMAL;
	
	unsigned i = 0;
    uint64_t buffer = 0;
    uint8_t value;
	while (state != END)
	{
        switch (state)
        {
            case BYTE_0_NORMAL:
                // 0000-0000 xxxx-xxxx xxxx-xxxx xxxx-xxxx xxxx-xxxx
                // eeee-e
                buffer = 0;
                buffer |= (((uint64_t)bytes[i]) << 32);
                value = (buffer >> 35) & 0x1F;
                [output appendFormat:@"%c", encodingTable[value]];
                
                if (i < myLength)
                {
                    i++;
                    state = BYTE_1_NORMAL;
                }
                else
                {
                    state = BYTE_1_END;
                }
                break;
                
            case BYTE_1_NORMAL:
                // 0000-0000 1111-1111 xxxx-xxxx xxxx-xxxx xxxx-xxxx
                //       eee eeEE-EEE
                buffer |= (((uint64_t)bytes[i]) << 24);
                value = (buffer >> 30) & 0x1F;
                [output appendFormat:@"%c", encodingTable[value]];
                value = (buffer >> 25) & 0x1F;
                [output appendFormat:@"%c", encodingTable[value]];
                
                if (i < myLength)
                {
                    i++;
                    state = BYTE_2_NORMAL;
                }
                else
                {
                    state = BYTE_2_END;
                }
                break;
                
            case BYTE_2_NORMAL:
                // 0000-0000 1111-1111 2222-2222 xxxx-xxxx xxxx-xxxx
                //                   e eeee
                buffer |= (((uint64_t)bytes[i]) << 16);
                value = (buffer >> 20) & 0x1F;
                [output appendFormat:@"%c", encodingTable[value]];
                
                if (i < myLength)
                {
                    i++;
                    state = BYTE_3_NORMAL;
                }
                else
                {
                    state = BYTE_3_END;
                }
                break;
                
            case BYTE_3_NORMAL:
                // 0000-0000 1111-1111 2222-2222 3333-3333 xxxx-xxxx
                //                          eeee eEEE EE
                buffer |= (((uint64_t)bytes[i]) << 8);
                value = (buffer >> 15) & 0x1F;
                [output appendFormat:@"%c", encodingTable[value]];
                value = (buffer >> 10) & 0x1F;
                [output appendFormat:@"%c", encodingTable[value]];
                
                if (i < myLength)
                {
                    i++;
                    state = BYTE_4_NORMAL;
                }
                else
                {
                    state = BYTE_4_END;
                }
                break;
                
            case BYTE_4_NORMAL:
                // 0000-0000 1111-1111 2222-2222 3333-3333 4444-4444
                //                                      ee eeeE-EEEE
                buffer |= (uint64_t)bytes[i];
                value = (buffer >> 5) & 0x1F;
                [output appendFormat:@"%c", encodingTable[value]];
                value = (buffer) & 0x1F;
                [output appendFormat:@"%c", encodingTable[value]];
                
                if (i < myLength)
                {
                    i++;
                    state = BYTE_0_NORMAL;
                }
                else
                {
                    state = END;
                }
                break;
                
            case BYTE_1_END:
                // 0000-0000 xxxx-xxxx xxxx-xxxx xxxx-xxxx xxxx-xxxx
                //       eee ee
                value = (buffer >> 30) & 0x1F;
                [output appendFormat:@"%c======", encodingTable[value]];
                state = END;
                break;
                
            case BYTE_2_END:
                // 0000-0000 1111-1111 xxxx-xxxx xxxx-xxxx xxxx-xxxx
                //                   e eeee
                value = (buffer >> 20) & 0x1F;
                [output appendFormat:@"%c", encodingTable[value]];
                [output appendString:@"===="];
                
                state = END;
                break;
                
            case BYTE_3_END:
                // 0000-0000 1111-1111 2222-2222 xxxx-xxxx xxxx-xxxx
                //                          eeee e
                value = (buffer >> 15) & 0x1F;
                [output appendFormat:@"%c", encodingTable[value]];
                [output appendString:@"==="];
                
                state = END;
                break;
                
            case BYTE_4_END:
                // 0000-0000 1111-1111 2222-2222 3333-3333 xxxx-xxxx
                //                                      ee eee
                value = (buffer >> 5) & 0x1F;
                [output appendFormat:@"%c=", encodingTable[value]];
                
                state = END;
                break;
        }
    }
    
    return output;
}

@end

@implementation NSMutableData (DDExtensions)

- (void) dd_appendUTF8String: (NSString *) string;
{
    [self appendData: [string dataUsingEncoding: NSUTF8StringEncoding]];
}

- (void) dd_appendUTF8Format: (NSString *) format, ...;
{
    va_list argList;
    va_start(argList, format);
    NSString * string = [[[NSString alloc] initWithFormat: format
                                                arguments: argList]
        autorelease];
    va_end(argList);
    [self dd_appendUTF8String: string];
}

@end
