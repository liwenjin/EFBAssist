//
//  EFBSpeedTranslatedViewController.m
//  hnaefb
//
//  Created by EFB on 13-9-6.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import "EFBSpeedTranslatedViewController.h"
#import "EFBNumpadController.h"
#import "EFBUnitSystem.h"

#define NUMBERS @"0123456789.\n"

typedef NS_ENUM(NSInteger, EFBDataTextFieldTag) {
    kTextFieldTagFormeterPerS = 101,
    kTextFieldTagForkmPerH,
    kTextFieldTagForkn
};

@interface EFBSpeedTranslatedViewController ()<EFBNumpadDelegate>

@property (retain, nonatomic) EFBNumpadController * numpad;
@property (assign, nonatomic) int touchTextFieldTag;
@property (retain, nonatomic) UITextField *touchTextField;

@end

@implementation EFBSpeedTranslatedViewController
@synthesize touchTextFieldTag;

#pragma mark - view lifecycle
- (void)dealloc {
    [_numpad release];
    [_touchTextField release];
    [_metricSystemView release];
    [_inchView release];
    [_meterPerSView release];
    [_kmPerHView release];
    [_knView release];
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
    CGRect rect = self.metricSystemView.frame;
    CGRect rect1 = self.inchView.frame;
    CGRect rect2 = self.meterPerSView.frame;
    CGRect rect3 = self.kmPerHView.frame;
    CGRect rect4 = self.knView.frame;
    
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
    self.meterPerSView.frame = rect2;
    self.kmPerHView.frame = rect3;
    self.knView.frame = rect4;
}

#pragma mark - UIDeviceOrientationDidChangeNotification
- (void)didChangeStatusBarOrientationNotification
{
    if (touchTextFieldTag == kTextFieldTagFormeterPerS) {
        if ([self.numpad isPopoverVisible]) {
            [self.numpad presentPopoverFromRect:self.meterPerSView.dataTextField.frame inView:self.meterPerSView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
    }
    if (touchTextFieldTag == kTextFieldTagForkmPerH) {
        if ([self.numpad isPopoverVisible]) {
            [self.numpad presentPopoverFromRect:self.kmPerHView.dataTextField.frame inView:self.kmPerHView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
    }
    if (touchTextFieldTag ==kTextFieldTagForkn) {
        if ([self.numpad isPopoverVisible]) {
            [self.numpad presentPopoverFromRect:self.knView.dataTextField.frame inView:self.knView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
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
    
    self.meterPerSView.dataTextField.text = @"";
    self.kmPerHView.dataTextField.text = @"";
    self.knView.dataTextField.text = @"";
}

#pragma initViews
- (void)createViews
{
    self.metricSystemView = [self cellTitleName:NSLocalizedString(@"utilities-metric-system",@"公制") andY:10];
    [self.view addSubview:self.metricSystemView];
    self.inchView = [self cellTitleName:NSLocalizedString(@"utilities-inch-system",@"英制") andY:260];
    [self.view addSubview:self.inchView];
    
    self.meterPerSView = [self cellWithParameterName:@"米/秒 (m/s)" andY:80 andDataTextFiledType:kTextFieldForNormal];
    [self.view addSubview:self.meterPerSView];
    
    self.kmPerHView = [self cellWithParameterName:@"千米/时 (km/h)" andY:140 andDataTextFiledType:kTextFieldForNormal];
    [self.view addSubview:self.kmPerHView];
    
    self.knView = [self cellWithParameterName:@"海里/时 (kn)" andY:330 andDataTextFiledType:kTextFieldForNormal];
    [self.view addSubview:self.knView];
    
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
    self.meterPerSView.dataTextField.tag = kTextFieldTagFormeterPerS;
    self.kmPerHView.dataTextField.tag = kTextFieldTagForkmPerH;
    self.knView.dataTextField.tag = kTextFieldTagForkn;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case kTextFieldTagFormeterPerS:
        {
            [self.meterPerSView setDataTextFieldType:kTextFieldForInput];
            [self.kmPerHView setDataTextFieldType:kTextFieldForNormal];
            [self.knView setDataTextFieldType:kTextFieldForNormal];
        }
            break;
        case kTextFieldTagForkmPerH:
        {
            [self.meterPerSView setDataTextFieldType:kTextFieldForNormal];
            [self.kmPerHView setDataTextFieldType:kTextFieldForInput];
            [self.knView setDataTextFieldType:kTextFieldForNormal];
        }
            break;
        case kTextFieldTagForkn:
        {
            [self.meterPerSView setDataTextFieldType:kTextFieldForNormal];
            [self.kmPerHView setDataTextFieldType:kTextFieldForNormal];
            [self.knView setDataTextFieldType:kTextFieldForInput];
        }
            break;
        default:
            break;
    }
    self.touchTextField = textField;
    touchTextFieldTag = textField.tag;
    
    
    if (textField.tag == kTextFieldTagFormeterPerS) {
        NSString *unitStr = [[[[self.meterPerSView.parameterNameLabel.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
        self.numpad = [[[EFBNumpadController alloc] initWithTitle:@"米/秒 (m/s)" unit:unitStr unitArray:nil] autorelease];
        self.numpad.unitString = unitStr;
        [self.numpad presentPopoverFromRect:textField.frame inView:self.meterPerSView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
    if (textField.tag == kTextFieldTagForkmPerH) {
        NSString *unitStr = [[[[self.kmPerHView.parameterNameLabel.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
        self.numpad = [[[EFBNumpadController alloc] initWithTitle:@"千米/时 (km/h)" unit:unitStr unitArray:nil] autorelease];
        self.numpad.unitString = unitStr;
        [self.numpad presentPopoverFromRect:textField.frame inView:self.kmPerHView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
    if (textField.tag == kTextFieldTagForkn) {
        
        NSString *unitStr = [[[[self.knView.parameterNameLabel.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
        self.numpad = [[[EFBNumpadController alloc] initWithTitle:@"海里/时 (kn)" unit:unitStr unitArray:nil] autorelease];
        self.numpad.unitString = unitStr;
        [self.numpad presentPopoverFromRect:textField.frame inView:self.knView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
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
            self.meterPerSView.dataTextField.text = @"";
            self.kmPerHView.dataTextField.text = @"";
            self.knView.dataTextField.text = @"";
        }else{
//            [self caculatorSpeedTranslatedWithCondition:wholeText textFieldTag:textField.tag];
        }
    }
    return canChange;
}
*/

#pragma mark - EFBNumpadDelegate
- (BOOL)numpadShouldFinishInput:(EFBNumpadController *)numpad
{
//    double fValue = [numpad.number doubleValue];
//    
//    if ( fValue >= -10000.0 && fValue<=10000.0) {
//        return YES;
//    }
//    return NO;
    return YES;
}

- (void)numpad:(EFBNumpadController *)numpad dismissedWithButton:(EFBNumpadButton)button
{
    NSDecimalNumber *number = numpad.number;
    if (touchTextFieldTag == kTextFieldTagFormeterPerS)
    {
        self.meterPerSView.decimalValue = number;
    }
    else if (touchTextFieldTag == kTextFieldTagForkmPerH)
    {
        self.kmPerHView.decimalValue = number;
    }
    else if (touchTextFieldTag == kTextFieldTagForkn)
    {
        self.knView.decimalValue = number;
    }
    
    [self caculatorSpeedTranslatedWithCondition:number textFieldTag:touchTextFieldTag];
}

#pragma mark - calculator
- (void)caculatorSpeedTranslatedWithCondition:(NSDecimalNumber *)condition textFieldTag:(int)tag
{
    switch (tag) {
        case kTextFieldTagFormeterPerS:
        {
            NSDecimalNumber *value = [EFBUnitSystem unitScaleForSpeed:@"km/h" standardScale:condition];
            self.kmPerHView.dataTextField.text = [EFBUnitSystem NotRounding:value afterPoint:3];
            NSDecimalNumber *value1 = [EFBUnitSystem unitScaleForSpeed:@"kn" standardScale:condition];
            self.knView.dataTextField.text = [EFBUnitSystem NotRounding:value1 afterPoint:3];
        }
            break;
        case kTextFieldTagForkmPerH:
        {
            NSDecimalNumber *value1 = [EFBUnitSystem standardScaleForSpeed:@"km/h" scale:condition];
            NSDecimalNumber *value2 = [EFBUnitSystem unitScaleForSpeed:@"kn" standardScale:value1];
            self.meterPerSView.dataTextField.text = [EFBUnitSystem NotRounding:value1 afterPoint:3];
            self.knView.dataTextField.text = [EFBUnitSystem NotRounding:value2 afterPoint:3];
        }
            break;
        case kTextFieldTagForkn:
        {
            NSDecimalNumber *value1 = [EFBUnitSystem standardScaleForSpeed:@"kn" scale:condition];
            NSDecimalNumber *value2 = [EFBUnitSystem unitScaleForSpeed:@"km/h" standardScale:value1];
            self.meterPerSView.dataTextField.text = [EFBUnitSystem  NotRounding:value1 afterPoint:3];
            self.kmPerHView.dataTextField.text = [EFBUnitSystem NotRounding:value2 afterPoint:3];
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
