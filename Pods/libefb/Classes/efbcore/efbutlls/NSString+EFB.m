//
//  NSString+EFB.m
//  EFBFrameworkProject
//
//  Created by 徐 洋 on 13-9-13.
//  Copyright (c) 2013年 ADCC. All rights reserved.
//

#import "NSString+EFB.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (EFB)

+ (NSString *)MD5ForString:(NSString *)s
{
    const char *cStr = [s UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)MD5
{
    return [NSString MD5ForString:self];
}

@end
