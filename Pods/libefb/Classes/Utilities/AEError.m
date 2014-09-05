//
//  AEError.m
//  efbapp
//
//  Created by 徐 洋 on 14-3-18.
//  Copyright (c) 2014年 ADCC. All rights reserved.
//

#import "AEError.h"

@implementation AEError

- (NSString *)localizedDescription
{
    switch (self.code) {
        case 10086:
            return @"用户名密码错误";
            break;
            
        default:
            break;
    }
    
    return [super localizedDescription];
}

@end
