//
//  EFBAppDelegate.h
//  EFBAssist
//
//  Created by ⟢E⋆F⋆B⟣ on 14-3-17.
//  Copyright (c) 2014年 ADCC. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <EFBAccessoryBar.h>
#import <DefaultAppDelegate.h>

@class EFBViewControllerContainer;

@interface EFBAppDelegate : DefaultAppDelegate <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) EFBViewControllerContainer *viewController;

@end
