//
//  EFBFileUtilty.m
//  EFBFrameworkProject
//
//  Created by 徐 洋 on 13-8-14.
//  Copyright (c) 2013年 ADCC. All rights reserved.
//

#import "EFBFileUtilty.h"
#import <CommonCrypto/CommonDigest.h>

@implementation EFBFileUtilty

+ (id)sharedInstance
{
    static id __instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (__instance == nil) {
            __instance = [[self alloc] init];
        }
    });
    
    return __instance;
}

// 使用Document目录保存文件
- (NSString *)storageDirectory
{
    static NSString * rootDir = @"_efb_storage";
    
    NSArray * dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * cachesPath = [dirs objectAtIndex:0];
    
    NSString * storagePath = [cachesPath stringByAppendingPathComponent:rootDir];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = YES;
    if ( [fileManager fileExistsAtPath:storagePath isDirectory:&isDirectory] == NO) {
        NSError * error = nil;
        [fileManager createDirectoryAtPath:storagePath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"[ERROR] Create storage directory failed. (%@)", error);
            
            // terminates app
            exit(1);
        }
    }
    
    return storagePath;
}

- (NSString *)md5ForPath:(NSString *)path
{
    
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if( handle== nil ) {
        return nil;
    }
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    while(!done)
    {
        NSData* fileData = [handle readDataOfLength: 4096 ];
        CC_MD5_Update(&md5, [fileData bytes], (CC_LONG)[fileData length]);
        if( [fileData length] == (NSUInteger)0 ) done = YES;

        fileData = nil;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    
    return s;
}

@end
