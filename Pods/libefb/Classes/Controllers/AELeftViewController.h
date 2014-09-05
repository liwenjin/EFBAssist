//
//  AELeftViewController.h
//  efbapp
//
//  Created by 徐 洋 on 14-3-17.
//  Copyright (c) 2014年 ADCC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AEAppListViewController.h"

static NSString * const kNotificationBrightnessChanged = @"kNotificationBrightnessChanged";

@interface AELeftViewController : UIViewController

@property (assign, nonatomic) id<AEAppListDelegate> appListDelegate;

@end
