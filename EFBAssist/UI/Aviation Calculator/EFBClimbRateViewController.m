//
//  EFBClimbRateViewController.m
//  hnaefb
//
//  Created by EFB on 13-8-26.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import "EFBClimbRateViewController.h"
#import "EFBNumpadController.h"
#import "EFBAviationCalculator.h"

#define NUMBERS @"0123456789.\n"

typedef NS_ENUM(NSInteger, EFBDataTextFieldTag) {
    kTextFieldTagForGradient = 101,
    kTextFieldTagForSpeed,
    kTextFieldTagForRate
};

@interface EFBClimbRateViewController ()<EFBNumpadDelegate>

@property (retain, nonatomic) IBOutlet UIImageView *backImage;
@property (retain, nonatomic) EFBNumpadController * numpad;
@property (assign, nonatomic) int touchTextFieldTag;

@end

@implementation EFBClimbRateViewController
@synthesize calculatorTextFieldTag;
@synthesize touchTextFieldTag;

#pragma mark - View lifecycle
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
    [_gradientView release];
    [_speedView release];
    [_rateView release];
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
    CGRect rect = self.gradientView.frame;
    CGRect rect1 = self.speedView.frame;
    CGRect rect2 = self.rateView.frame;
    CGRect rect3 = self.conditionView.frame;
    
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
    
    self.gradientView.frame = rect;
    self.speedView.frame = rect1;
    self.rateView.frame = rect2;
    self.conditionView.frame = rect3;
}

#pragma mark - UIDeviceOrientationDidChangeNotification
- (void)didChangeStatusBarOrientationNotification
{
    if (touchTextFieldTag == kTextFieldTagForGradient) {
        if ([self.numpad isPopoverVisible]) {
            [self.numpad presentPopoverFromRect:self.gradientView.dataTextField.frame inView:self.gradientView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
    }
    if (touchTextFieldTag == kTextFieldTagForSpeed) {
        if ([self.numpad isPopoverVisible]) {
            [self.numpad presentPopoverFromRect:self.speedView.dataTextField.frame inView:self.speedView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
    }
    if (touchTextFieldTag == kTextFieldTagForRate) {
        if ([self.numpad isPopoverVisible]) {
            [self.numpad presentPopoverFromRect:self.rateView.dataTextField.frame inView:self.rateView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
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
    
    self.gradientView.dataTextField.text = @"";
    self.speedView.dataTextField.text = @"";
    self.rateView.dataTextField.text = @"";
}

#pragma mark - initViews
- (void)createViews
{
    self.conditionView = [self cellTitleName:NSLocalizedString(@"utilities-label-parameter", @"计算条件") andY:10];
    [self.view addSubview:self.conditionView];
    
    self.directionsView = [self cellTitleName:@"计算说明" andY:200];
//    [self.view addSubview:self.directionsView];

    NSString *gradient = NSLocalizedString(@"utilities-label-Climbing-Gradient", @"爬升梯度");
    NSString *speed = NSLocalizedString(@"utilities-label-Ground-Speed", @"地速");
    NSString *rate = NSLocalizedString(@"utilities-label-Rate-of-Climb", @"爬升率");
    self.gradientView = [self cellWithParameterName:[NSString stringWithFormat:@"%@(FT/NM)",gradient] andY:80 andDataTextFiledType:kTextFieldForNormal];
    [self.view addSubview:self.gradientView];
    
    self.speedView = [self cellWithParameterName:[NSString stringWithFormat:@"%@(KT)",speed] andY:140 andDataTextFiledType:kTextFieldForNormal];
    [self.view addSubview:self.speedView];
    
    self.rateView = [self cellWithParameterName:[NSString stringWithFormat:@"%@(FT/MIN)",rate] andY:200 andDataTextFiledType:kTextFieldForNormal];
    [self.view addSubview:self.rateView];
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
    self.gradientView.dataTextField.tag = kTextFieldTagForGradient;
    self.speedView.dataTextField.tag = kTextFieldTagForSpeed;
    self.rateView.dataTextField.tag = kTextFieldTagForRate;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{ 
    if (textField.tag != kTextFieldTagForSpeed) {
        calculatorTextFieldTag = textField.tag;
    }

    touchTextFieldTag = textField.tag;
    NSString *gradient = NSLocalizedString(@"utilities-label-Climbing-Gradient", @"爬升梯度");
    NSString *speed = NSLocalizedString(@"utilities-label-Ground-Speed", @"地速");
    NSString *rate = NSLocalizedString(@"utilities-label-Rate-of-Climb", @"爬升率");
    if (textField.tag == kTextFieldTagForGradient) {
        self.numpad = [[[EFBNumpadController alloc] initWithTitle:gradient unit:@"FT/NM" unitArray:nil] autorelease];
        self.numpad.unitString = @"FT/NM";
        [self.numpad presentPopoverFromRect:textField.frame inView:self.gradientView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
    if (textField.tag == kTextFieldTagForSpeed) {
        self.numpad = [[[EFBNumpadController alloc] initWithTitle:speed unit:@"KT" unitArray:nil] autorelease];
        self.numpad.unitString = @"KT";
        [self.numpad presentPopoverFromRect:textField.frame inView:self.speedView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
    if (textField.tag == kTextFieldTagForRate) {
        self.numpad = [[[EFBNumpadController alloc] initWithTitle:rate unit:@"FT/MIN" unitArray:nil] autorelease];
        self.numpad.unitString = @"FT/MIN";
        [self.numpad presentPopoverFromRect:textField.frame inView:self.rateView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
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
    if (textField.tag == kTextFieldTagForGradient) {
    }
    if (textField.tag == kTextFieldTagForSpeed) {
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
        if ([textField isEqual:self.speedView.dataTextField]) {
            [self caculatorClimbRateWithSpeed:wholeText rate:self.rateView.dataTextField.text gradient:self.gradientView.dataTextField.text];
        }
        if ([textField isEqual:self.rateView.dataTextField]) {
            [self caculatorClimbRateWithSpeed:self.speedView.dataTextField.text rate:wholeText gradient:self.gradientView.dataTextField.text];
        }
        if ([textField isEqual:self.gradientView.dataTextField]) {
            [self caculatorClimbRateWithSpeed:self.speedView.dataTextField.text rate:self.rateView.dataTextField.text gradient:wholeText];
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
    if (touchTextFieldTag == kTextFieldTagForGradient) {
        self.gradientView.decimalValue = number;
    }else if (touchTextFieldTag == kTextFieldTagForSpeed){
        self.speedView.decimalValue = number;
    }else if (touchTextFieldTag == kTextFieldTagForRate){
        self.rateView.decimalValue = number;
    }
    
    NSString *speedString = self.speedView.dataTextField.text;
    NSString *gradientString = self.gradientView.dataTextField.text;
    NSString *rateString = self.rateView.dataTextField.text;
    if (speedString == nil || [speedString isEqualToString:@""]) {
        speedString = @"0";
    }
    if (gradientString == nil || [gradientString isEqualToString:@""]) {
        gradientString = @"0";
    }
    if (rateString == nil || [rateString isEqualToString:@""]) {
        rateString = @"0";
    }
    if (calculatorTextFieldTag == kTextFieldTagForRate) {
        if ([speedString isEqualToString:@"0"]) {
            return;
        }
    }
    
   [self caculatorClimbRateWithSpeed:[NSDecimalNumber decimalNumberWithString:speedString] rate:[NSDecimalNumber decimalNumberWithString:rateString] gradient:[NSDecimalNumber decimalNumberWithString:gradientString]];
}

#pragma mark - calculator
- (void)caculatorClimbRateWithSpeed:(NSDecimalNumber *)speed rate:(NSDecimalNumber *)rate gradient:(NSDecimalNumber *)gradient
{
    NSDecimalNumber *resultValue = 0;

    if (calculatorTextFieldTag == kTextFieldTagForGradient) {
        resultValue = [EFBAviationCalculator calculatorClimbRateWithSpeed:speed rate:rate gradient:gradient rateOrGradient:@"Rate"];
    }
    if (calculatorTextFieldTag == kTextFieldTagForRate) {
        resultValue = [EFBAviationCalculator calculatorClimbRateWithSpeed:speed rate:rate gradient:gradient rateOrGradient:@"Gradient"];
    }
    
    if (calculatorTextFieldTag == kTextFieldTagForGradient) {
        self.rateView.decimalValue = resultValue;
    }
    if (calculatorTextFieldTag == kTextFieldTagForRate) {
        self.gradientView.decimalValue = resultValue;
    }
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
