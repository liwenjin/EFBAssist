//
//  EFBISATemperatureViewController.h
//  hnaefb
//
//  Created by EFB on 13-8-23.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFBUtilitiesTitleCellView.h"
#import "CalculatorCellView.h"
#import "EFBNumpadController.h"

@interface EFBISATemperatureViewController : UIViewController<UITextFieldDelegate,EFBNumpadDelegate>

@property (retain, nonatomic) EFBUtilitiesTitleCellView *conditionView;
@property (retain, nonatomic) EFBUtilitiesTitleCellView *resultView;
@property (retain, nonatomic) EFBUtilitiesTitleCellView *directionView;

@property (retain, nonatomic) CalculatorCellView *OATView;
@property (retain, nonatomic) CalculatorCellView *elevationView;

@property (retain, nonatomic) CalculatorCellView *ISADeltaView;
@property (retain, nonatomic) CalculatorCellView *ISAView;

@end
