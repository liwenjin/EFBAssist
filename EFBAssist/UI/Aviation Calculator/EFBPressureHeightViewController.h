//
//  EFBPressureHeightViewController.h
//  hnaefb
//
//  Created by EFB on 13-8-26.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFBUtilitiesTitleCellView.h"
#import "CalculatorCellView.h"

@interface EFBPressureHeightViewController : UIViewController<UITextFieldDelegate>

@property (retain, nonatomic) EFBUtilitiesTitleCellView *conditionView;
@property (retain, nonatomic) EFBUtilitiesTitleCellView *resultView;
@property (retain, nonatomic) EFBUtilitiesTitleCellView *directionsView;

@property (retain, nonatomic) CalculatorCellView *QNHView;
@property (retain, nonatomic) CalculatorCellView *elevationView;
@property (retain, nonatomic) CalculatorCellView *pressureHightView;
@property (retain, nonatomic) CalculatorCellView *pressureHightView_m;

@end
