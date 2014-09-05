//
//  CalculatorViewController.h
//  EFBCalculator
//
//  Created by  on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    EFBCConvertTypeNMToKM = 1,
    EFBCConvertTypeKMToNM = -1,
    EFBCConvertTypeFootToMeter = 2,
    EFBCConvertTypeMeterToFoot = -2,
    EFBCConvertTypePoundToKG = 3,
    EFBCConvertTypeKGToPound = -3,
    EFBCConvertTypeLiterToGallon = 4,
    EFBCConvertTypeGallonToLiter= -4,
    
} EFBCConvertType;

typedef enum {
    EFBCOperatorTypeBlank = 0,
    EFBCOperatorTypePlus,
    EFBCOperatorTypeMinus,
    EFBCOperatorTypeMultiply,
    EFBCOperatorTypeDivide,
    EFBCOperatorTypeEqual,
} EFBCOperatorType;

@interface CalculatorViewController : UIViewController
{
    EFBCConvertType  _currentConvertType;
    EFBCOperatorType  _operator;
    BOOL             observerAdded;
    UIViewController *orientationController;
    BOOL             operatorRepeat;

}
@property (retain, nonatomic) IBOutlet UIButton *NMToKMBtn;
@property (retain, nonatomic) IBOutlet UIButton *FootToMBtn;
@property (retain, nonatomic) IBOutlet UIButton *PToKGBtn;
@property (retain, nonatomic) IBOutlet UIButton *LToGallonBtn;
@property (retain, nonatomic) IBOutlet UIButton *NMToKMBtn1;
@property (retain, nonatomic) IBOutlet UIButton *FootToMBtn1;
@property (retain, nonatomic) IBOutlet UIButton *PToKGBtn1;
@property (retain, nonatomic) IBOutlet UIButton *LToGallonBtn1;

@property (retain, nonatomic) IBOutlet UIImageView *imagebgLandscape;
@property (retain, nonatomic) IBOutlet UIImageView *imagebg;
@property (retain, nonatomic) IBOutlet UIImageView *image_bg_line;
@property (retain, nonatomic) IBOutlet UIImageView *image_bg_landLine;

@property (retain, nonatomic) IBOutlet UITextField *leftResultField;
@property (retain, nonatomic) IBOutlet UITextField *rightResultField;
@property (retain, nonatomic) IBOutlet UILabel *leftUnitLabel;
@property (retain, nonatomic) IBOutlet UILabel *rightUnitLabel;
@property (retain, nonatomic) IBOutlet UILabel *leftDescLabel;
@property (retain, nonatomic) IBOutlet UILabel *rightDescLabel;
@property (retain, nonatomic) IBOutlet UIView  *contentView;

@property (retain, nonatomic) IBOutlet UIView  *contentViewLandscape;
@property (retain, nonatomic) IBOutlet UITextField *leftResultFieldLandscape;
@property (retain, nonatomic) IBOutlet UITextField *rightResultFieldLandscape;
@property (retain, nonatomic) IBOutlet UILabel *leftUnitLabelLandscape;
@property (retain, nonatomic) IBOutlet UILabel *rightUnitLabelLandscape;
@property (retain, nonatomic) IBOutlet UILabel *leftDescLabelLandscape;
@property (retain, nonatomic) IBOutlet UILabel *rightDescLabelLandscape;
@property (copy, nonatomic) NSString *strRetrunFirst;
@property (copy, nonatomic) NSString *strRetrunSecod;


//- (IBAction)backToAssistView:(id)sender;

- (IBAction)numberButtonTapped:(id)sender;
- (IBAction)clearButtonTapped:(id)sender;
- (IBAction)deleteButtonTapped:(id)sender;
- (IBAction)dotButtonTapped:(id)sender;
- (IBAction)operatorButtonTapped:(id)sender;
- (IBAction)equalButtonTapped:(id)sender;

- (IBAction)convertButtonTapped:(id)sender;
- (IBAction)exchangeButtonTapped:(id)sender;

@end
