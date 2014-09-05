//
//  EFBWindComponentViewController.h
//  hnaefb
//
//  Created by EFB on 13-8-26.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFBUtilitiesTitleCellView.h"
#import "CalculatorCellView.h"

@interface EFBWindComponentViewController : UIViewController<UITextFieldDelegate>


@property (retain, nonatomic) EFBUtilitiesTitleCellView *conditionView;
@property (retain, nonatomic) EFBUtilitiesTitleCellView *resultView;
@property (retain, nonatomic) EFBUtilitiesTitleCellView *directionsView;

@property (retain, nonatomic) CalculatorCellView *metarWindView;
@property (retain, nonatomic) CalculatorCellView *directionView;

@property (retain, nonatomic) CalculatorCellView *windTrackView;
@property (retain, nonatomic) CalculatorCellView *crossWindView;

@property (retain, nonatomic) IBOutlet UILabel *reasonLabel1;
@property (retain, nonatomic) IBOutlet UILabel *reasonLabel2;

@end
