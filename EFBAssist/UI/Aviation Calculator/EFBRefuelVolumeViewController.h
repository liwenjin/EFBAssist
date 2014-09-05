//
//  EFBRefuelVolumeViewController.h
//  hnaefb
//
//  Created by EFB on 13-8-26.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFBUtilitiesTitleCellView.h"
#import "CalculatorCellView.h"

@interface EFBRefuelVolumeViewController : UIViewController<UITextFieldDelegate>

@property (retain, nonatomic) EFBUtilitiesTitleCellView *conditionView;
@property (retain, nonatomic) EFBUtilitiesTitleCellView *resultView;
@property (retain, nonatomic) EFBUtilitiesTitleCellView *directionsView;

@property (retain, nonatomic) CalculatorCellView *densityView;
@property (retain, nonatomic) CalculatorCellView *volumeView;
@property (retain, nonatomic) CalculatorCellView *weightView;
@property (retain, nonatomic) CalculatorCellView *weightView_LB;


@end
