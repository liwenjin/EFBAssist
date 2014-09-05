//
//  EFBDropDistanceViewController.m
//  hnaefb
//
//  Created by EFB on 13-8-26.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import "EFBDropDistanceViewController.h"
#import "EFBNumpadController.h"
#import "EFBAviationCalculator.h"

#define NUMBERS @"0123456789.\n"

typedef NS_ENUM(NSInteger, EFBDataTextFieldTag) {
    kTextFieldTagForGradient = 101,
    kTextFieldTagForSpeed,
    kTextFieldTagForFallHeight,
    kTextFieldTagForFallDistance
};

@interface EFBDropDistanceViewController ()<EFBNumpadDelegate>

@property (retain, nonatomic) IBOutlet UIImageView *backImage;
@property (retain, nonatomic) EFBNumpadController * numpad;
@property (assign, nonatomic) int touchTextFieldTag;

@end

@implementation EFBDropDistanceViewController
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
    [_gradientView release];
    [_speedView release];
    [_fallHeightView release];
    [_fallDistanceView release];
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
    CGRect rect2 = self.gradientView.frame;
    CGRect rect3 = self.speedView.frame;
    CGRect rect4 = self.fallHeightView.frame;
    CGRect rect5 = self.fallDistanceView.frame;
    
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
    self.gradientView.frame = rect2;
    self.speedView.frame = rect3;
    self.fallHeightView.frame = rect4;
    self.fallDistanceView.frame = rect5;
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
    if (touchTextFieldTag == kTextFieldTagForFallHeight) {
        if ([self.numpad isPopoverVisible]) {
            [self.numpad presentPopoverFromRect:self.fallHeightView.dataTextField.frame inView:self.fallHeightView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
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
    self.fallHeightView.dataTextField.text = @"";
    self.speedView.dataTextField.text = @"";
    self.fallDistanceView.dataTextField.text = @"";
}

#pragma mark - initViews
- (void)createViews
{
    self.conditionView = [self cellTitleName:NSLocalizedString(@"utilities-label-parameter", @"计算条件") andY:10];
    [self.view addSubview:self.conditionView];
    
    self.resultView = [self cellTitleName:NSLocalizedString(@"utilities-label-result", @"计算结果") andY:260];
    [self.view addSubview:self.resultView];
    
    self.directionsView = [self cellTitleName:@"计算说明" andY:275];
//    [self.view addSubview:self.directionsView];

    NSString *gradient = NSLocalizedString(@"utilities-label-Descent-Gradient", @"下降梯度");
    NSString *speed = NSLocalizedString(@"utilities-label-Ground-Speed", @"地速");
    NSString *descent = NSLocalizedString(@"utilities-label-Descent", @"下降高度");
    NSString *dropString = NSLocalizedString(@"utilities-btn-drop-distance", @"下降距离");
    
    self.gradientView = [self cellWithParameterName:[NSString stringWithFormat:@"%@(FT/MIN)",gradient] andY:80 andDataTextFiledType:kTextFieldForNormal];
    [self.view addSubview:self.gradientView];
    
    self.speedView = [self cellWithParameterName:[NSString stringWithFormat:@"%@(KT)",speed] andY:140 andDataTextFiledType:kTextFieldForNormal];
    [self.view addSubview:self.speedView];
    
    self.fallHeightView = [self cellWithParameterName:[NSString stringWithFormat:@"%@(FT)",descent] andY:200 andDataTextFiledType:kTextFieldForNormal];
    [self.view addSubview:self.fallHeightView];
    
    self.fallDistanceView = [self cellWithParameterName:[NSString stringWithFormat:@"%@(NM)",dropString] andY:330 andDataTextFiledType:kTextFieldForResult];
//    self.fallDistanceView.dataTextField.textColor = [UIColor whiteColor];
    [self.view addSubview:self.fallDistanceView];
}

- (EFBUtilitiesTitleCellView *)cellTitleName:(NSString *)title andY:(CGFloat)y
{
    float width = 485.0f;
    float height = 45.0f;
    EFBUtilitiesTitleCellView * calculatorCellView = [[[NSBundle mainBundle] loadNibNamed:@"EFBUtilitiesTitleCellView" owner:self options:nil] objectAtIndex:0];
    calculatorCellView.backgroundColor = [UIColor clearColor];
    calculatorCellView.frame = CGRectMake(0, y ,width,height);
    calculatorCellView.titleLable.text = [NSString stringWithFormat:@"%@", title];
    calculatorCellView.titleLable.textColor = TEXTCOLOR;//[UIColor colorWithRed:0/255.0 green:102/255.0 blue:102/255.0 alpha:1.0f];
    return calculatorCellView;
}

- (CalculatorCellView *)cellWithParameterName:(NSString *)parameterName andY:(CGFloat)y andDataTextFiledType:(EFBDataTextFieldType)aDataTextFieldType
{
    float width = 485.0f;
    float height = 40.0f;
    CalculatorCellView * calculatorCellView = [[[NSBundle mainBundle] loadNibNamed:@"CalculatorCellView" owner:self options:nil] objectAtIndex:0];
    [calculatorCellView setDataTextFieldType:aDataTextFieldType];
    calculatorCellView.backgroundColor = [UIColor clearColor];
    calculatorCellView.frame = CGRectMake(0, y ,width,height);
    calculatorCellView.parameterNameLabel.text = [NSString stringWithFormat:@"%@", parameterName];
    calculatorCellView.parameterNameLabel.textColor = TEXTCOLOR;//[UIColor colorWithRed:0/255.0 green:102/255.0 blue:102/255.0 alpha:1.0f];
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
    self.fallHeightView.dataTextField.tag = kTextFieldTagForFallHeight;
    self.speedView.dataTextField.tag = kTextFieldTagForSpeed;
    self.fallDistanceView.dataTextField.tag = kTextFieldTagForFallDistance;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    touchTextFieldTag = textField.tag;
    NSString *gradient = NSLocalizedString(@"utilities-label-Descent-Gradient", @"下降梯度");
    NSString *speed = NSLocalizedString(@"utilities-label-Ground-Speed", @"地速");
    NSString *descent = NSLocalizedString(@"utilities-label-Descent", @"下降高度");
    if (textField.tag == kTextFieldTagForGradient) {
        NSString *unitStr = [[[[self.gradientView.parameterNameLabel.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
        self.numpad = [[[EFBNumpadController alloc] initWithTitle:gradient unit:unitStr unitArray:nil] autorelease];
        self.numpad.unitString = unitStr;
        [self.numpad presentPopoverFromRect:textField.frame inView:self.gradientView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
    if (textField.tag == kTextFieldTagForSpeed) {
        NSString *unitStr = [[[[self.speedView.parameterNameLabel.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
        self.numpad = [[[EFBNumpadController alloc] initWithTitle:speed unit:unitStr unitArray:nil] autorelease];
        self.numpad.unitString = unitStr;
        [self.numpad presentPopoverFromRect:textField.frame inView:self.speedView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
    if (textField.tag == kTextFieldTagForFallHeight) {
        NSString *unitStr = [[[[self.fallHeightView.parameterNameLabel.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
        self.numpad = [[[EFBNumpadController alloc] initWithTitle:descent unit:unitStr unitArray:nil] autorelease];
        self.numpad.unitString = unitStr;
        [self.numpad presentPopoverFromRect:textField.frame inView:self.fallHeightView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
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
        [self.speedView.dataTextField becomeFirstResponder];
    }
    if (textField.tag == kTextFieldTagForSpeed) {
        [self.fallHeightView.dataTextField becomeFirstResponder];
    }
    if (textField.tag == kTextFieldTagForFallHeight) {
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
        if ([textField isEqual:self.gradientView.dataTextField]) {
             [self caculatorFallDistanceWithGradient:wholeText speed:self.speedView.dataTextField.text fallHeight:self.fallHeightView.dataTextField.text];
        }
        if ([textField isEqual:self.speedView.dataTextField]) {
            [self caculatorFallDistanceWithGradient:self.gradientView.dataTextField.text speed:wholeText fallHeight:self.fallHeightView.dataTextField.text];
        }
        if ([textField isEqual:self.fallHeightView.dataTextField]) {
            [self caculatorFallDistanceWithGradient:self.gradientView.dataTextField.text speed:self.speedView.dataTextField.text fallHeight:wholeText];
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
    }else if (touchTextFieldTag == kTextFieldTagForFallHeight){
        self.fallHeightView.decimalValue = number;
    }
    NSString *speed = NSLocalizedString(@"utilities-label-Ground-Speed", @"地速");
    NSString *descent = NSLocalizedString(@"utilities-label-Descent", @"下降高度");
    if (button == EFBNumpadButtonNext) {
        
        if (touchTextFieldTag == kTextFieldTagForGradient) {
            touchTextFieldTag = kTextFieldTagForSpeed;
            NSString *unitStr = [[[[self.speedView.parameterNameLabel.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
            self.numpad = [[[EFBNumpadController alloc] initWithTitle:speed unit:unitStr unitArray:nil] autorelease];
            self.numpad.unitString = unitStr;
            self.numpad.numPad.descriptionLabel.text = @"";//@"只允许输入-10000～10000的数字\nOnly numbers between -10000 and 10000 are allowed";
//            self.numpad.number = [NSNumber numberWithDouble:[self.speedView.dataTextField.text doubleValue]];
            NSString *text = self.speedView.dataTextField.text;
            if (text == nil || [text isEqualToString:@""]) {
                text = @"0";
            }
            self.numpad.number = [NSDecimalNumber decimalNumberWithString:text];

            self.numpad.numpadDelegate = self;
            
            [self.numpad presentPopoverFromRect:self.speedView.dataTextField.frame inView:self.speedView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
            
        }
        else if (touchTextFieldTag == kTextFieldTagForSpeed) {
            touchTextFieldTag = kTextFieldTagForFallHeight;
            NSString *unitStr = [[[[self.fallHeightView.parameterNameLabel.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
            self.numpad = [[[EFBNumpadController alloc] initWithTitle:descent unit:unitStr unitArray:nil] autorelease];
            self.numpad.unitString = unitStr;
            self.numpad.numPad.descriptionLabel.text = @"";//@"只允许输入-10000～10000的数字\nOnly numbers between -10000 and 10000 are allowed";
//            self.numpad.number = [NSNumber numberWithDouble:[self.fallHeightView.dataTextField.text doubleValue]];
            NSString *text = self.fallHeightView.dataTextField.text;
            if (text == nil || [text isEqualToString:@""]) {
                text = @"0";
            }
            self.numpad.number = [NSDecimalNumber decimalNumberWithString:text];
            self.numpad.numpadDelegate = self;
            
            [self.numpad presentPopoverFromRect:self.fallHeightView.dataTextField.frame inView:self.fallHeightView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
    }
    
    NSString *gradientString = self.gradientView.dataTextField.text;
    NSString *speedString = self.speedView.dataTextField.text;
    NSString *fallHeightString = self.fallHeightView.dataTextField.text;
    if (gradientString == nil || [gradientString isEqualToString:@""]) {
        gradientString = @"0";
    }
    if (speedString == nil || [speedString isEqualToString:@""]) {
        speedString = @"0";
    }
    if (fallHeightString == nil || [fallHeightString isEqualToString:@""]) {
        fallHeightString = @"0";
    }

    if ([gradientString isEqualToString:@"0"]) {
        return;
    }
     [self caculatorFallDistanceWithGradient:[NSDecimalNumber decimalNumberWithString:gradientString] speed:[NSDecimalNumber decimalNumberWithString:speedString] fallHeight:[NSDecimalNumber decimalNumberWithString:fallHeightString]];
}

#pragma mark - calculator
- (void)caculatorFallDistanceWithGradient:(NSDecimalNumber *)gradient speed:(NSDecimalNumber *)speed fallHeight:(NSDecimalNumber *)fallHeight
{
    NSDecimalNumber *fallDistanceNumber = [EFBAviationCalculator calculatorFallDistanceWithGradient:gradient speed:speed fallHeight:fallHeight];
    self.fallDistanceView.decimalValue = fallDistanceNumber;
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
