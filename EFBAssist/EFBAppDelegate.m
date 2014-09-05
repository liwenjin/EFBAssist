//
//  EFBAppDelegate.m
//  EFBAssist
//
//  Created by ⟢E⋆F⋆B⟣ on 14-3-17.
//  Copyright (c) 2014年 ADCC. All rights reserved.
//

#import "EFBAppDelegate.h"
#import <UIDevice+EFB.h>
#import <EFBContext.h>
//#import <EFBIdentity.h>
#import <EFBViewControllerContainer.h>
#import <EFBAccessoryBar.h>
//#import <EFBMainMenuViewController.h>
#import <EFBFlightTask.h>
#import <AEIdentityManager.h>
#import <UIDevice+EFB.h>


@interface EFBAppDelegate()
@property (nonatomic,retain)UIAlertView *initAlert;
@property (nonatomic,retain)UIAlertView *loginAlert;
@property (nonatomic,retain)UIAlertView *alertView;
@end
@implementation EFBAppDelegate

- (void)dealloc
{
//    [_window release];
//    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    _initAlert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请先前往'EFB管理器'完成初始化！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    _loginAlert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请先前往'EFB管理器'完成登录！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];

    _alertView = [[UIAlertView alloc] initWithTitle: @"温馨提示:" message: @"该设备已被锁定!" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];

    return YES;
}

//- (void)applicationWillResignActive:(UIApplication *)application
//{
//    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//}
//
//- (void)applicationDidEnterBackground:(UIApplication *)application
//{
//    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
//    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//}
//
//- (void)applicationWillEnterForeground:(UIApplication *)application
//{
//    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
   [self checkDeviceMessage];
}

#pragma mark  判断程序是否初始化，登陆过

- (void)checkDeviceMessage
{
    NSString *deviceId = [[EFBContext sharedDefaultInstance] objectForkey:kDeviceUDID];
    
    if ([deviceId isEqualToString:@""]||deviceId == nil)
    {
        //调向EFB管理器
        
        if (![_initAlert isVisible])
        {
            [_initAlert show];
        }
        return;
    }
    
    NSDictionary *userDictionary = [AEIdentityManager defaultManager].currentUser;
    NSString *userName = [userDictionary objectForKey:kUserName];
    NSString *password = [userDictionary objectForKey:kUserEncryptPassword];
    if (!userName || !password)
    {
        if (![_loginAlert isVisible])
        {
            [_loginAlert show];
        }
        return;
    }
    
    NSUserDefaults *initDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isLock = [[initDefaults objectForKey:@"lock"] intValue];
    if (isLock)
    {
            if (![_alertView isVisible])
            {
                [_alertView show];
            }
    }

}

#pragma mark ---UIAlertView delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == _loginAlert || alertView == _initAlert)
    {
        NSString* urlString = @"adcc-efbmanage://";
        NSURL *url = [NSURL URLWithString:urlString];
        if([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }else
        {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert-title",@"温馨提示:") message:@"'EFB管理器'未安装，请先安装该应用"  delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alter show];
            [alter release];
            
        }
    }
    
    
    
}
//- (void)applicationWillTerminate:(UIApplication *)application
//{
//    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//}

@end
