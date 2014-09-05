//
//  UIApplication+EFB.m
//  efbcore
//
//  Created by 徐 洋 on 13-12-19.
//  Copyright (c) 2013年 ADCC. All rights reserved.
//

#import "UIApplication+EFB.h"

#import "SSKeychain.h"

#import "EFBNotifications.h"
#import "EFBContext.h"


static NSString * EFBSService = @"cn.com.adcc.efb";
static NSString * EFBNightlyMode = @"efb-nightly-mode";


@implementation UIApplication (EFB)

- (BOOL)nightlyMode
{
    NSError * error = nil;
    id enabled = [SSKeychain passwordForService:EFBSService account:EFBNightlyMode error:&error];
    if (error) {
        if ([error code]==SSKeychainErrorNotFound) {
            enabled = @(NO);
            [SSKeychain setPassword:[NSString stringWithFormat:@"%@",enabled] forService:EFBSService account:EFBNightlyMode];
        }
    }
    
    if (enabled == nil ) {
        return NO;
    }
    [[EFBContext sharedInstance] setObject:enabled forKey:kScreenNightMode];

    return [enabled boolValue];
}

- (void)setNightlyMode:(BOOL)nightlyMode
{
    id enabled = @(nightlyMode);
    NSError * error = nil;

    [SSKeychain setPassword:[NSString stringWithFormat:@"%@",enabled] forService:EFBSService account:EFBNightlyMode error:&error];
    
    [[EFBContext sharedInstance] setObject:enabled forKey:kScreenNightMode];
    
    if (error) {
        NSLog(@"WARN: Save nightly mode fail; %@", error);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kScreenNightMode object:nightlyMode?@"YES":@"NO" userInfo:@{kScreenNightMode:enabled}];
}

@end
