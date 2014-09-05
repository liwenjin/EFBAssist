//
//  EFBTitleBar.h
//  EFBFrameworkProject
//
//  Created by 徐 洋 on 13-8-8.
//  Copyright (c) 2013年 ADCC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EFBTitleBar : UIView

@property (readonly, nonatomic) UILabel * titleLabel;

- (void)placeTitleBarToView:(UIView *)view;

@end
