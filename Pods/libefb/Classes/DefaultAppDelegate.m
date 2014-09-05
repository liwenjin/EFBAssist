//
//  AEAppDelegate.m
//  efbapp
//
//  Created by 徐 洋 on 14-3-17.
//  Copyright (c) 2014年 ADCC. All rights reserved.
//

#import <SSKeychain.h>
#import <PixateFreestyle.h>

#import "EFBContext.h"
#import "EFBViewControllerContainer.h"

#import "DefaultAppDelegate.h"
#import "AECenterViewController.h"
#import "AELeftViewController.h"
#import "EFBRootViewController.h"

// backward compatible
static NSString * EFBSService = @"cn.com.adcc.efb";
static NSString * EFBNightlyMode = @"efb-nightly-mode";

@interface DefaultAppDelegate ()

@end

@implementation DefaultAppDelegate

- (void)initializeContext
{
    // 初始化环境变量
    NSDictionary * infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    NSMutableDictionary *context = [EFBContext sharedInstance];
    
    // 设置软件版本号
    [context setObject:version forKey:kSoftwareVersion];
    
    // 设置夜间模式
    NSError * error = nil;
    
    id enabled = [SSKeychain passwordForService:EFBSService account:EFBNightlyMode error:&error];
    if (enabled) {
        [[EFBContext sharedInstance] setObject:enabled forKey:kScreenNightMode];
    }
    else {
        [[EFBContext sharedInstance] setObject:@(NO) forKey:kScreenNightMode];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    EFBRootViewController * rootVC = [[EFBRootViewController alloc] init];
    
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation
{
    UIInterfaceOrientation orientation = [application statusBarOrientation];
    
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        self.centerController.viewDeckController.leftSize = 768-430;
    }
    else {
        self.centerController.viewDeckController.leftSize = 1024-430;

    }
}

int EFBApplicationMain(int argc, char * argv[], NSString * principleClassName, NSString * delegateClassName)
{
    [PixateFreestyle initializePixateFreestyle];
    return UIApplicationMain(argc, argv, principleClassName, delegateClassName);
}

int EFBDefaultApplicationMain(int argc, char * argv[])
{
    return EFBApplicationMain(argc, argv, nil, NSStringFromClass([DefaultAppDelegate class]));
}

@end
