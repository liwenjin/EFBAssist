//
//  EFBDropDistanceViewController.h
//  hnaefb
//
//  Created by EFB on 13-8-26.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFBUtilitiesTitleCellView.h"
#import "CalculatorCellView.h"

@interface EFBDropDistanceViewController : UIViewController<UITextFieldDelegate>

@property (retain, nonatomic) EFBUtilitiesTitleCellView *conditionView;
@property (retain, nonatomic) EFBUtilitiesTitleCellView *resultView;
@property (retain, nonatomic) EFBUtilitiesTitleCellView *directionsView;

@property (retain, nonatomic) CalculatorCellView *gradientView;
@property (retain, nonatomic) CalculatorCellView *fallHeightView;
@property (retain, nonatomic) CalculatorCellView *speedView;
@property (retain, nonatomic) CalculatorCellView *fallDistanceView;

@end
