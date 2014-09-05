//
//  EFBWeightTranslatedViewController.m
//  hnaefb
//
//  Created by EFB on 13-9-6.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import "EFBWeightTranslatedViewController.h"
#import "EFBNumpadController.h"
#import "EFBUnitSystem.h"

#define NUMBERS @"0123456789.\n"

typedef NS_ENUM(NSInteger, EFBDataTextFieldTag) {
    kTextFieldTagForKg = 101,
    kTextFieldTagForLb
};

@interface EFBWeightTranslatedViewController ()<EFBNumpadDelegate>

@property (retain, nonatomic) EFBNumpadController * numpad;
@property (assign, nonatomic) int touchTextFieldTag;
@property (retain, nonatomic) UITextField *touchTextField;

@end

@implementation EFBWeightTranslatedViewController
@synthesize touchTextFieldTag;

#pragma mark - view lifecycle
- (void)dealloc {
    [_numpad release];
    [_touchTextField release];
    [_metricSystemView release];
    [_inchView release];
    [_kgView release];
    [_lbView release];
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
    CGRect rect = self.metricSystemView.frame;
    CGRect rect1 = self.inchView.frame;
    CGRect rect2 = self.kgView.frame;
    CGRect rect3 = self.lbView.frame;
    
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
    
    self.metricSystemView.frame = rect;
    self.inchView.frame = rect1;
    self.kgView.frame = rect2;
    self.lbView.frame = rect3;
}

#pragma mark - UIDeviceOrientationDidChangeNotification
- (void)didChangeStatusBarOrientationNotification
{
    if (touchTextFieldTag == kTextFieldTagForKg) {
        if ([self.numpad isPopoverVisible]) {
            [self.numpad presentPopoverFromRect:self.kgView.dataTextField.frame inView:self.kgView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
    }
    if (touchTextFieldTag == kTextFieldTagForLb) {
        if ([self.numpad isPopoverVisible]) {
            [self.numpad presentPopoverFromRect:self.lbView.dataTextField.frame inView:self.lbView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
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
    
    self.kgView.dataTextField.text = @"";
    self.lbView.dataTextField.text = @"";
}

#pragma mark - initViews
- (void)createViews
{
    self.metricSystemView = [self cellTitleName:NSLocalizedString(@"utilities-metric-system",@"公制") andY:10];
    [self.view addSubview:self.metricSystemView];
    
    self.inchView = [self cellTitleName:NSLocalizedString(@"utilities-inch-system",@"英制") andY:260];
    [self.view addSubview:self.inchView];
    
    self.kgView = [self cellWithParameterName:@"千克 (kg)" andY:80 andDataTextFiledType:kTextFieldForNormal];
    [self.view addSubview:self.kgView];
    
    self.lbView = [self cellWithParameterName:@"磅 (lb)" andY:330 andDataTextFiledType:kTextFieldForNormal];
    [self.view addSubview:self.lbView];
    
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
    self.kgView.dataTextField.tag = kTextFieldTagForKg;
    self.lbView.dataTextField.tag = kTextFieldTagForLb;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == kTextFieldTagForKg) {
        [self.kgView setDataTextFieldType:kTextFieldForInput];
        [self.lbView setDataTextFieldType:kTextFieldForNormal];
    }
    if (textField.tag == kTextFieldTagForLb) {
        [self.kgView setDataTextFieldType:kTextFieldForNormal];
        [self.lbView setDataTextFieldType:kTextFieldForInput];
    }
    
    self.touchTextField = textField;
    touchTextFieldTag = textField.tag;
    
    if (textField.tag == kTextFieldTagForKg) {
        NSString *unitStr = [[[[self.kgView.parameterNameLabel.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
        self.numpad = [[[EFBNumpadController alloc] initWithTitle:@"千克 (kg)" unit:unitStr unitArray:nil] autorelease];
        self.numpad.unitString = unitStr;
        [self.numpad presentPopoverFromRect:textField.frame inView:self.kgView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
    if (textField.tag == kTextFieldTagForLb) {
        NSString *unitStr = [[[[self.lbView.parameterNameLabel.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
        self.numpad = [[[EFBNumpadController alloc] initWithTitle:@"磅 (lb)" unit:unitStr unitArray:nil] autorelease];
        self.numpad.unitString = unitStr;
        [self.numpad presentPopoverFromRect:textField.frame inView:self.lbView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
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
//    if (range.location >= 10)
//    {
//        return NO;
//    }
    NSCharacterSet * characterSet;
    characterSet = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString * filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
    BOOL canChange = [string isEqualToString:filtered];
    NSString *wholeText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (canChange) {
        if (wholeText == nil || [wholeText isEqualToString:@""]) {
            self.kgView.dataTextField.text = @"";
            self.lbView.dataTextField.text = @"";
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
    NSDecimalNumber *number = numpad.number;
    if (touchTextFieldTag == kTextFieldTagForKg)
    {
        self.kgView.decimalValue = number;
    }
    else if (touchTextFieldTag == kTextFieldTagForLb)
    {
        self.lbView.decimalValue = number;
    }
    
    [self caculatorWeightTranslatedWithCondition:number textFieldTag:touchTextFieldTag];
}

#pragma mark - calculator
- (void)caculatorWeightTranslatedWithCondition:(NSDecimalNumber *)condition textFieldTag:(int)tag
{
    switch (tag) {
        case kTextFieldTagForKg:
        {
            NSDecimalNumber *value = [EFBUnitSystem unitScaleForWeight:@"lb" standardScale:condition];
            self.lbView.dataTextField.text = [EFBUnitSystem NotRounding:value afterPoint:5];
        }
            break;
        case kTextFieldTagForLb:
        {
            NSDecimalNumber *value = [EFBUnitSystem standardScaleForWeight:@"lb" scale:condition];
            self.kgView.dataTextField.text = [EFBUnitSystem NotRounding:value afterPoint:5];
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
