//
//  EFBBaseViewController.h
//  EFBFrameworkProject
//
//  Created by 徐 洋 on 13-8-5.
//  Copyright (c) 2013年 ADCC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EFBAccessoryBar.h"



@interface EFBBaseViewController : UIViewController

@property (copy, nonatomic) NSArray * accessoryItems;
@property (retain, readonly, nonatomic) EFBAccessoryBar * accessoryBar;

@property (assign, nonatomic) BOOL fullScreenMode;

@property (assign, nonatomic) BOOL expandButtonHidden;


- (void)efbNightModeChanged:(BOOL)enabled;

- (void)didFinishLoadView;

- (void)lockScreen;

- (void)unlockScreen;

@end
