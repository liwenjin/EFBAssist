//
//  EFBTemperatureTranslatedViewController.m
//  hnaefb
//
//  Created by EFB on 13-9-6.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import "EFBTemperatureTranslatedViewController.h"
#import "EFBNumpadController.h"
#import "EFBUnitSystem.h"

typedef NS_ENUM(NSInteger, EFBDataTextFieldTag) {
    kTextFieldTagForC = 101,
    kTextFieldTagForF,
    kTextFieldTagForK
};

#define NUMBERS @"0123456789.\n"

@interface EFBTemperatureTranslatedViewController ()<EFBNumpadDelegate>

@property (retain, nonatomic) EFBNumpadController * numpad;
@property (assign, nonatomic) int touchTextFieldTag;
@property (retain, nonatomic) UITextField *touchTextField;

@end

@implementation EFBTemperatureTranslatedViewController
@synthesize touchTextFieldTag;

#pragma mark - view lifecycle
- (void)dealloc
{
    [_numpad release];
    [_touchTextField release];
    [_CView release];
    [_FView release];
    [_KView release];
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
        [center addObserver:self selector:@selector(nightmodeChanged:) name:EFBNightModeChanged object:nil];
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
    self.backImage.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
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
    CGRect rect = self.CView.frame;
    CGRect rect1 = self.FView.frame;
    CGRect rect2 = self.KView.frame;
    
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        origin_x = view_origin_x;
    }
    else{
        origin_x = 0;
    }
    
    rect.origin.x = origin_x;
    rect1.origin.x = origin_x;
    rect2.origin.x = origin_x;
    
    self.CView.frame = rect;
    self.FView.frame = rect1;
    self.KView.frame = rect2;
}

#pragma mark - UIDeviceOrientationDidChangeNotification
- (void)didChangeStatusBarOrientationNotification
{
    if (touchTextFieldTag == kTextFieldTagForC) {
        if ([self.numpad isPopoverVisible]) {
            [self.numpad presentPopoverFromRect:self.CView.dataTextField.frame inView:self.CView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
    }
    if (touchTextFieldTag == kTextFieldTagForF) {
        if ([self.numpad isPopoverVisible]) {
            [self.numpad presentPopoverFromRect:self.FView.dataTextField.frame inView:self.FView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
    }
    if (touchTextFieldTag == kTextFieldTagForK) {
        if ([self.numpad isPopoverVisible]) {
            [self.numpad presentPopoverFromRect:self.KView.dataTextField.frame inView:self.KView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
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

#pragma mark - clear textField
- (IBAction)clearButtonDidSelected:(id)sender{
    
    self.CView.dataTextField.text = @"";
    self.FView.dataTextField.text = @"";
    self.KView.dataTextField.text = @"";
}

#pragma mark - initViews
- (void)createViews
{
    self.CView = [self cellWithParameterName:@"摄氏度 (°C)" andY:70 andDataTextFiledType:kTextFieldForNormal];
    [self.view addSubview:self.CView];
    
    self.FView = [self cellWithParameterName:@"华氏度 (°F)" andY:130 andDataTextFiledType:kTextFieldForNormal];
    [self.view addSubview:self.FView];
    
    self.KView = [self cellWithParameterName:@"开尔文 (K)" andY:190 andDataTextFiledType:kTextFieldForNormal];
    [self.view addSubview:self.KView];
    
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
    self.CView.dataTextField.tag = kTextFieldTagForC;
    self.FView.dataTextField.tag = kTextFieldTagForF;
    self.KView.dataTextField.tag = kTextFieldTagForK;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.CView setDataTextFieldType:kTextFieldForNormal];
    [self.FView setDataTextFieldType:kTextFieldForNormal];
    [self.KView setDataTextFieldType:kTextFieldForNormal];
    
    self.touchTextField = textField;
    touchTextFieldTag = textField.tag;
    
    switch (textField.tag) {
        case kTextFieldTagForC:
        {
            [self.CView setDataTextFieldType:kTextFieldForInput];
            
            NSString *unitStr = [[[[self.CView.parameterNameLabel.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
            self.numpad = [[[EFBNumpadController alloc] initWithTitle:@"摄氏度 (°C)" unit:unitStr unitArray:nil] autorelease];
            self.numpad.unitString = unitStr;
            [self.numpad presentPopoverFromRect:textField.frame inView:self.CView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
            break;
        case kTextFieldTagForF:
        {
            [self.FView setDataTextFieldType:kTextFieldForInput];
            
            NSString *unitStr = [[[[self.FView.parameterNameLabel.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
            self.numpad = [[[EFBNumpadController alloc] initWithTitle:@"华氏度 (°F)" unit:unitStr unitArray:nil] autorelease];
            self.numpad.unitString = unitStr;
            [self.numpad presentPopoverFromRect:textField.frame inView:self.FView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
            break;
        case kTextFieldTagForK:
        {
            [self.KView setDataTextFieldType:kTextFieldForInput];
            
            NSString *unitStr = [[[[self.KView.parameterNameLabel.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
            self.numpad = [[[EFBNumpadController alloc] initWithTitle:@"开尔文 (K)" unit:unitStr unitArray:nil] autorelease];
            self.numpad.unitString = unitStr;
            [self.numpad presentPopoverFromRect:textField.frame inView:self.KView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
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
            self.CView.dataTextField.text = @"";
            self.FView.dataTextField.text = @"";
            self.KView.dataTextField.text = @"";
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
        case kTextFieldTagForC:
        {
            self.CView.decimalValue = number;
        }
            break;
        case kTextFieldTagForF:
        {
            self.FView.decimalValue = number;
        }
            break;
        case kTextFieldTagForK:
        {
            self.KView.decimalValue = number;
        }
            break;
        default:
            break;
    }
    
    [self caculatorWeightTranslatedWithCondition:number textFieldTag:touchTextFieldTag];
    
}

#define UNITForC             @"˚C"
#define UNITForF             @"˚F"
#define UNITForK             @"K"

#pragma mark - calculator
- (void)caculatorWeightTranslatedWithCondition:(NSDecimalNumber *)condition textFieldTag:(int)tag
{
    switch (tag) {
        case kTextFieldTagForC:
        {
            NSDecimalNumber *value = [EFBUnitSystem unitScaleForTemperature:UNITForF standardScale:condition];
            NSDecimalNumber *value1 = [EFBUnitSystem unitScaleForTemperature:UNITForK standardScale:condition];
            self.FView.dataTextField.text = [EFBUnitSystem NotRounding:value afterPoint:10];
            self.KView.dataTextField.text = [EFBUnitSystem NotRounding:value1 afterPoint:10];
        }
            break;
        case kTextFieldTagForF:
        {
            NSDecimalNumber *value = [EFBUnitSystem standardScaleForTemperature:UNITForF scale:condition];
            NSDecimalNumber *value1 = [EFBUnitSystem unitScaleForTemperature:UNITForK standardScale:value];
            self.CView.dataTextField.text = [EFBUnitSystem NotRounding:value afterPoint:10];
            self.KView.dataTextField.text = [EFBUnitSystem NotRounding:value1 afterPoint:10];
        }
            break;
        case kTextFieldTagForK:
        {
            NSDecimalNumber *value = [EFBUnitSystem standardScaleForTemperature:UNITForK scale:condition];
            NSDecimalNumber *value1 = [EFBUnitSystem unitScaleForTemperature:UNITForF standardScale:value];
            self.CView.dataTextField.text = [EFBUnitSystem NotRounding:value afterPoint:10];
            self.FView.dataTextField.text = [EFBUnitSystem NotRounding:value1 afterPoint:10];
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
