//
//  EFBTemperatureTranslatedViewController.h
//  hnaefb
//
//  Created by EFB on 13-9-6.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorCellView.h"

@interface EFBTemperatureTranslatedViewController : UIViewController<UITextFieldDelegate>

@property (retain, nonatomic) CalculatorCellView *CView;
@property (retain, nonatomic) CalculatorCellView *FView;
@property (retain, nonatomic) CalculatorCellView *KView;

@property (retain, nonatomic) UIImageView * backImage;

@end
