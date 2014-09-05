//
//  EFBFileUtilty.h
//  EFBFrameworkProject
//
//  Created by 徐 洋 on 13-8-14.
//  Copyright (c) 2013年 ADCC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EFBFileUtilty : NSObject

+ (id)sharedInstance;

- (NSString *)storageDirectory;

- (NSString *)md5ForPath:(NSString *)path;


@end
