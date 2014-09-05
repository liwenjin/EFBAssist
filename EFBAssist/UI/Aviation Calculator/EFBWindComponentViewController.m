//
//  EFBWindComponentViewController.m
//  hnaefb
//
//  Created by EFB on 13-8-26.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import "EFBWindComponentViewController.h"
#import "EFBNumpadController.h"
#import "EFBAviationCalculator.h"
#import "EFBUnitSystem.h"

#define NUMBERS @"0123456789.\n"

typedef NS_ENUM(NSInteger, EFBDataTextFieldTag) {
    kTextFieldTagForWindDirection = 101,
    kTextFieldTagForRunwayDirection,
    kTextFieldTagForHeadOnWind,
    kTextFieldTagForLeftCrossWind
};

@interface EFBWindComponentViewController ()<EFBNumpadDelegate>

@property (retain, nonatomic) IBOutlet UIImageView *backImage;
@property (retain, nonatomic) EFBNumpadController * numpad;
@property (assign, nonatomic) int touchTextFieldTag;

@end

@implementation EFBWindComponentViewController
@synthesize metarWindView = _metarWindView;
@synthesize directionView = _directionView;
@synthesize windTrackView = _windTrackView;
@synthesize crossWindView = _crossWindView;
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
    [_resultView release];
    [_metarWindView release];
    [_directionView release];
    [_windTrackView release];
    [_crossWindView release];
    [_reasonLabel1 release];
    [_reasonLabel2 release];
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
    self.reasonLabel1.text = NSLocalizedString(@"utilities-reason-label-text", @"左为正，右为负");
    self.reasonLabel2.text = NSLocalizedString(@"utilities-reason-label-text1", @"顶为正，顺为负");
    self.reasonLabel1.frame = CGRectMake(47, 480, 391, 20);
    self.reasonLabel2.frame = CGRectMake(47, 500, 391, 20);
    self.reasonLabel1.textColor = TEXTCOLOR;//[UIColor colorWithRed:0/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    self.reasonLabel2.textColor = TEXTCOLOR;//[UIColor colorWithRed:0/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    
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

- (void)viewDidUnload
{
    [self setReasonLabel1:nil];
    [self setReasonLabel2:nil];
    [self setBackImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewWillLayoutSubviews
{
    float width = 592.0f;
    float view_origin_x = (CGRectGetWidth(self.view.frame)-width)/2;
    float origin_x = 0;
    CGRect rect = self.conditionView.frame;
    CGRect rect1 = self.resultView.frame;
    CGRect rect2 = self.metarWindView.frame;
    CGRect rect3 = self.directionView.frame;
    CGRect rect4 = self.windTrackView.frame;
    CGRect rect5 = self.crossWindView.frame;
    CGRect rect6 = self.directionsView.frame;

    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        origin_x = view_origin_x;
        
        self.reasonLabel1.frame = CGRectMake(view_origin_x +47, 475, 391, 20);
        self.reasonLabel2.frame = CGRectMake(view_origin_x +47, 495, 391, 25);
    }
    else{
        origin_x = 0;
        
        self.reasonLabel1.frame = CGRectMake(47, 480, 391, 20);
        self.reasonLabel2.frame = CGRectMake(47, 500, 391, 20);
    }
    
    rect.origin.x = origin_x;
    rect1.origin.x = origin_x;
    rect2.origin.x = origin_x;
    rect3.origin.x = origin_x;
    rect4.origin.x = origin_x;
    rect5.origin.x = origin_x;
    rect6.origin.x = origin_x;

    self.conditionView.frame = rect;
    self.resultView.frame = rect1;
    self.metarWindView.frame = rect2;
    self.directionView.frame = rect3;
    self.windTrackView.frame = rect4;
    self.crossWindView.frame = rect5;
    self.directionsView.frame = rect6;
}

#pragma mark - UIDeviceOrientationDidChangeNotification
- (void)didChangeStatusBarOrientationNotification
{
    if (touchTextFieldTag == kTextFieldTagForWindDirection) {
        if ([self.numpad isPopoverVisible]) {
            [self.numpad presentPopoverFromRect:self.metarWindView.dataTextField.frame inView:self.metarWindView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
    }
    if (touchTextFieldTag == kTextFieldTagForRunwayDirection) {
        if ([self.numpad isPopoverVisible]) {
            [self.numpad presentPopoverFromRect:self.directionView.dataTextField.frame inView:self.directionView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
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
    
    self.metarWindView.dataTextField.text = @"";
    self.directionView.dataTextField.text = @"";
    self.windTrackView.dataTextField.text = @"";
    self.crossWindView.dataTextField.text = @"";
}

#pragma mark - initViews
- (void)createViews
{
    self.conditionView = [self cellTitleName:NSLocalizedString(@"utilities-label-parameter", @"计算条件") andY:10];
    [self.view addSubview:self.conditionView];

    self.resultView = [self cellTitleName:NSLocalizedString(@"utilities-label-result", @"计算结果") andY:210];
     [self.view addSubview:self.resultView];
    
    self.directionsView = [self cellTitleName:NSLocalizedString(@"utilities-label-explanation", @"计算说明") andY:420];
    [self.view addSubview:self.directionsView];

    self.metarWindView = [self cellWithParameterName:NSLocalizedString(@"utilities-label-wind", @"气象风") andY:80 andDataTextFiledType:kTextFieldForNormal];
    [self.view addSubview:self.metarWindView];
    
    self.directionView = [self cellWithParameterName:NSLocalizedString(@"utilities-label-runwayDirection", @"跑道真方向") andY:140 andDataTextFiledType:kTextFieldForNormal];
    [self.view addSubview:self.directionView];
    
    self.windTrackView = [self cellWithParameterName:NSLocalizedString(@"utilities-label-HeadingWind", @"跑道风") andY:280 andDataTextFiledType:kTextFieldForResult];
//    self.windTrackView.dataTextField.textColor = [UIColor whiteColor];
    [self.view addSubview:self.windTrackView];
    
    self.crossWindView = [self cellWithParameterName:NSLocalizedString(@"utilities-label-leftCorssWind", @"侧风") andY:340 andDataTextFiledType:kTextFieldForResult];
//    self.crossWindView.dataTextField.textColor = [UIColor whiteColor];
    [self.view addSubview:self.crossWindView];
    
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
    self.metarWindView.dataTextField.tag = kTextFieldTagForWindDirection;
    self.directionView.dataTextField.tag = kTextFieldTagForRunwayDirection;
    self.windTrackView.dataTextField.tag = kTextFieldTagForHeadOnWind;
    self.crossWindView.dataTextField.tag = kTextFieldTagForLeftCrossWind;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    touchTextFieldTag = textField.tag;
    
    if (textField.tag == kTextFieldTagForWindDirection) {
        self.numpad = [[[EFBNumpadController alloc] initWindPadWithTitle:NSLocalizedString(@"utilities-label-wind", @"气象风")] autorelease];
        [self.numpad presentPopoverFromRect:textField.frame inView:self.metarWindView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        self.numpad.numPad.descriptionLabel.text = @"气象风前三位输入范围0～359的数字\nOnly numbers between 0 and 359 are allowed";
        self.numpad.numPad.displayTextField.text = textField.text;
        self.numpad.numPad.pointButton.enabled = NO;
        self.numpad.numPad.pOrNButton.enabled = NO;
        self.numpad.numpadDelegate = self;
    }
    if (textField.tag == kTextFieldTagForRunwayDirection) {
        self.numpad = [[[EFBNumpadController alloc] initWithTitle:NSLocalizedString(@"utilities-label-runwayDirection", @"跑道真方向") unit:@"" unitArray:nil] autorelease];
        self.numpad.unitString = @"";
        [self.numpad presentPopoverFromRect:textField.frame inView:self.directionView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        self.numpad.numPad.descriptionLabel.text = @"请输入0～360的数字\nOnly numbers between 0 and 360 are allowed";
        NSString *text = textField.text;
        if (text == nil || [text isEqualToString:@""]) {
            text = @"0";
        }
        self.numpad.number = [NSDecimalNumber decimalNumberWithString:text];
        self.numpad.numpadDelegate = self;
    }
    
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == kTextFieldTagForWindDirection) {
        [self.directionView.dataTextField becomeFirstResponder];
    }
    if (textField.tag == kTextFieldTagForRunwayDirection) {
        [textField resignFirstResponder];
//        [EFBFileHelper dismissKeyBoardForTextField];
    }
    return YES;
}

/**
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == kTextFieldTagForWindDirection) {
        if (range.location >= 5)
            return NO;
    }
    NSCharacterSet * characterSet;
    characterSet = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString * filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
    BOOL canChange = [string isEqualToString:filtered];
    NSString *wholeText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (canChange) {
        if ([textField isEqual:self.metarWindView.dataTextField]) {
            [self caculatorWindWithRunwayDirection:wholeText windDirection:self.directionView.dataTextField.text];
        }
        if ([textField isEqual:self.directionView.dataTextField]) {
             [self caculatorWindWithRunwayDirection:self.metarWindView.dataTextField.text windDirection:wholeText];
        }
    }
    return canChange;
}
*/

#pragma mark - EFBNumpadDelegate
- (BOOL)numpadShouldFinishInput:(EFBNumpadController *)numpad
{
    CGFloat fValue = [numpad.number floatValue];
    if (touchTextFieldTag == kTextFieldTagForWindDirection) {
        NSString *text = numpad.numPad.displayTextField.text;
        if ([text length] == 5)
        {
            CGFloat runwayValue = [[text substringWithRange:NSMakeRange(0, 3)] floatValue];
            if ( runwayValue >= 0.0f && runwayValue<=359.0f) {
                return YES;
            }
            return NO;
        }else{
            if ( fValue >= 0.0f && fValue<=9999.0f) {
                return YES;
            }
            self.numpad.numPad.descriptionLabel.text = @"输入无效\nInvalid Input";
            return NO;
        }
    }
    if (touchTextFieldTag == kTextFieldTagForRunwayDirection) {
        if ( fValue >= 0.0f && fValue<=360.0f) {
            return YES;
        }
        return NO;
    }
    
    return YES;
}

- (void)numpad:(EFBNumpadController *)numpad dismissedWithButton:(EFBNumpadButton)button
{
    NSDecimalNumber * number = numpad.number;
    if (touchTextFieldTag == kTextFieldTagForWindDirection) {
        if ([numpad.numPad.displayTextField.text length] < 5 && numpad.numPad.displayTextField.text !=nil && ![numpad.numPad.displayTextField.text isEqualToString:@""]) {
            self.metarWindView.parameterNameLabel.text = NSLocalizedString(@"utilities-label-windSpeed", @"风速");
            self.directionView.parameterNameLabel.text = NSLocalizedString(@"utilities-label-windDirection", @"夹角");
            self.windTrackView.parameterNameLabel.text = NSLocalizedString(@"utilities-label-headonWind", @"有效风");
        }else{
            self.metarWindView.parameterNameLabel.text = NSLocalizedString(@"utilities-label-wind", @"气象风");
            self.directionView.parameterNameLabel.text = NSLocalizedString(@"utilities-label-runwayDirection", @"跑道真方向");
            self.windTrackView.parameterNameLabel.text = NSLocalizedString(@"utilities-label-HeadingWind", @"跑道风");
        }
        self.metarWindView.dataTextField.text = numpad.numPad.displayTextField.text;//[number description];
    }else if (touchTextFieldTag == kTextFieldTagForRunwayDirection){
        self.directionView.decimalValue   = number;
    }    
    if (touchTextFieldTag == kTextFieldTagForWindDirection && button == EFBNumpadButtonNext) {
        
        touchTextFieldTag = kTextFieldTagForRunwayDirection;
        NSString *title = NSLocalizedString(@"utilities-label-runwayDirection", @"跑道真方向");
        if ([numpad.numPad.displayTextField.text length] < 5 && numpad.numPad.displayTextField.text !=nil && ![numpad.numPad.displayTextField.text isEqualToString:@""])
        {
            title = NSLocalizedString(@"utilities-label-windDirection", @"夹角");
        }
        self.numpad = [[[EFBNumpadController alloc] initWithTitle:title unit:@"" unitArray:nil] autorelease];
        self.numpad.unitString = @"";
        self.numpad.numPad.descriptionLabel.text = @"请输入0～360的数字\nOnly numbers between 0 and 360 are allowed";
//        self.numpad.number = [NSNumber numberWithDouble:[self.directionView.dataTextField.text doubleValue]];
        NSString *text = self.directionView.dataTextField.text;
        if (text == nil || [text isEqualToString:@""]) {
            text = @"0";
        }
        self.numpad.number = [NSDecimalNumber decimalNumberWithString:text];

        self.numpad.numpadDelegate = self;
        
        [self.numpad presentPopoverFromRect:self.directionView.dataTextField.frame inView:self.directionView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
    
    NSString *windString = self.metarWindView.dataTextField.text;
    NSString *directionString = self.directionView.dataTextField.text;
    
    if (windString == nil || [windString isEqualToString:@""]) {
        windString = @"0";
    }
    if (directionString == nil || [directionString isEqualToString:@""]) {
        directionString = @"0";
    }
    [self caculatorWindWithRunwayDirection:[NSDecimalNumber decimalNumberWithString:directionString] windDirection:[NSDecimalNumber decimalNumberWithString:windString]];
}

#pragma mark - calculator
- (void)caculatorWindWithRunwayDirection:(NSDecimalNumber *)runwayDirection windDirection:(NSDecimalNumber *)windDirection
{
    NSDecimalNumber *headOnWindValue = [EFBAviationCalculator calculatorRunWayWindWithRunwayDirection:runwayDirection wind:windDirection];
    NSDecimalNumber *leftCrossWindValue = [EFBAviationCalculator calculatorCrossWindWithRunwayDirection:runwayDirection wind:windDirection];
    
    self.windTrackView.decimalValue = [EFBUnitSystem notRounding:headOnWindValue afterPoint:2];
    self.crossWindView.decimalValue = [EFBUnitSystem notRounding:leftCrossWindValue afterPoint:2];
}

@end
