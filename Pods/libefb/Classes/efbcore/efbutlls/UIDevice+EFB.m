//
//  UIDevice+EFB.m
//  EFBFrameworkProject
//
//  Created by 徐 洋 on 13-9-13.
//  Copyright (c) 2013年 ADCC. All rights reserved.
//

#import "UIDevice+EFB.h"
#include "NSString+EFB.h"
#import "SSKeychain.h"
#import "OpenUDID.h"

NSString *EFBService = @"cn.com.adcc.efb";
NSString *EFBNameToken = @"=DFSMNVX679JKU=";
NSString *EFBDeviceId = @"DeviceID";

@implementation UIDevice (EFB)

- (NSString *)efbHardwareId
{
    // read hardware id from keychain
    NSError *error = nil;
    NSString *hardwareId = nil;
    NSData *data = [SSKeychain passwordDataForService:EFBService account:EFBNameToken error:&error];
    
    if (error) {
        if ([error code] == SSKeychainErrorNotFound) {
            // if id not exist, create it and store into keychain

//            hardwareId = [[NSUUID UUID] UUIDString];
            hardwareId = [OpenUDID value];

            NSLog(@"Hardware not found, create it with %@", hardwareId);
            
            [SSKeychain setPassword:hardwareId forService:EFBService account:EFBNameToken error:&error];
            
            if (error) {
                NSLog(@"Save hardware ID failed. %@", error);
            }
        }
        else {
            NSLog(@"Read hardware ID failed. %@", error);
            return nil;
        }
    }
    else {
        hardwareId = [NSString stringWithUTF8String:[data bytes]];
    }
    
    // return id
    return hardwareId;
}

- (void)resetEfbHardwareId
{
    [SSKeychain deletePasswordForService:EFBService account:EFBNameToken];
}

- (NSString *)efbDeviceId
{
   return [SSKeychain passwordForService:EFBService account:EFBDeviceId];
    
}



@end
