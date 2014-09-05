//
//  CalculatorWindViewController.h
//  calculator
//
//  Created by hanfei on 13-3-6.
//  Copyright (c) 2013年 ADCC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFBISATemperatureViewController.h"
#import "EFBWindComponentViewController.h"
#import "EFBClimbRateViewController.h"
#import "EFBDropDistanceViewController.h"
#import "EFBPressureHeightViewController.h"
#import "EFBRefuelVolumeViewController.h"


@interface EFBUtilitiesDetailViewController : UIViewController 
{
    UIViewController *orientationController;
}

@property (retain, nonatomic) IBOutlet UIButton *ISAButton;
@property (retain, nonatomic) IBOutlet UIButton *windButton;
@property (retain, nonatomic) IBOutlet UIButton *climbButton;
@property (retain, nonatomic) IBOutlet UIButton *fallDistanceButton;
@property (retain, nonatomic) IBOutlet UIButton *highPressureButton;
@property (retain, nonatomic) IBOutlet UIButton *addOilButton;


@property (retain, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (retain, nonatomic) NSArray *buttonArray;
@property (assign, nonatomic) int buttonTag;
@property (retain, nonatomic) UIViewController *currentViewController;

@property (retain, nonatomic) EFBISATemperatureViewController *ISAViewController;
@property (retain, nonatomic) EFBWindComponentViewController *windComponentViewController;
@property (retain, nonatomic) EFBClimbRateViewController *climbRateViewController;
@property (retain, nonatomic) EFBDropDistanceViewController *dropDistanceViewController;
@property (retain, nonatomic) EFBPressureHeightViewController *pressureHeightViewController;
@property (retain, nonatomic) EFBRefuelVolumeViewController *refuelVolumeViewController;

@end
