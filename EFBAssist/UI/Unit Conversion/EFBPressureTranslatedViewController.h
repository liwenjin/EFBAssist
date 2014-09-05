//
//  EFBPressureTranslatedViewController.h
//  hnaefb
//
//  Created by EFB on 13-9-6.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorCellView.h"
#import "EFBUtilitiesTitleCellView.h"

@interface EFBPressureTranslatedViewController : UIViewController<UITextFieldDelegate>

@property (retain, nonatomic) CalculatorCellView *paView;
@property (retain, nonatomic) CalculatorCellView *inHgView;
@property (retain, nonatomic) CalculatorCellView *mmHgView;

@property (retain, nonatomic) UIImageView * backImage;

@end
