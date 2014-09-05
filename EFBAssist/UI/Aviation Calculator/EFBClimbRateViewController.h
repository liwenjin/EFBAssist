//
//  EFBClimbRateViewController.h
//  hnaefb
//
//  Created by EFB on 13-8-26.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFBUtilitiesTitleCellView.h"
#import "CalculatorCellView.h"

@interface EFBClimbRateViewController : UIViewController<UITextFieldDelegate>

@property (retain, nonatomic) EFBUtilitiesTitleCellView *conditionView;
@property (retain, nonatomic) EFBUtilitiesTitleCellView *directionsView;

@property (retain, nonatomic) CalculatorCellView *gradientView;
@property (retain, nonatomic) CalculatorCellView *rateView;
@property (retain, nonatomic) CalculatorCellView *speedView;

@property (assign, nonatomic) int calculatorTextFieldTag;

@end
