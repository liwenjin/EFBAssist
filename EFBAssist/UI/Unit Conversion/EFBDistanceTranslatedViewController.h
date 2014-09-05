//
//  EFBDistanceTranslatedViewController.h
//  hnaefb
//
//  Created by EFB on 13-9-6.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorCellView.h"
#import "EFBUtilitiesTitleCellView.h"

@interface EFBDistanceTranslatedViewController : UIViewController<UITextFieldDelegate>

@property (retain, nonatomic) EFBUtilitiesTitleCellView *metricSystemView;
@property (retain, nonatomic) EFBUtilitiesTitleCellView *inchView;

@property (retain, nonatomic) CalculatorCellView *nmiView;
@property (retain, nonatomic) CalculatorCellView *miView;
@property (retain, nonatomic) CalculatorCellView *mView;
@property (retain, nonatomic) CalculatorCellView *kmView;
@property (retain, nonatomic) CalculatorCellView *ftView;
@property (retain, nonatomic) CalculatorCellView *inView;

@property (retain, nonatomic) UIImageView * backImage;

@end
