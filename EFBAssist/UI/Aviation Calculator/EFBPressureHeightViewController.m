//
//  EFBPressureHeightViewController.m
//  hnaefb
//
//  Created by EFB on 13-8-26.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import "EFBPressureHeightViewController.h"
#import "EFBNumpadController.h"
#import "EFBAviationCalculator.h"
#import "EFBUnitSystem.h"

#define NUMBERS @"0123456789.\n"

typedef NS_ENUM(NSInteger, EFBDataTextFieldTag) {
    kTextFieldTagForQNH = 101,
    kTextFieldTagForElevation,
    kTextFieldTagForPressureHight
};

@interface EFBPressureHeightViewController ()<EFBNumpadDelegate>

@property (retain, nonatomic) IBOutlet UIImageView *backImage;
@property (retain, nonatomic) EFBNumpadController * numpad;
@property (assign, nonatomic) int touchTextFieldTag;
@property (copy, nonatomic) NSString *QNHUnit;
@property (copy, nonatomic) NSString *elevationUnit;
@end

@implementation EFBPressureHeightViewController
@synthesize touchTextFieldTag;

#pragma mark - view lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [_numpad release];
    [_directionsView release];
    [_conditionView release];
    [_resultView release];
    [_QNHView release];
    [_elevationView release];
    [_pressureHightView release];
    [_pressureHightView_m release];
    [_backImage release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarOrientationNotification) name:UIDeviceOrientationDidChangeNotification object:nil];
        
        NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(nightmodeChanged:) name:EFBNightModeChanged object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createViews];
    [self setTagForTextField];

    BOOL nightMode = [[UIApplication sharedApplication] nightlyMode];
    if (nightMode) {
        self.backImage.image = [UIImage imageNamed:@""];
        
        self.view.layer.masksToBounds=YES;
        self.view.layer.cornerRadius=1.0;
        self.view.layer.borderWidth=2.0;
        self.view.layer.borderColor=[VIEWCOLOR CGColor];
    }
    else{
        self.backImage.image = [UIImage imageNamed:@"utilitiesBg"];
        
        self.view.layer.masksToBounds=YES;
        self.view.layer.cornerRadius=1.0;
        self.view.layer.borderWidth=0.0;
        self.view.layer.borderColor=[[UIColor clearColor] CGColor];
    }
    
    /*
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = CGRectMake(435, 25, 17, 21);
    [clearButton setBackgroundImage:[UIImage imageNamed:@"utilitiesClear"] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearButtonDidSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearButton];
     */
}

- (void)viewWillLayoutSubviews
{
    float width = 592.0f;
    float view_origin_x = (CGRectGetWidth(self.view.frame)-width)/2;
    float origin_x = 0;
    CGRect rect = self.conditionView.frame;
    CGRect rect1 = self.resultView.frame;
    CGRect rect2 = self.QNHView.frame;
    CGRect rect3 = self.elevationView.frame;
    CGRect rect4 = self.pressureHightView.frame;
    CGRect rect5 = self.pressureHightView_m.frame;
    
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        origin_x = view_origin_x;
    }
    else{
        origin_x = 0;
    }
    
    rect.origin.x = origin_x;
    rect1.origin.x = origin_x;
    rect2.origin.x = origin_x;
    rect3.origin.x = origin_x;
    rect4.origin.x = origin_x;
    rect5.origin.x = origin_x;
    
    self.conditionView.frame = rect;
    self.resultView.frame = rect1;
    self.QNHView.frame = rect2;
    self.elevationView.frame = rect3;
    self.pressureHightView.frame = rect4;
    self.pressureHightView_m.frame = rect5;
}

#pragma mark - UIDeviceOrientationDidChangeNotification
- (void)didChangeStatusBarOrientationNotification
{
    if (touchTextFieldTag == kTextFieldTagForQNH) {
        if ([self.numpad isPopoverVisible]) {
            [self.numpad presentPopoverFromRect:self.QNHView.dataTextField.frame inView:self.QNHView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
    }
    if (touchTextFieldTag == kTextFieldTagForElevation) {
        if ([self.numpad isPopoverVisible]) {
            [self.numpad presentPopoverFromRect:self.elevationView.dataTextField.frame inView:self.elevationView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
    }
}

-(void)nightmodeChanged:(NSNotification*)notification
{
    BOOL nightMode = [[UIApplication sharedApplication] nightlyMode];
    if (nightMode) {
        self.backImage.image = [UIImage imageNamed:@""];
        
        self.view.layer.masksToBounds=YES;
        self.view.layer.cornerRadius=1.0;
        self.view.layer.borderWidth=2.0;
        self.view.layer.borderColor=[VIEWCOLOR CGColor];
    }
    else{
        self.backImage.image = [UIImage imageNamed:@"utilitiesBg"];
        
        self.view.layer.masksToBounds=YES;
        self.view.layer.cornerRadius=1.0;
        self.view.layer.borderWidth=0.0;
        self.view.layer.borderColor=[[UIColor clearColor] CGColor];
    }
}

#pragma mark - clear TextFeild
- (IBAction)clearButtonDidSelected:(id)sender{
    
    self.QNHView.dataTextField.text = @"";
    self.elevationView.dataTextField.text = @"";
    self.pressureHightView.dataTextField.text = @"";
    self.QNHView.parameterLabel.text = @"";
    self.pressureHightView_m.dataTextField.text = @"";
}

#pragma mark - initViews
- (void)createViews
{
    self.conditionView = [self cellTitleName:NSLocalizedString(@"utilities-label-parameter", @"计算条件") andY:10];
    [self.view addSubview:self.conditionView];
    
    self.resultView = [self cellTitleName:NSLocalizedString(@"utilities-label-result", @"计算结果") andY:260];
    [self.view addSubview:self.resultView];
    
    self.directionsView = [self cellTitleName:@"计算说明" andY:240];
//    [self.view addSubview:self.directionsView];

    NSString *descent = NSLocalizedString(@"utilities-label-Elevation", @"标高");
    NSString *pressureString = NSLocalizedString(@"utilities-btn-pressure-altitude1", @"压力高度");
    self.QNHView = [self cellWithParameterName:@"QNH (HPA)" andY:80 andDataTextFiledType:kTextFieldForNormal];
    [self.view addSubview:self.QNHView];
    
    self.elevationView = [self cellWithParameterName:[NSString stringWithFormat:@"%@ (ft)",descent] andY:140 andDataTextFiledType:kTextFieldForNormal];
    [self.view addSubview:self.elevationView];
    
    self.pressureHightView = [self cellWithParameterName:[NSString stringWithFormat:@"%@ (ft)",pressureString] andY:330 andDataTextFiledType:kTextFieldForResult];
//    self.pressureHightView.dataTextField.textColor = [UIColor whiteColor];
    [self.view addSubview:self.pressureHightView];
    
    self.pressureHightView_m = [self cellWithParameterName:[NSString stringWithFormat:@"%@ (m)",pressureString] andY:390 andDataTextFiledType:kTextFieldForResult];
//    self.pressureHightView_m.dataTextField.textColor = [UIColor whiteColor];
    [self.view addSubview:self.pressureHightView_m];
}

- (EFBUtilitiesTitleCellView *)cellTitleName:(NSString *)title andY:(CGFloat)y
{
    float width = 592.0f;
    float height = 55.0f;
    EFBUtilitiesTitleCellView * calculatorCellView = [[[NSBundle mainBundle] loadNibNamed:@"EFBUtilitiesTitleCellView" owner:self options:nil] objectAtIndex:0];
    calculatorCellView.backgroundColor = [UIColor clearColor];
    calculatorCellView.frame = CGRectMake(0, y ,width,height);
    calculatorCellView.titleLable.text = [NSString stringWithFormat:@"%@", title];
    calculatorCellView.titleLable.textColor = TEXTCOLOR;
    return calculatorCellView;
}

- (CalculatorCellView *)cellWithParameterName:(NSString *)parameterName andY:(CGFloat)y andDataTextFiledType:(EFBDataTextFieldType)aDataTextFieldType
{
    float width = 592.0f;
    float height = 55.0f;
    CalculatorCellView * calculatorCellView = [[[NSBundle mainBundle] loadNibNamed:@"CalculatorCellView" owner:self options:nil] objectAtIndex:0];
    [calculatorCellView setDataTextFieldType:aDataTextFieldType];
    calculatorCellView.backgroundColor = [UIColor clearColor];
    calculatorCellView.frame = CGRectMake(0, y ,width,height);
    calculatorCellView.parameterNameLabel.text = [NSString stringWithFormat:@"%@", parameterName];
    calculatorCellView.parameterNameLabel.textColor = TEXTCOLOR;
    calculatorCellView.parameterLabel.text = @"";
    calculatorCellView.parameterLabel.textColor = TEXTCOLOR;
    calculatorCellView.dataTextField.text = @"";
    calculatorCellView.dataTextField.delegate = self;
    return calculatorCellView;
}

#pragma mark - set tag
- (void)setTagForViews
{
    [self setTagForTextField];
}

- (void)setTagForTextField
{
    self.QNHView.dataTextField.tag = kTextFieldTagForQNH;
    self.elevationView.dataTextField.tag = kTextFieldTagForElevation;
    self.pressureHightView.dataTextField.tag = kTextFieldTagForPressureHight;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    touchTextFieldTag = textField.tag;
    NSArray *array = @[@"HPA",@"inHg"];
    if (textField.tag == kTextFieldTagForQNH) {
        NSString *unitStr = [[[[self.QNHView.parameterNameLabel.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
        self.QNHUnit = unitStr;
        self.numpad = [[[EFBNumpadController alloc] initWithTitle:@"QNH" unit:unitStr unitArray:array] autorelease];
        self.numpad.unitString = unitStr;
        self.numpad.numPad.descriptionLabel.frame = CGRectMake(3, 90, 235, 40);
        [self.numpad presentPopoverFromRect:textField.frame inView:self.QNHView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
    if (textField.tag == kTextFieldTagForElevation) {
        NSArray *array = @[@"ft",@"m"];
        NSString *unitStr = [[[[self.elevationView.parameterNameLabel.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
        self.elevationUnit = unitStr;
        self.numpad = [[[EFBNumpadController alloc] initWithTitle:NSLocalizedString(@"utilities-label-Elevation", @"标高") unit:unitStr unitArray:array] autorelease];
        self.numpad.unitString = unitStr;
        [self.numpad presentPopoverFromRect:textField.frame inView:self.elevationView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
    
    self.numpad.numPad.descriptionLabel.text = @"";//@"只允许输入-10000～10000的数字\nOnly numbers between -10000 and 10000 are allowed";
    
    NSString *text = textField.text;
    if (text == nil || [text isEqualToString:@""]) {
        text = @"0";
    }
    self.numpad.number = [NSDecimalNumber decimalNumberWithString:text];//[NSNumber numberWithFloat:[textField.text floatValue]];
    
    self.numpad.numpadDelegate = self;
    
    return NO;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == kTextFieldTagForQNH) {
        [self.elevationView.dataTextField becomeFirstResponder];
    }
    if (textField.tag == kTextFieldTagForElevation) {
        [textField resignFirstResponder];
//        [EFBFileHelper dismissKeyBoardForTextField];
    }
    return YES;
}

/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *wholeText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSCharacterSet * characterSet;
    characterSet = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString * filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
    BOOL canChange = [string isEqualToString:filtered];
    
    if (canChange) {
        if ([textField isEqual:self.QNHView.dataTextField]) {
            [self caculatorPressureHightViewWithQNH:wholeText elevation:self.elevationView.dataTextField.text];
        }
        if ([textField isEqual:self.elevationView.dataTextField]) {
            [self caculatorPressureHightViewWithQNH:self.QNHView.dataTextField.text elevation:wholeText];
        }
    }
    return canChange;
}
*/

#pragma mark - EFBNumpadDelegate
- (BOOL)numpadShouldFinishInput:(EFBNumpadController *)numpad
{
    CGFloat fValue = [numpad.number floatValue];
    
    if (touchTextFieldTag == kTextFieldTagForQNH) {
        if (fValue <= 0.0f) {
            self.numpad.numPad.descriptionLabel.text = @"输入范围为(0, +∞)\nPlease input within(0, +∞)";
            return NO;
        }
        if (fValue >0.0f && fValue <26.58f) {
            self.QNHUnit = @"inHg";
            self.numpad.unitString = @"inHg";
            self.numpad.numPad.selectIndex = 1;
            self.numpad.numPad.unitSegment.selectedSegmentIndex = 1;
            self.QNHView.parameterNameLabel.text = [NSString stringWithFormat:@"QNH(inHg)"];
            self.numpad.numPad.descriptionLabel.text = @"QNH is too low,please check!";
            return NO;
        }
        if (fValue >=26.58f && fValue <= 32.48f) {
            self.QNHUnit = @"inHg";
            self.numpad.unitString = @"inHg";
            self.numpad.numPad.selectIndex = 1;
            self.numpad.numPad.unitSegment.selectedSegmentIndex = 1;
            self.QNHView.parameterNameLabel.text = [NSString stringWithFormat:@"QNH(inHg)"];
            return YES;
        }
        if (fValue >=32.48f && fValue < 100.0f) {
            self.QNHUnit = @"inHg";
            self.numpad.unitString = @"inHg";
            self.numpad.numPad.selectIndex = 1;
            self.numpad.numPad.unitSegment.selectedSegmentIndex = 1;
            self.QNHView.parameterNameLabel.text = [NSString stringWithFormat:@"QNH(inHg)"];
            self.numpad.numPad.descriptionLabel.text = @"QNH is too High,please check!";
            return NO;
        }
        
        if (fValue >=100.0f && fValue < 900.0f) {
            self.QNHUnit = @"HPA";
            self.numpad.unitString = @"HPA";
            self.numpad.numPad.selectIndex = 0;
            self.numpad.numPad.unitSegment.selectedSegmentIndex = 0;
            self.QNHView.parameterNameLabel.text = [NSString stringWithFormat:@"QNH(HPA)"];
            self.numpad.numPad.descriptionLabel.text = @"QNH is too low,please check!";
            return NO;
        }
        if (fValue >=900.0f && fValue <= 1100.0f) {
            self.QNHUnit = @"HPA";
            self.numpad.unitString = @"HPA";
            self.numpad.numPad.selectIndex = 0;
            self.numpad.numPad.unitSegment.selectedSegmentIndex = 0;
            self.QNHView.parameterNameLabel.text = [NSString stringWithFormat:@"QNH(HPA)"];
            return YES;
        }
        if (fValue >1100.0f && fValue < 2000.0f) {
            self.QNHUnit = @"HPA";
            self.numpad.unitString = @"HPA";
            self.numpad.numPad.selectIndex = 0;
            self.numpad.numPad.unitSegment.selectedSegmentIndex = 0;
            self.QNHView.parameterNameLabel.text = [NSString stringWithFormat:@"QNH(HPA)"];
            self.numpad.numPad.descriptionLabel.text = @"QNH is too High,please check!";
            return NO;
        }
        
        if (fValue >=2000.0f && fValue < 2658.0f) {
            self.QNHUnit = @"inHg";
            self.numpad.unitString = @"inHg";
            self.numpad.numPad.selectIndex = 1;
            self.numpad.numPad.unitSegment.selectedSegmentIndex = 1;
            self.QNHView.parameterNameLabel.text = [NSString stringWithFormat:@"QNH(inHg)"];
            self.numpad.numPad.descriptionLabel.text = @"QNH is too low,please check!";
            return NO;
        }
        if (fValue >=2658.0f && fValue <= 3248.0f) {
            self.QNHUnit = @"inHg";
            self.numpad.unitString = @"inHg";
            self.numpad.numPad.selectIndex = 1;
            self.numpad.numPad.unitSegment.selectedSegmentIndex = 1;
            self.QNHView.parameterNameLabel.text = [NSString stringWithFormat:@"QNH(inHg)"];
            return YES;
        }
        if (fValue > 3248.0f) {
            self.QNHUnit = @"inHg";
            self.numpad.unitString = @"inHg";
            self.numpad.numPad.selectIndex = 1;
            self.numpad.numPad.unitSegment.selectedSegmentIndex = 1;
            self.QNHView.parameterNameLabel.text = [NSString stringWithFormat:@"QNH(inHg)"];
            self.numpad.numPad.descriptionLabel.text = @"QNH is too High,please check!";
            return NO;
        }
        
    }
    else if (touchTextFieldTag == kTextFieldTagForElevation)
    {
        if (fValue > 0.0f) {
            return YES;
        }
        return NO;
    }
    return YES;
}

- (void)numpad:(EFBNumpadController *)numpad dismissedWithButton:(EFBNumpadButton)button
{
    NSDecimalNumber * number = numpad.number;
    NSString * string = numpad.unitString;
    if (touchTextFieldTag == kTextFieldTagForQNH) {
        float QNHValue = [number floatValue];
        if (QNHValue >=2658.0f && QNHValue <= 3248.0f) {
            float value = QNHValue *0.01;
            self.QNHView.dataTextField.text = [NSString stringWithFormat:@"%0.2f", value];
            float value1 = value*33.8638815789;
            NSString * valueStr = [NSString stringWithFormat:@"%0.2f", value1];
            self.QNHView.parameterLabel.text = [NSString stringWithFormat:@"(%@ HPA)",valueStr];
        }else
        {
            self.QNHView.dataTextField.text = [number description];
            float value = 0.0f;
            self.QNHView.parameterNameLabel.text = [NSString stringWithFormat:@"QNH(%@)",string];
            if ([self.QNHUnit isEqualToString:@"HPA"]) {
                value = QNHValue/33.8638815789;
                NSString * valueStr = [NSString stringWithFormat:@"%0.2f", value];
                if ([valueStr isEqualToString:@"-0"] ||
                    [valueStr isEqualToString:@"0.00"]) {
                    valueStr = @"0";
                }
                self.QNHView.parameterLabel.text = [NSString stringWithFormat:@"(%@ inHg)",valueStr];
            }else{
                value = QNHValue*33.8638815789;
                NSString * valueStr = [NSString stringWithFormat:@"%0.2f", value];
                if ([valueStr isEqualToString:@"-0.00"] ||
                    [valueStr isEqualToString:@"0.00"]) {
                    valueStr = @"0";
                }
                self.QNHView.parameterLabel.text = [NSString stringWithFormat:@"(%@ HPA)",valueStr];
            }
        }
    }else if (touchTextFieldTag == kTextFieldTagForElevation){
        self.elevationView.dataTextField.text = [number description];
        NSString *descent = NSLocalizedString(@"utilities-label-Elevation", @"标高");
        self.elevationView.parameterNameLabel.text = [NSString stringWithFormat:@"%@(%@)",descent,string];
        self.elevationUnit = string;
    }
    
    if (touchTextFieldTag == kTextFieldTagForQNH && button == EFBNumpadButtonNext) {
        touchTextFieldTag = kTextFieldTagForElevation;
        NSArray *array = @[@"ft",@"m"];
        NSString *unitStr = [[[[self.elevationView.parameterNameLabel.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
        self.elevationUnit = unitStr;
        self.numpad = [[[EFBNumpadController alloc] initWithTitle:NSLocalizedString(@"utilities-label-Elevation", @"标高") unit:unitStr unitArray:array] autorelease];
        self.numpad.unitString = unitStr;
        self.numpad.numPad.descriptionLabel.text = @"";//@"只允许输入-10000～10000的数字\nOnly numbers between -10000 and 10000 are allowed";
        NSString *text = self.elevationView.dataTextField.text;
        if (text == nil || [text isEqualToString:@""]) {
            text = @"0";
        }
        self.numpad.number = [NSDecimalNumber decimalNumberWithString:text];//[NSNumber numberWithDouble:[self.elevationView.dataTextField.text doubleValue]];
        self.numpad.numpadDelegate = self;
        
        [self.numpad presentPopoverFromRect:self.elevationView.dataTextField.frame inView:self.elevationView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        
    }
    
    NSString *QNHString = self.QNHView.dataTextField.text;
    NSString *elevationString = self.elevationView.dataTextField.text;
    if (QNHString == nil || [QNHString isEqualToString:@""]) {
        QNHString = @"0";
    }
    if (elevationString == nil || [elevationString isEqualToString:@""]) {
        elevationString = @"0";
    }
    [self caculatorPressureHightViewWithQNH:[NSDecimalNumber decimalNumberWithString:QNHString] elevation:[NSDecimalNumber decimalNumberWithString:elevationString]];
}


#pragma mark - calculator
- (void)caculatorPressureHightViewWithQNH:(NSDecimalNumber *)QNH elevation:(NSDecimalNumber *)elevation
{
    NSDecimalNumber *standardQNH = [EFBUnitSystem standardScaleForPressure:self.QNHUnit scale:QNH];
    NSDecimalNumber *standardElevation = [EFBUnitSystem standardScaleForDistance:self.elevationUnit scale:elevation];
    
    NSDecimalNumber *pressureHightValue = [EFBAviationCalculator calculatorPressureHightViewWithQNH:standardQNH elevation:standardElevation];
    self.pressureHightView.decimalValue = [EFBUnitSystem notRounding:pressureHightValue afterPoint:0];
    
    NSDecimalNumber *pressureHightValue_m = [EFBUnitSystem standardScaleForDistance:@"ft" scale:pressureHightValue];
    self.pressureHightView_m.decimalValue = [EFBUnitSystem notRounding:pressureHightValue_m afterPoint:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBackImage:nil];
    [super viewDidUnload];
}
@end
