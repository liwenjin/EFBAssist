//
//  CalculatorCellView.h
//  calculator
//
//  Created by hanfei on 13-3-7.
//  Copyright (c) 2013年 ADCC. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef enum {
//    kDataTextFieldTypeNone = 101,
//    kDataTextFieldTypeWithSign,
//    kDataTextFieldTypeWithUnit,
//    kDataTextFieldTypeWithSignAndUnit
//} DataTextFieldType;

typedef NS_ENUM(NSInteger, EFBDataTextFieldType) {
    kTextFieldForNormal = 201,
    kTextFieldForInput,
    kTextFieldForResult
};

#define DistanceUnitType_KM   @"KM"
#define DistanceUnitType_M    @"M"
#define DistanceUnitType_NM   @"NM"

#define SignType_plus   @"+"
#define SignType_Minus  @"-"

#define SpeedUnitType_kmph   @"kmph"
#define SpeedUnitType_mps    @"m/s"
#define SpeedUnitType_kts      @"kts"

#define AirTempType_C            @"˚C"
#define AirTempType_F            @"˚F"
#define AltimeterSetType_hPa      @"hPa"
#define AltimeterSetType_InHg    @"inHg"
#define AltimeterSetType_mmHg    @"mmHg"
#define AlttitudeType_ft         @"ft"
#define AlttitudeType_m          @"m"


@interface CalculatorCellView : UIView

@property (nonatomic, retain) IBOutlet UILabel * parameterNameLabel;
@property (nonatomic, retain) IBOutlet UITextField * dataTextField;
@property (nonatomic, retain) IBOutlet UIButton * unitButton;
@property (nonatomic, retain) IBOutlet UIButton * signButton;
@property (retain, nonatomic) IBOutlet UILabel *parameterLabel;

@property (getter=decimalValue, setter=setDecimalValue:,assign, nonatomic) NSDecimalNumber *decimalValue;

//-(void)setDataTextFieldType:(DataTextFieldType)aType;
- (void)setDataTextFieldType:(EFBDataTextFieldType)aType;

@end
