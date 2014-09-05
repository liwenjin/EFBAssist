//
//  EFBContext.m
//  EFBFrameworkProject
//
//  Created by 徐 洋 on 13-8-7.
//  Copyright (c) 2013年 ADCC. All rights reserved.
//

#import "EFBContext.h"
#import "SSKeychain.h"
#import "AEModels.h"
#pragma warn Demo implamentation

@interface EFBContext()

@end


static NSString *EFBService = @"cn.com.adcc.efb";
@implementation EFBContext

+ (NSMutableDictionary *)sharedInstance
{
    static NSMutableDictionary * __instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[NSMutableDictionary alloc] init];
    });
    
    return __instance;
}

+ (EFBContext *)sharedDefaultInstance
{
    static EFBContext * __instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[EFBContext alloc] init];
    });
    
    return __instance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    
    return self;
}

- (void)setValue:(NSString *)value forKey:(NSString *)key
{
    NSError *error = nil;
    if (value && ![value isKindOfClass:[NSNull class]] && key)
    {
        [SSKeychain setPassword:value forService:EFBService account:key error:&error];
        if (error)
        {
            NSLog(@" EFBContext setValue failed. %@", error);
        }
    }
}

- (void)deleteValue:(NSArray *)keyArray
{
    NSError *error = nil;
    if (keyArray)
    {
        for (NSString * key in keyArray)
        {
            NSString *value = [SSKeychain passwordForService:EFBService account:key];
            if (value && ![value isKindOfClass:[NSNull class]])
            {
                [SSKeychain deletePasswordForService:EFBService account:key error:&error];
                if (error)
                {
                    NSLog(@" EFBContext deleteValue failed. %@", error);
                }
            }
        }
    }
}

- (NSString *)objectForkey:(NSString *)key
{
    NSString *value = nil;
    if (key)
    {
        value = [SSKeychain passwordForService:EFBService account:key];
    }
    
    return value;
}

- (void)resetAllValue
{
    NSDictionary *dic = [self getContextDic];
    for (NSString *key in [dic allKeys])
    {
        NSError *error = nil;
        [SSKeychain deletePasswordForService:EFBService account:key error:&error];
        if (error)
        {
            NSLog(@" EFBContext deleteValue failed. %@", error);
        }
    }
}

- (NSDictionary *)getContextDic
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSString *userName = [SSKeychain passwordForService:EFBService account:kUserName];
    if (userName)[dic setObject:userName forKey:kUserName];
    
    NSString *password = [SSKeychain passwordForService:EFBService account:kUserEncryptPassword];
    if (password)[dic setObject:password forKey:kUserEncryptPassword];
    
    NSString *userDept = [SSKeychain passwordForService:EFBService account:kUserDept];
    if (userDept)[dic setObject:userDept forKey:kUserDept];
    
    NSString *userEmail = [SSKeychain passwordForService:EFBService account:kUserEmail];
    if (userEmail)[dic setObject:userEmail forKey:kUserEmail];
    
    NSString *userFullName = [SSKeychain passwordForService:EFBService account:kUserFullName];
    if (userFullName)[dic setObject:userFullName forKey:kUserFullName];
    
    NSString *userMobileTelephone = [SSKeychain passwordForService:EFBService account:kUserMobileTelephone];
    if (userMobileTelephone)[dic setObject:userMobileTelephone forKey:kUserName];
    
    NSString *userTel = [SSKeychain passwordForService:EFBService account:kUserTel];
    if (userTel)[dic setObject:userTel forKey:kUserTel];
    
    NSString *userType = [SSKeychain passwordForService:EFBService account:kUserType];
    if (userType)[dic setObject:userType forKey:kUserType];
    
    NSString *deviceAcmodels = [SSKeychain passwordForService:EFBService account:kDeviceAcmodels];
    if (deviceAcmodels)[dic setObject:deviceAcmodels forKey:kDeviceAcmodels];
    
    NSString *deviceCarrier = [SSKeychain passwordForService:EFBService account:kDeviceCarrier];
    if (deviceCarrier)[dic setObject:deviceCarrier forKey:kDeviceCarrier];
    
    NSString *deviceHaveGroup = [SSKeychain passwordForService:EFBService account:kDeviceHaveGroup];
    if (deviceHaveGroup)[dic setObject:deviceHaveGroup forKey:kDeviceHaveGroup];
    
    NSString *deviceIsForeign = [SSKeychain passwordForService:EFBService account:kDeviceIsForeign];
    if (deviceIsForeign)[dic setObject:deviceIsForeign forKey:kDeviceIsForeign];
    
    NSString *deviceIsOuternet = [SSKeychain passwordForService:EFBService account:kDeviceIsOuternet];
    if (deviceIsOuternet)[dic setObject:deviceIsOuternet forKey:kDeviceIsOuternet];
    
    NSString *deviceName = [SSKeychain passwordForService:EFBService account:kDeviceName];
    if (deviceName)[dic setObject:deviceName forKey:kDeviceName];
    
    NSString *deviceUDID = [SSKeychain passwordForService:EFBService account:kDeviceUDID];
    if (deviceUDID)[dic setObject:deviceUDID forKey:kDeviceUDID];
    
    return dic;
}
@end
