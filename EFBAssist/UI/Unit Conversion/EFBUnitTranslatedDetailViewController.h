//
//  EFBUnitTranslatedDetailViewController.h
//  hnaefb
//
//  Created by EFB on 13-9-6.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "EFBTopView.h"
//#import "EFBUtilitiesDetailViewController.h"

#import "EFBSpeedTranslatedViewController.h"
#import "EFBWeightTranslatedViewController.h"
#import "EFBDistanceTranslatedViewController.h"
#import "EFBPressureTranslatedViewController.h"
#import "EFBTemperatureTranslatedViewController.h"
#import "EFBVolumeTranslatedViewController.h"
#import "EFBDensityTranslatedViewController.h"

@interface EFBUnitTranslatedDetailViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIButton *speedButton;
@property (retain, nonatomic) IBOutlet UIButton *weightButton;
@property (retain, nonatomic) IBOutlet UIButton *distanceButton;
@property (retain, nonatomic) IBOutlet UIButton *pressureButton;
@property (retain, nonatomic) IBOutlet UIButton *temperatureButton;
@property (retain, nonatomic) IBOutlet UIButton *volumeButton;
@property (retain, nonatomic) IBOutlet UIButton *densityButton;

@property (retain, nonatomic) EFBSpeedTranslatedViewController *speedTranslatedViewController;
@property (retain, nonatomic) EFBWeightTranslatedViewController *weightTranslatedViewController;
@property (retain, nonatomic) EFBDistanceTranslatedViewController *distanceTranslatedViewController;
@property (retain, nonatomic) EFBPressureTranslatedViewController *pressureTranslatedViewController;
@property (retain, nonatomic) EFBTemperatureTranslatedViewController *temperatureTranslatedViewController;
@property (retain, nonatomic) EFBVolumeTranslatedViewController *volumeTranslatedViewController;
@property (retain, nonatomic) EFBDensityTranslatedViewController *densityTranslatedViewController;

@property (retain, nonatomic) UIViewController *currentViewController;

@property (retain, nonatomic) NSArray *buttonArray;
@property (assign, nonatomic) int buttonTag;

@end
