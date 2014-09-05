//
//  EFBISATemperatureViewController.m
//  hnaefb
//
//  Created by EFB on 13-8-23.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import "EFBISATemperatureViewController.h"
#import "EFBAviationCalculator.h"
#import "EFBUnitSystem.h"

#define NUMBERS @"0123456789.\n"

typedef NS_ENUM(NSInteger, EFBDataTextFieldTag) {
    kTextFieldTagForOAT = 101,
    kTextFieldTagForElevation,
    kTextFieldTagForISADelta,
    kTextFieldTagForISA
};

typedef NS_ENUM(NSInteger, EFBUnitButtonTag) {
    kUnitButtonTagForOAT = 201,
    kUnitButtonTagForElevation
};

@interface EFBISATemperatureViewController ()<EFBNumpadDelegate>
@property (retain, nonatomic) IBOutlet UIImageView *backImage;

@property (retain, nonatomic) EFBNumpadController * numpad;
@property (assign, nonatomic) int touchTextFieldTag;
@property (copy, nonatomic) NSString *OATUnit;
@property (copy, nonatomic) NSString *elevationUnit;
@end

@implementation EFBISATemperatureViewController
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
    [_directionView release];
    [_conditionView release];
    [_resultView release];
    [_OATView release];
    [_elevationView release];
    [_ISADeltaView release];
    [_ISAView release];
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
    CGRect rect2 = self.OATView.frame;
    CGRect rect3 = self.elevationView.frame;
    CGRect rect4 = self.ISADeltaView.frame;
    CGRect rect5 = self.ISAView.frame;
    
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
    self.OATView.frame = rect2;
    self.elevationView.frame = rect3;
    self.ISADeltaView.frame = rect4;
    self.ISAView.frame = rect5;
}

#pragma mark - UIDeviceOrientationDidChangeNotification
- (void)didChangeStatusBarOrientationNotification
{
    if (touchTextFieldTag == kTextFieldTagForOAT) {
        if ([self.numpad isPopoverVisible]) {
            [self.numpad presentPopoverFromRect:self.OATView.dataTextField.frame inView:self.OATView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
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
#pragma mark - clear TextField
- (IBAction)clearButtonDidSelected:(id)sender{
    self.OATView.dataTextField.text = @"";
    self.elevationView.dataTextField.text = @"";
    self.ISADeltaView.dataTextField.text = @"";
    self.ISAView.dataTextField.text = @"";
}

#pragma mark - initViews
- (void)createViews
{
    
    self.conditionView = [self cellTitleName:NSLocalizedString(@"utilities-label-parameter", @"计算条件") andY:10];
    [self.view addSubview:self.conditionView];
    
    self.resultView = [self cellTitleName:NSLocalizedString(@"utilities-label-result", @"计算结果") andY:260];
    [self.view addSubview:self.resultView];
    
    self.directionView = [self cellTitleName:@"计算说明" andY:280];
//    [self.view addSubview:self.directionView];
    
    self.OATView = [self cellWithParameterName:@"OAT (˚C)" andY:80 andDataTextFiledType:kTextFieldForNormal];
    [self.view addSubview:self.OATView];
    
    self.elevationView = [self cellWithParameterName:@"Elevation (m)" andY:140 andDataTextFiledType:kTextFieldForNormal];
    [self.view addSubview:self.elevationView];
    
    self.ISADeltaView = [self cellWithParameterName:@"ISA + Delta T" andY:330 andDataTextFiledType:kTextFieldForResult];
//    self.ISADeltaView.dataTextField.textColor = [UIColor whiteColor];
    [self.view addSubview:self.ISADeltaView];
    
    self.ISAView = [self cellWithParameterName:@"ISA T" andY:390 andDataTextFiledType:kTextFieldForResult];
//    self.ISAView.dataTextField.textColor = [UIColor whiteColor];
    [self.view addSubview:self.ISAView];
    
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
//    [self setTagForUnitButton];
}

-(void)setTagForTextField
{
    self.OATView.dataTextField.tag = kTextFieldTagForOAT;
    self.elevationView.dataTextField.tag = kTextFieldTagForElevation;
    self.ISADeltaView.dataTextField.tag = kTextFieldTagForISADelta;
    self.ISAView.dataTextField.tag = kTextFieldTagForISA;
}

//-(void)setTagForUnitButton
//{
//    self.OATView.unitButton.tag = kUnitButtonTagForOAT;
//    self.elevationView.unitButton.tag = kUnitButtonTagForElevation;
//}

#pragma mark - CalculatorCellViewDelegate
- (void)addChoosePickerInViewWithUnitButtonTag:(int)unitButtonTag :(id)idObj
{
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    touchTextFieldTag = textField.tag;
    
    if (textField.tag == kTextFieldTagForOAT) {
        NSArray *array = @[@"˚C",@"˚F"];
         NSString *unitStr = [[[[self.OATView.parameterNameLabel.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
        self.OATUnit = unitStr;
        self.numpad = [[[EFBNumpadController alloc] initWithTitle:@"OAT" unit:unitStr unitArray:array] autorelease];
        self.numpad.unitString = unitStr;
        [self.numpad presentPopoverFromRect:textField.frame inView:self.OATView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
    if (textField.tag == kTextFieldTagForElevation) {
        
        NSArray *array = @[@"m",@"ft"];
        NSString *unitStr = [[[[self.elevationView.parameterNameLabel.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
        self.elevationUnit = unitStr;
        self.numpad = [[[EFBNumpadController alloc] initWithTitle:@"Elevation" unit:unitStr unitArray:array] autorelease];
        self.numpad.unitString = unitStr;
        [self.numpad presentPopoverFromRect:textField.frame inView:self.elevationView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
    
    self.numpad.numPad.descriptionLabel.text = @"";//@"只允许输入-10000～10000的数字\nOnly numbers between -10000 and 10000 are allowed";
    NSString *textFieldText = textField.text;
    if (textFieldText == nil || [textFieldText isEqualToString:@""]) {
        textFieldText = @"0";
    }
    self.numpad.number = [NSDecimalNumber decimalNumberWithString:textFieldText];
    self.numpad.numpadDelegate = self;
    
    return NO;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
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
        if ([textField isEqual:self.OATView.dataTextField]) {
            [self caculatorISATemperatureWithOAT:wholeText elevation:self.elevationView.dataTextField.text];
        }
        if ([textField isEqual:self.elevationView.dataTextField]) {
            [self caculatorISATemperatureWithOAT:self.OATView.dataTextField.text elevation:wholeText];
        }
    }
    
    return canChange;
}
*/

#pragma mark - EFBNumpadDelegate
- (BOOL)numpadShouldFinishInput:(EFBNumpadController *)numpad
{
    CGFloat fValue = [numpad.number floatValue];
    if (touchTextFieldTag != kTextFieldTagForOAT) {
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
    if (touchTextFieldTag == kTextFieldTagForOAT) {
        self.OATView.decimalValue = number;
        self.OATView.parameterNameLabel.text = [NSString stringWithFormat:@"OAT (%@)",string];
        self.OATUnit = string;
    }else{
        self.elevationView.decimalValue = number;
        self.elevationView.parameterNameLabel.text = [NSString stringWithFormat:@"Elevation (%@)",string];
        self.elevationUnit = string;
    }
    
    if (touchTextFieldTag == kTextFieldTagForOAT && button == EFBNumpadButtonNext) {
        touchTextFieldTag = kTextFieldTagForElevation;

        NSArray *array = @[@"m",@"ft"];
        NSString *unitStr = [[[[self.elevationView.parameterNameLabel.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
        self.elevationUnit = unitStr;
        self.numpad = [[[EFBNumpadController alloc] initWithTitle:@"Elevation" unit:unitStr unitArray:array] autorelease];
        self.numpad.unitString = unitStr;
        self.numpad.numPad.descriptionLabel.text = @"";//@"只允许输入-10000～10000的数字\nOnly numbers between -10000 and 10000 are allowed";
        NSString *textFieldText = self.elevationView.dataTextField.text;
        if (textFieldText == nil || [textFieldText isEqualToString:@""]) {
            textFieldText = @"0";
        }
        self.numpad.number = [NSDecimalNumber decimalNumberWithString:textFieldText];
        //[NSNumber numberWithDouble:[self.elevationView.dataTextField.text doubleValue]];
        self.numpad.numpadDelegate = self;
        
        [self.numpad presentPopoverFromRect:self.elevationView.dataTextField.frame inView:self.elevationView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];

    }
    
    NSString *OATString = self.OATView.dataTextField.text;
    NSString *elevationString = self.elevationView.dataTextField.text;
    if (OATString == nil || [OATString isEqualToString:@""]) {
        OATString = @"0";
    }
    if (elevationString == nil || [elevationString isEqualToString:@""]) {
        elevationString = @"0";
    }
    [self caculatorISATemperatureWithOAT:[NSDecimalNumber decimalNumberWithString:OATString] andElevation:[NSDecimalNumber decimalNumberWithString:elevationString]];
}

#pragma mark - calculator
- (void)caculatorISATemperatureWithOAT:(NSDecimalNumber *)oat andElevation:(NSDecimalNumber *)elevation
{
    NSDecimalNumber *standardOAT = [EFBUnitSystem standardScaleForTemperature:self.OATUnit scale:oat];
    NSDecimalNumber *standardElevation = [EFBUnitSystem standardScaleForDistance:self.elevationUnit scale:elevation];
    
    NSDecimalNumber *ISADeltaNumber = [EFBAviationCalculator calculatorISATemperatureDeltaWithOAT:standardOAT elevation:standardElevation];
    
    NSDecimalNumber *ISATNumber = [EFBAviationCalculator calculatorISATemperatureISATWithOAT:standardOAT elevation:standardElevation];
    
    self.ISADeltaView.decimalValue = [EFBUnitSystem notRounding:ISADeltaNumber afterPoint:2];
    self.ISAView.decimalValue = [EFBUnitSystem notRounding:ISATNumber afterPoint:2];
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
