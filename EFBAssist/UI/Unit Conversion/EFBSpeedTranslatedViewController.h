//
//  EFBSpeedTranslatedViewController.h
//  hnaefb
//
//  Created by EFB on 13-9-6.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorCellView.h"
#import "EFBUtilitiesTitleCellView.h"

@interface EFBSpeedTranslatedViewController : UIViewController<UITextFieldDelegate>

@property (retain, nonatomic) EFBUtilitiesTitleCellView *metricSystemView;
@property (retain, nonatomic) EFBUtilitiesTitleCellView *inchView;

@property (retain, nonatomic) CalculatorCellView *meterPerSView;
@property (retain, nonatomic) CalculatorCellView *kmPerHView;
@property (retain, nonatomic) CalculatorCellView *knView;

@property (retain, nonatomic) UIImageView * backImage;

@end
