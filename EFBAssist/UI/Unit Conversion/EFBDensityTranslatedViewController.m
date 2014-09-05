//
//  EFBDensityTranslatedViewController.m
//  hnaefb
//
//  Created by EFB on 13-9-6.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import "EFBDensityTranslatedViewController.h"
#import "EFBNumpadController.h"
#import "EFBUnitSystem.h"

typedef NS_ENUM(NSInteger, EFBDataTextFieldTag) {
    kTextFieldTagForGPerCm = 101,
    kTextFieldTagForKgPerM,
    kTextFieldTagForLbPerUSGal
};

#define NUMBERS @"0123456789.\n"
#define kScreenNightMode    @"NightMode"

@interface EFBDensityTranslatedViewController ()<EFBNumpadDelegate>

@property (retain, nonatomic) EFBNumpadController * numpad;
@property (assign, nonatomic) int touchTextFieldTag;
@property (retain, nonatomic) UITextField *touchTextField;

@end

@implementation EFBDensityTranslatedViewController
@synthesize touchTextFieldTag;

#pragma mark - view lifecycle
- (void)dealloc
{
    [_backImage release];
    [_numpad release];
    [_touchTextField release];
    [_gPerCmView release];
    [_kgPerMView release];
    [_lbPerUSGalView release];
    [_inchView release];
    [_metricSystemView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarOrientationNotification) name:UIDeviceOrientationDidChangeNotification object:nil];
        NSNotificationCenter* center = [NSNotificationCenter defaultCenter];        
        [center addObserver:self selector:@selector(nightmodeChanged:) name:kScreenNightMode object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    CGRect rect = self.view.bounds;
    self.backImage = [[[UIImageView alloc] initWithFrame:rect] autorelease];
    self.backImage.image = [UIImage imageNamed:@"utilitiesBg"];
    self.backImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.backImage];
    
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
    CGRect rect = self.metricSystemView.frame;
    CGRect rect1 = self.inchView.frame;
    CGRect rect2 = self.gPerCmView.frame;
    CGRect rect3 = self.kgPerMView.frame;
    CGRect rect4 = self.lbPerUSGalView.frame;
    
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
    
    self.metricSystemView.frame = rect;
    self.inchView.frame = rect1;
    self.gPerCmView.frame = rect2;
    self.kgPerMView.frame = rect3;
    self.lbPerUSGalView.frame = rect4;
}

#pragma mark - UIDeviceOrientationDidChangeNotification
- (void)didChangeStatusBarOrientationNotification
{
    if (touchTextFieldTag == kTextFieldTagForGPerCm) {
        if ([self.numpad isPopoverVisible]) {
            [self.numpad presentPopoverFromRect:self.gPerCmView.dataTextField.frame inView:self.gPerCmView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
    }
    if (touchTextFieldTag == kTextFieldTagForKgPerM) {
        if ([self.numpad isPopoverVisible]) {
            [self.numpad presentPopoverFromRect:self.kgPerMView.dataTextField.frame inView:self.kgPerMView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
    }
    if (touchTextFieldTag == kTextFieldTagForLbPerUSGal) {
        if ([self.numpad isPopoverVisible]) {
            [self.numpad presentPopoverFromRect:self.lbPerUSGalView.dataTextField.frame inView:self.lbPerUSGalView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
    }
}

-(void)nightmodeChanged:(NSNotification*)notification
{
//    BOOL nightMode = [[UIApplication sharedApplication] nightlyMode];
    BOOL nightMode = [[notification.userInfo objectForKey:kScreenNightMode] boolValue];
//    self.view.backgroundColor = enabled ? [UIColor blackColor] : [UIColor whiteColor];
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
    
    self.gPerCmView.dataTextField.text = @"";
    self.kgPerMView.dataTextField.text = @"";
    self.lbPerUSGalView.dataTextField.text = @"";
}

#pragma mark - initViews
- (void)createViews
{
    self.metricSystemView = [self cellTitleName:NSLocalizedString(@"utilities-metric-system",@"公制") andY:10];
    [self.view addSubview:self.metricSystemView];
    self.inchView = [self cellTitleName:NSLocalizedString(@"utilities-inch-system",@"英制") andY:260];
    [self.view addSubview:self.inchView];
    
    self.gPerCmView = [self cellWithParameterName:@"克/立方厘米 (g/cm³)" andY:80 andDataTextFiledType:kTextFieldForNormal];
    [self.view addSubview:self.gPerCmView];
    
    self.kgPerMView = [self cellWithParameterName:@"千克/立方米 (kg/m³)" andY:140 andDataTextFiledType:kTextFieldForNormal];
    [self.view addSubview:self.kgPerMView];
    
    self.lbPerUSGalView = [self cellWithParameterName:@"磅/美加仑 (lb/USgal)" andY:330 andDataTextFiledType:kTextFieldForNormal];
    [self.view addSubview:self.lbPerUSGalView];
}

- (EFBUtilitiesTitleCellView *)cellTitleName:(NSString *)title andY:(CGFloat)y
{
    float width = 592.0f;
    float height = 55.0f;
    EFBUtilitiesTitleCellView * calculatorCellView = [[[NSBundle mainBundle] loadNibNamed:@"EFBUtilitiesTitleCellView" owner:self options:nil] objectAtIndex:0];
    calculatorCellView.backgroundColor = [UIColor clearColor];
    calculatorCellView.frame = CGRectMake(0, y ,width,height);
    calculatorCellView.titleLable.textColor = TEXTCOLOR;//[UIColor colorWithRed:0/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    calculatorCellView.titleLable.text = [NSString stringWithFormat:@"%@", title];
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
    self.gPerCmView.dataTextField.tag = kTextFieldTagForGPerCm;
    self.kgPerMView.dataTextField.tag = kTextFieldTagForKgPerM;
    self.lbPerUSGalView.dataTextField.tag = kTextFieldTagForLbPerUSGal;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.gPerCmView setDataTextFieldType:kTextFieldForNormal];
    [self.kgPerMView setDataTextFieldType:kTextFieldForNormal];
    [self.lbPerUSGalView setDataTextFieldType:kTextFieldForNormal];
    
    self.touchTextField = textField;
    touchTextFieldTag = textField.tag;

    switch (textField.tag) {
        case kTextFieldTagForGPerCm:
        {
            [self.gPerCmView setDataTextFieldType:kTextFieldForInput];
            
            NSString *unitStr = [[[[self.gPerCmView.parameterNameLabel.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
            self.numpad = [[[EFBNumpadController alloc] initWithTitle:@"克/立方厘米 (g/cm³)" unit:unitStr unitArray:nil] autorelease];
            self.numpad.unitString = unitStr;
            [self.numpad presentPopoverFromRect:textField.frame inView:self.gPerCmView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
            break;
        case kTextFieldTagForKgPerM:
        {
            [self.kgPerMView setDataTextFieldType:kTextFieldForInput];
            
            NSString *unitStr = [[[[self.kgPerMView.parameterNameLabel.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
            self.numpad = [[[EFBNumpadController alloc] initWithTitle:@"千克/立方米 (kg/m³)" unit:unitStr unitArray:nil] autorelease];
            self.numpad.unitString = unitStr;
            [self.numpad presentPopoverFromRect:textField.frame inView:self.kgPerMView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
            break;
        case kTextFieldTagForLbPerUSGal:
        {
            [self.lbPerUSGalView setDataTextFieldType:kTextFieldForInput];
            
            NSString *unitStr = [[[[self.lbPerUSGalView.parameterNameLabel.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
            self.numpad = [[[EFBNumpadController alloc] initWithTitle:@"磅/美加仑 (lb/USgal)" unit:unitStr unitArray:nil] autorelease];
            self.numpad.unitString = unitStr;
            [self.numpad presentPopoverFromRect:textField.frame inView:self.lbPerUSGalView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
            break;
        default:
            break;
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
    [textField resignFirstResponder];
//    [EFBFileHelper dismissKeyBoardForTextField];
    return YES;
}
/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 10)
    {
        return NO;
    }
    NSCharacterSet * characterSet;
    characterSet = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString * filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
    BOOL canChange = [string isEqualToString:filtered];
    NSString *wholeText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (canChange) {
        if (wholeText == nil || [wholeText isEqualToString:@""]) {
            self.gPerCmView.dataTextField.text = @"";
            self.kgPerMView.dataTextField.text = @"";
            self.lbPerUSGalView.dataTextField.text = @"";
        }else{
//            [self caculatorWeightTranslatedWithCondition:wholeText textFieldTag:textField.tag];
        }
    }
    return canChange;
}
*/
#pragma mark - EFBNumpadDelegate
- (BOOL)numpadShouldFinishInput:(EFBNumpadController *)numpad
{
//    CGFloat fValue = [numpad.number floatValue];
//    
//    if ( fValue >= -10000.0f && fValue<=10000.0f) {
//        return YES;
//    }
//    
//    return NO;
    return YES;
}

- (void)numpad:(EFBNumpadController *)numpad dismissedWithButton:(EFBNumpadButton)button
{
    NSDecimalNumber * number = numpad.number;
    
    switch (touchTextFieldTag) {
        case kTextFieldTagForGPerCm:
        {
            self.gPerCmView.decimalValue = number;
        }
            break;
        case kTextFieldTagForKgPerM:
        {
            self.kgPerMView.decimalValue = number;
        }
            break;
        case kTextFieldTagForLbPerUSGal:
        {
            self.lbPerUSGalView.decimalValue = number;
        }
            break;
        default:
            break;
    }
    
    [self caculatorWeightTranslatedWithCondition:number textFieldTag:touchTextFieldTag];
}

#define UNITForGPerCm        @"g/cm³"
#define UNITForKgPerM        @"kg/m³"
#define UNITForLbPerUSGal    @"lb/USgal"
#define UNITForKgperL        @"kg/L"

#pragma mark - calculator
- (void)caculatorWeightTranslatedWithCondition:(NSDecimalNumber *)condition textFieldTag:(int)tag
{
    switch (tag) {
        case kTextFieldTagForGPerCm:
        {
            NSDecimalNumber *value = [EFBUnitSystem standardScaleForDensity:UNITForGPerCm scale:condition];
            NSDecimalNumber *value1 =  [EFBUnitSystem unitScaleForDensity:UNITForLbPerUSGal standardScale:value];
            self.kgPerMView.dataTextField.text = [EFBUnitSystem NotRounding:value afterPoint:10];
            self.lbPerUSGalView.dataTextField.text = [EFBUnitSystem NotRounding:value1 afterPoint:10];
        }
            break;
        case kTextFieldTagForKgPerM:
        {
            NSDecimalNumber *value = [EFBUnitSystem unitScaleForDensity:UNITForGPerCm standardScale:condition];
            NSDecimalNumber *value1 = [EFBUnitSystem unitScaleForDensity:UNITForLbPerUSGal standardScale:condition];
            self.gPerCmView.dataTextField.text = [EFBUnitSystem NotRounding:value afterPoint:10];
            self.lbPerUSGalView.dataTextField.text = [EFBUnitSystem NotRounding:value1 afterPoint:10];
        }
            break;
        case kTextFieldTagForLbPerUSGal:
        {
            NSDecimalNumber *value = [EFBUnitSystem standardScaleForDensity:UNITForLbPerUSGal scale:condition];
            NSDecimalNumber *value1 = [EFBUnitSystem unitScaleForDensity:UNITForGPerCm standardScale:value];
            self.kgPerMView.dataTextField.text = [EFBUnitSystem NotRounding:value afterPoint:10];
            self.gPerCmView.dataTextField.text = [EFBUnitSystem NotRounding:value1 afterPoint:10];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
