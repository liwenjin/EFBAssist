//
//  AEAppDelegate.h
//  efbapp
//
//  Created by 徐 洋 on 14-3-17.
//  Copyright (c) 2014年 ADCC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DefaultAppDelegate : UIResponder <UIApplicationDelegate>

@property (retain, nonatomic) UIViewController * leftController;
@property (retain, nonatomic) UIViewController * centerController;

@property (strong, nonatomic) UIWindow *window;

@end

int EFBApplicationMain(int argc, char * argv[], NSString * principleClassName, NSString * delegateClassName);

int EFBDefaultApplicationMain(int argc, char * argv[]);