//
//  EFBNumberPadViewController.h
//  InputControlProj
//
//  Created by 徐 洋 on 13-7-15.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EFBNumberPadViewController : UIViewController

@property (retain, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (retain, nonatomic) IBOutlet UIButton *doneButton;
@property (retain, nonatomic) IBOutlet UIButton *clearButton;
@property (retain, nonatomic) IBOutlet UIButton *deleteButton;

@property (retain, nonatomic) IBOutlet UIButton *nextButton;
@property (retain, nonatomic) IBOutlet UIButton *pointButton;
@property (retain, nonatomic) IBOutlet UIButton *pOrNButton;

@property (retain, nonatomic) IBOutlet UITextField *displayTextField;

@property (retain, nonatomic) IBOutlet UIButton *displayUnitButton;

@property (retain, nonatomic) IBOutlet UIView *dropView;

@property (retain, nonatomic) UISegmentedControl *unitSegment;
@property (assign, nonatomic) int selectIndex;
@property (assign, nonatomic) BOOL isCanSelect;

@property (assign, nonatomic) BOOL isWindPad;

@end
