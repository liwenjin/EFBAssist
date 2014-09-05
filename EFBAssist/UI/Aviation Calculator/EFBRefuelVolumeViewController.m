//
//  EFBRefuelVolumeViewController.m
//  hnaefb
//
//  Created by EFB on 13-8-26.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import "EFBRefuelVolumeViewController.h"
#import "EFBNumpadController.h"
#import "EFBAviationCalculator.h"
#import "EFBUnitSystem.h"

typedef NS_ENUM(NSInteger, EFBDataTextFieldTag) {
    kTextFieldTagForDensity = 101,
    kTextFieldTagForVolume,
    kTextFieldTagForWeight
};

#define NUMBERS @"0123456789.\n"

@interface EFBRefuelVolumeViewController ()<EFBNumpadDelegate>

@property (retain, nonatomic) IBOutlet UIImageView *backImage;
@property (retain, nonatomic) EFBNumpadController * numpad;
@property (assign, nonatomic) int touchTextFieldTag;
@property (copy, nonatomic) NSString *densityUnit;
@property (copy, nonatomic) NSString *volumeUnit;

@end

@implementation EFBRefuelVolumeViewController
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
    [_densityView release];
    [_volumeView release];
    [_weightView release];
    [_weightView_LB release];
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
    [self setTagForViews];

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
    CGRect rect2 = self.densityView.frame;
    CGRect rect3 = self.volumeView.frame;
    CGRect rect4 = self.weightView.frame;
    CGRect rect5 = self.weightView_LB.frame;
    
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
    self.densityView.frame = rect2;
    self.volumeView.frame = rect3;
    self.weightView.frame = rect4;
    self.weightView_LB.frame = rect5;
}

#pragma mark - UIDeviceOrientationDidChangeNotification
- (void)didChangeStatusBarOrientationNotification
{
    if (touchTextFieldTag == kTextFieldTagForDensity) {
        if ([self.numpad isPopoverVisible]) {
            [self.numpad presentPopoverFromRect:self.densityView.dataTextField.frame inView:self.densityView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
    }
    if (touchTextFieldTag == kTextFieldTagForVolume) {
        if ([self.numpad isPopoverVisible]) {
            [self.numpad presentPopoverFromRect:self.volumeView.dataTextField.frame inView:self.volumeView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
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

#pragma mark - clear TextField
- (IBAction)clearButtonDidSelected:(id)sender{
    
    self.densityView.dataTextField.text = @"";
    self.volumeView.dataTextField.text = @"";
    self.weightView.dataTextField.text = @"";
    self.weightView_LB.dataTextField.text = @"";
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
    
    NSString *density = NSLocalizedString(@"utilities-label-fuel-density", @"燃油密度");
    NSString *volume = NSLocalizedString(@"utilities-label-fuel-volume", @"燃油体积");
    NSString *weight = NSLocalizedString(@"utilities-label-fuel-weight", @"加油重量");
    
    self.densityView = [self cellWithParameterName:[NSString stringWithFormat:@"%@(kg/L)",density] andY:80 andDataTextFiledType:kTextFieldForNormal];
    [self.view addSubview:self.densityView];
    
    self.volumeView = [self cellWithParameterName:[NSString stringWithFormat:@"%@(US gal)",volume] andY:140 andDataTextFiledType:kTextFieldForNormal];
    [self.view addSubview:self.volumeView];
    
    self.weightView = [self cellWithParameterName:[NSString stringWithFormat:@"%@(kg)",weight] andY:330 andDataTextFiledType:kTextFieldForResult];
//    self.weightView.dataTextField.textColor = [UIColor whiteColor];
    [self.view addSubview:self.weightView];
    
    self.weightView_LB = [self cellWithParameterName:[NSString stringWithFormat:@"%@(lb)",weight] andY:390 andDataTextFiledType:kTextFieldForResult];
//    self.weightView_LB.dataTextField.textColor = [UIColor whiteColor];
    [self.view addSubview:self.weightView_LB];
}

- (EFBUtilitiesTitleCellView *)cellTitleName:(NSString *)title andY:(CGFloat)y
{
    float width = 592.0f;
    float height = 55.0f;
    EFBUtilitiesTitleCellView * calculatorCellView = [[[NSBundle mainBundle] loadNibNamed:@"EFBUtilitiesTitleCellView" owner:self options:nil] objectAtIndex:0];
    calculatorCellView.backgroundColor = [UIColor clearColor];
    calculatorCellView.frame = CGRectMake(0, y ,width,height);
    calculatorCellView.titleLable.text = [NSString stringWithFormat:@"%@", title];
    calculatorCellView.titleLable.textColor = TEXTCOLOR;//[UIColor colorWithRed:0/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
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
    calculatorCellView.parameterNameLabel.textColor = TEXTCOLOR;//[UIColor colorWithRed:0/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
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
    self.densityView.dataTextField.tag = kTextFieldTagForDensity;
    self.volumeView.dataTextField.tag = kTextFieldTagForVolume;
    self.weightView.dataTextField.tag = kTextFieldTagForWeight;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    touchTextFieldTag = textField.tag;
    NSString *density = NSLocalizedString(@"utilities-label-fuel-density", @"燃油密度");
    NSString *volume = NSLocalizedString(@"utilities-label-fuel-volume", @"燃油体积");
    if (textField.tag == kTextFieldTagForDensity) {
        NSArray *array = @[@"kg/L",@"lb/USgal",@"kg/m³",@"g/cm³"];
        NSString *unitStr = [[[[self.densityView.parameterNameLabel.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
        self.densityUnit = unitStr;
        self.numpad = [[[EFBNumpadController alloc] initWithTitle:density unit:unitStr unitArray:array] autorelease];
        self.numpad.unitString = unitStr;
        [self.numpad presentPopoverFromRect:textField.frame inView:self.densityView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
    if (textField.tag == kTextFieldTagForVolume) {
        
        NSArray *array = @[@"US gal",@"L"];
        NSString *unitStr = [[[[self.volumeView.parameterNameLabel.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
        self.volumeUnit = unitStr;
        self.numpad = [[[EFBNumpadController alloc] initWithTitle:volume unit:unitStr unitArray:array] autorelease];
        self.numpad.unitString = unitStr;
        [self.numpad presentPopoverFromRect:textField.frame inView:self.volumeView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
    
    self.numpad.numPad.descriptionLabel.text = @"";//@"只允许输入-10000～10000的数字\nOnly numbers between -10000 and 10000 are allowed";
//    self.numpad.number = [NSNumber numberWithDouble:[textField.text doubleValue]];
    NSString *text = textField.text;
    if (text == nil || [text isEqualToString:@""]) {
        text = @"0";
    }
    self.numpad.number = [NSDecimalNumber decimalNumberWithString:text];
    self.numpad.numpadDelegate = self;
    
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == kTextFieldTagForDensity) {
        [self.volumeView.dataTextField becomeFirstResponder];
    }
    if (textField.tag == kTextFieldTagForVolume) {
         [textField resignFirstResponder];
//        [EFBFileHelper dismissKeyBoardForTextField];
    }
    return YES;
}
/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet * characterSet;
    characterSet = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString * filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
    BOOL canChange = [string isEqualToString:filtered];
    
    NSString *wholeText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (canChange) {
        if ([textField isEqual:self.densityView.dataTextField]) {
            [self caculatorWeightByDensity:wholeText volume:self.volumeView.dataTextField.text];
        }
        if ([textField isEqual:self.volumeView.dataTextField]) {
            [self caculatorWeightByDensity:self.densityView.dataTextField.text volume:wholeText];
        }
    }
    return canChange;
}
*/

#pragma mark - EFBNumpadDelegate
- (BOOL)numpadShouldFinishInput:(EFBNumpadController *)numpad
{
    CGFloat fValue = [numpad.number floatValue];
    
    if (fValue > 0.0f) {
        return YES;
    }
    
    return NO;
}

- (void)numpad:(EFBNumpadController *)numpad dismissedWithButton:(EFBNumpadButton)button
{
    NSDecimalNumber * number = numpad.number;
    NSString * string = numpad.unitString;
    NSString *density = NSLocalizedString(@"utilities-label-fuel-density", @"燃油密度");
    NSString *volume = NSLocalizedString(@"utilities-label-fuel-volume", @"燃油体积");
    if (touchTextFieldTag == kTextFieldTagForDensity) {
        self.densityView.decimalValue = number;
        self.densityView.parameterNameLabel.text = [NSString stringWithFormat:@"%@(%@)",density,string];
        self.densityUnit = string;
    }else if (touchTextFieldTag == kTextFieldTagForVolume){
        self.volumeView.decimalValue = number;
        self.volumeView.parameterNameLabel.text = [NSString stringWithFormat:@"%@(%@)",volume,string];
        self.volumeUnit = string;
    }
    
    if (touchTextFieldTag == kTextFieldTagForDensity && button == EFBNumpadButtonNext) {
        touchTextFieldTag = kTextFieldTagForVolume;
        
        NSArray *array = @[@"US gal",@"L"];
        NSString *unitStr = [[[[self.volumeView.parameterNameLabel.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
        self.volumeUnit = unitStr;
        self.numpad = [[[EFBNumpadController alloc] initWithTitle:NSLocalizedString(@"utilities-label-fuel-volume", @"燃油体积") unit:unitStr unitArray:array] autorelease];
        self.numpad.unitString = unitStr;
        self.numpad.numPad.descriptionLabel.text = @"";//@"只允许输入-10000～10000的数字\nOnly numbers between -10000 and 10000 are allowed";
//        self.numpad.number = [NSNumber numberWithDouble:[self.volumeView.dataTextField.text doubleValue]];
        NSString *text = self.volumeView.dataTextField.text;
        if (text == nil || [text isEqualToString:@""]) {
            text = @"0";
        }
        self.numpad.number = [NSDecimalNumber decimalNumberWithString:text];
        self.numpad.numpadDelegate = self;
        
        [self.numpad presentPopoverFromRect:self.volumeView.dataTextField.frame inView:self.volumeView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
    NSString *densityString = self.densityView.dataTextField.text;
    NSString *volumeString = self.volumeView.dataTextField.text;
    if (densityString == nil || [densityString isEqualToString:@""]) {
        densityString = @"0";
    }
    if (volumeString == nil || [volumeString isEqualToString:@""]) {
        volumeString = @"0";
    }
    [self caculatorWeightByDensity:[NSDecimalNumber decimalNumberWithString:densityString] volume:[NSDecimalNumber decimalNumberWithString:volumeString]];
}

#pragma mark - calculator
- (void)caculatorWeightByDensity:(NSDecimalNumber *)density volume:(NSDecimalNumber *)volume
{
    NSDecimalNumber *standardDensity = [EFBUnitSystem standardScaleForDensity:self.densityUnit scale:density];
    NSDecimalNumber *standardVolume = [EFBUnitSystem standardScaleForVolume:self.volumeUnit scale:volume];
    
    NSDecimalNumber *weightValue = [EFBAviationCalculator calculatorWeightByDensity:standardDensity volume:standardVolume];
    self.weightView.decimalValue = [EFBUnitSystem notRounding:weightValue afterPoint:0];
    
    NSDecimalNumber *weightValue_lb = [EFBUnitSystem unitScaleForWeight:@"lb" standardScale:weightValue];
    self.weightView_LB.decimalValue = [EFBUnitSystem notRounding:weightValue_lb afterPoint:0];
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
