//
//  ViewController.h
//  EFBFrameworkProject
//
//  Created by 徐 洋 on 13-8-5.
//  Copyright (c) 2013年 ADCC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFBAccessoryBar.h"
#import "EFBBaseViewController.h"

#define kEFBMainMenuWillAppearNotification @"kEFBMainMenuWillAppearNotification"

@interface EFBViewControllerContainer : UIViewController

@property (retain, nonatomic) EFBBaseViewController * selectedViewController;

- (instancetype)initWithViewControllers:(NSArray *)viewControllers;

- (void)toggleSiderPanel;

@end
