//
//  EFBDistanceTranslatedViewController.m
//  hnaefb
//
//  Created by EFB on 13-9-6.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import "EFBDistanceTranslatedViewController.h"
#import "EFBNumpadController.h"
#import "EFBUnitSystem.h"

#define NUMBERS @"0123456789.\n"

typedef NS_ENUM(NSInteger, EFBDataTextFieldTag) {
    kTextFieldTagForM = 101,
    kTextFieldTagForKm,
    kTextFieldTagForNmi,
    kTextFieldTagForMi,
    kTextFieldTagForFt,
    kTextFieldTagForIn
};

@interface EFBDistanceTranslatedViewController ()<EFBNumpadDelegate>

@property (retain, nonatomic) EFBNumpadController * numpad;
@property (assign, nonatomic) int touchTextFieldTag;
@property (retain, nonatomic) UITextField *touchTextField;

@end

@implementation EFBDistanceTranslatedViewController
@synthesize touchTextFieldTag;

#pragma mark - view lifecycle
- (void)dealloc {
    [_numpad release];
    [_touchTextField release];
    [_metricSystemView release];
    [_inchView release];
    [_mView release];
    [_nmiView release];
    [_miView release];
    [_ftView release];
    [_inView release];
    [_kmView release];
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
    self.backImage.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
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

#pragma mark - UIDeviceOrientationDidChangeNotification
- (void)didChangeStatusBarOrientationNotification
{
    if (touchTextFieldTag == kTextFieldTagForM) {
        if ([self.numpad isPopoverVisible]) {
            [self.numpad presentPopoverFromRect:self.mView.dataTextField.frame inView:self.mView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
    }
    if (touchTextFieldTag == kTextFieldTagForKm) {
        if ([self.numpad isPopoverVisible]) {
            [self.numpad presentPopoverFromRect:self.kmView.dataTextField.frame inView:self.kmView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
    }
    if (touchTextFieldTag == kTextFieldTagForNmi) {
        if ([self.numpad isPopoverVisible]) {
            [self.numpad presentPopoverFromRect:self.nmiView.dataTextField.frame inView:self.nmiView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
    }
    if (touchTextFieldTag == kTextFieldTagForMi) {
        if ([self.numpad isPopoverVisible]) {
            [self.numpad presentPopoverFromRect:self.miView.dataTextField.frame inView:self.miView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
    }
    if (touchTextFieldTag == kTextFieldTagForFt) {
        if ([self.numpad isPopoverVisible]) {
            [self.numpad presentPopoverFromRect:self.ftView.dataTextField.frame inView:self.ftView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
    }
    if (touchTextFieldTag == kTextFieldTagForIn) {
        if ([self.numpad isPopoverVisible]) {
            [self.numpad presentPopoverFromRect:self.inView.dataTextField.frame inView:self.inView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
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

    self.nmiView.dataTextField.text = @"";
    self.miView.dataTextField.text = @"";
    self.mView.dataTextField.text = @"";
    self.kmView.dataTextField.text = @"";
    self.ftView.dataTextField.text = @"";
    self.inView.dataTextField.text = @"";
}

#pragma mark - initViews
- (void)createViews
{
    self.metricSystemView = [self cellTitleName:NSLocalizedString(@"utilities-metric-system",@"公制") andY:10];
    [self.view addSubview:self.metricSystemView];
    
    self.inchView = [self cellTitleName:NSLocalizedString(@"utilities-inch-system",@"英制") andY:205];
    [self.view addSubview:self.inchView];
    
    self.mView = [self cellWithParameterName:@"米 (m)" andY:80 andDataTextFiledType:kTextFieldForNormal];
    [self.view addSubview:self.mView];
    
    self.kmView = [self cellWithParameterName:@"千米 (km)" andY:140 andDataTextFiledType:kTextFieldForNormal];
    [self.view addSubview:self.kmView];
    
    self.nmiView = [self cellWithParameterName:@"海里 (nmi)" andY:275 andDataTextFiledType:kTextFieldForNormal];
    [self.view addSubview:self.nmiView];
    
    self.miView = [self cellWithParameterName:@"英里 (mi)" andY:335 andDataTextFiledType:kTextFieldForNormal];
    [self.view addSubview:self.miView];
    
    self.ftView = [self cellWithParameterName:@"英尺 (ft)" andY:395 andDataTextFiledType:kTextFieldForNormal];
    [self.view addSubview:self.ftView];
    
    self.inView = [self cellWithParameterName:@"英寸 (in)" andY:455 andDataTextFiledType:kTextFieldForNormal];
    [self.view addSubview:self.inView];
    
}

- (void)viewWillLayoutSubviews
{
    float width = 592.0f;
    float view_origin_x = (CGRectGetWidth(self.view.frame)-width)/2;
    float origin_x = 0;
    CGRect rect = self.metricSystemView.frame;
    CGRect rect1 = self.inchView.frame;
    CGRect rect2 = self.mView.frame;
    CGRect rect3 = self.kmView.frame;
    CGRect rect4 = self.nmiView.frame;
    CGRect rect5 = self.miView.frame;
    CGRect rect6 = self.ftView.frame;
    CGRect rect7 = self.inView.frame;
    
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
    rect6.origin.x = origin_x;
    rect7.origin.x = origin_x;
    
    self.metricSystemView.frame = rect;
    self.inchView.frame = rect1;
    self.mView.frame = rect2;
    self.kmView.frame = rect3;
    self.nmiView.frame = rect4;
    self.miView.frame = rect5;
    self.ftView.frame = rect6;
    self.inView.frame = rect7;
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
    self.mView.dataTextField.tag = kTextFieldTagForM;
    self.kmView.dataTextField.tag = kTextFieldTagForKm;
    self.nmiView.dataTextField.tag = kTextFieldTagForNmi;
    self.miView.dataTextField.tag = kTextFieldTagForMi;
    self.ftView.dataTextField.tag = kTextFieldTagForFt;
    self.inView.dataTextField.tag = kTextFieldTagForIn;
}

# pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.mView setDataTextFieldType:kTextFieldForNormal];
    [self.kmView setDataTextFieldType:kTextFieldForNormal];
    [self.nmiView setDataTextFieldType:kTextFieldForNormal];
    [self.miView setDataTextFieldType:kTextFieldForNormal];
    [self.ftView setDataTextFieldType:kTextFieldForNormal];
    [self.inView setDataTextFieldType:kTextFieldForNormal];
    
    self.touchTextField = textField;
    touchTextFieldTag = textField.tag;
    
    switch (textField.tag) {
        case kTextFieldTagForM:
        {
            [self.mView setDataTextFieldType:kTextFieldForInput];
            
            NSString *unitStr = [[[[self.mView.parameterNameLabel.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
            self.numpad = [[[EFBNumpadController alloc] initWithTitle:@"米 (m)" unit:unitStr unitArray:nil] autorelease];
            self.numpad.unitString = unitStr;
            [self.numpad presentPopoverFromRect:textField.frame inView:self.mView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
            break;
        case kTextFieldTagForKm:
        {
            [self.kmView setDataTextFieldType:kTextFieldForInput];
            
            NSString *unitStr = [[[[self.kmView.parameterNameLabel.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
            self.numpad = [[[EFBNumpadController alloc] initWithTitle:@"千米 (km)" unit:unitStr unitArray:nil] autorelease];
            self.numpad.unitString = unitStr;
            [self.numpad presentPopoverFromRect:textField.frame inView:self.kmView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
            break;
        case kTextFieldTagForNmi:
        {
            [self.nmiView setDataTextFieldType:kTextFieldForInput];
            NSString *unitStr = [[[[self.nmiView.parameterNameLabel.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
            self.numpad = [[[EFBNumpadController alloc] initWithTitle:@"海里 (nmi)" unit:unitStr unitArray:nil] autorelease];
            self.numpad.unitString = unitStr;
            [self.numpad presentPopoverFromRect:textField.frame inView:self.nmiView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
            break;
        case kTextFieldTagForMi:
        {
            [self.miView setDataTextFieldType:kTextFieldForInput];
            NSString *unitStr = [[[[self.miView.parameterNameLabel.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
            self.numpad = [[[EFBNumpadController alloc] initWithTitle:@"英里 (mi)" unit:unitStr unitArray:nil] autorelease];
            self.numpad.unitString = unitStr;
            [self.numpad presentPopoverFromRect:textField.frame inView:self.miView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
            break;
        case kTextFieldTagForFt:
        {
            [self.ftView setDataTextFieldType:kTextFieldForInput];
            NSString *unitStr = [[[[self.ftView.parameterNameLabel.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
            self.numpad = [[[EFBNumpadController alloc] initWithTitle:@"英尺 (ft)" unit:unitStr unitArray:nil] autorelease];
            self.numpad.unitString = unitStr;
            [self.numpad presentPopoverFromRect:textField.frame inView:self.ftView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
            break;
        case kTextFieldTagForIn:
        {
            [self.inView setDataTextFieldType:kTextFieldForInput];
            NSString *unitStr = [[[[self.inView.parameterNameLabel.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
            self.numpad = [[[EFBNumpadController alloc] initWithTitle:@"英寸 (in)" unit:unitStr unitArray:nil] autorelease];
            self.numpad.unitString = unitStr;
            [self.numpad presentPopoverFromRect:textField.frame inView:self.inView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
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
            self.mView.dataTextField.text = @"";
            self.kmView.dataTextField.text = @"";
            self.nmiView.dataTextField.text = @"";
            self.miView.dataTextField.text = @"";
            self.ftView.dataTextField.text = @"";
            self.inView.dataTextField.text = @"";
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
        case kTextFieldTagForM:
        {
            self.mView.decimalValue = number;
        }
            break;
        case kTextFieldTagForKm:
        {
            self.kmView.decimalValue = number;
        }
            break;
        case kTextFieldTagForNmi:
        {
           self.nmiView.decimalValue = number;
        }
            break;
        case kTextFieldTagForMi:
        {
            self.miView.decimalValue = number;
        }
            break;
        case kTextFieldTagForFt:
        {
           self.ftView.decimalValue = number;
        }
            break;
        case kTextFieldTagForIn:
        {
            self.inView.decimalValue = number;
        }
            break;
        default:
            break;
    }

    [self caculatorWeightTranslatedWithCondition:number textFieldTag:touchTextFieldTag];
    
}

#define UNITForM             @"m"
#define UNITForKm            @"km"
#define UNITForNmi           @"nmi"
#define UNITForMi            @"mi"
#define UNITForFt            @"ft"
#define UNITForIn            @"in"

#pragma mark - calculator
-(void)caculatorWeightTranslatedWithCondition:(NSDecimalNumber *)condition textFieldTag:(int)tag
{
    switch (tag) {
        case kTextFieldTagForM:
        {
            NSDecimalNumber *value = [EFBUnitSystem unitScaleForDistance:UNITForKm standardScale:condition];
            NSDecimalNumber *value1 = [EFBUnitSystem unitScaleForDistance:UNITForNmi standardScale:condition];
            NSDecimalNumber *value2 = [EFBUnitSystem unitScaleForDistance:UNITForMi standardScale:condition];
            NSDecimalNumber *value3 = [EFBUnitSystem unitScaleForDistance:UNITForFt standardScale:condition];
            NSDecimalNumber *value4 = [EFBUnitSystem unitScaleForDistance:UNITForIn standardScale:condition];
            
            self.kmView.dataTextField.text = [EFBUnitSystem NotRounding:value afterPoint:10];
            self.nmiView.dataTextField.text = [EFBUnitSystem NotRounding:value1 afterPoint:10];
            self.miView.dataTextField.text = [EFBUnitSystem NotRounding:value2 afterPoint:10];
            self.ftView.dataTextField.text = [EFBUnitSystem NotRounding:value3 afterPoint:10];
            self.inView.dataTextField.text = [EFBUnitSystem NotRounding:value4 afterPoint:10];
        }
            break;
        case kTextFieldTagForKm:
        {
            NSDecimalNumber *value = [EFBUnitSystem standardScaleForDistance:UNITForKm scale:condition];
            NSDecimalNumber *value1 = [EFBUnitSystem unitScaleForDistance:UNITForNmi standardScale:value];
            NSDecimalNumber *value2 = [EFBUnitSystem unitScaleForDistance:UNITForMi standardScale:value];
            NSDecimalNumber *value3 = [EFBUnitSystem unitScaleForDistance:UNITForFt standardScale:value];
            NSDecimalNumber *value4 = [EFBUnitSystem unitScaleForDistance:UNITForIn standardScale:value];
            
            self.mView.dataTextField.text = [EFBUnitSystem NotRounding:value afterPoint:10];
            self.nmiView.dataTextField.text = [EFBUnitSystem NotRounding:value1 afterPoint:10];
            self.miView.dataTextField.text = [EFBUnitSystem NotRounding:value2 afterPoint:10];
            self.ftView.dataTextField.text = [EFBUnitSystem NotRounding:value3 afterPoint:7];
            self.inView.dataTextField.text = [EFBUnitSystem NotRounding:value4 afterPoint:7];
        }
            break;
        case kTextFieldTagForNmi:
        {
            NSDecimalNumber *value = [EFBUnitSystem standardScaleForDistance:UNITForNmi scale:condition];
            NSDecimalNumber *value1 = [EFBUnitSystem unitScaleForDistance:UNITForKm standardScale:value];
            NSDecimalNumber *value2 = [EFBUnitSystem unitScaleForDistance:UNITForMi standardScale:value];
            NSDecimalNumber *value3 = [EFBUnitSystem unitScaleForDistance:UNITForFt standardScale:value];
            NSDecimalNumber *value4 = [EFBUnitSystem unitScaleForDistance:UNITForIn standardScale:value];
            
            self.mView.dataTextField.text = [EFBUnitSystem NotRounding:value afterPoint:10];
            self.kmView.dataTextField.text = [EFBUnitSystem NotRounding:value1 afterPoint:10];
            self.miView.dataTextField.text = [EFBUnitSystem NotRounding:value2 afterPoint:10];
            self.ftView.dataTextField.text = [EFBUnitSystem NotRounding:value3 afterPoint:7];
            self.inView.dataTextField.text = [EFBUnitSystem NotRounding:value4 afterPoint:7];
        }
            break;
        case kTextFieldTagForMi:
        {
            NSDecimalNumber *value = [EFBUnitSystem standardScaleForDistance:UNITForMi scale:condition];
            NSDecimalNumber *value1 = [EFBUnitSystem unitScaleForDistance:UNITForKm standardScale:value];
            NSDecimalNumber *value2 = [EFBUnitSystem unitScaleForDistance:UNITForNmi standardScale:value];
            NSDecimalNumber *value3 = [EFBUnitSystem unitScaleForDistance:UNITForFt standardScale:value];
            NSDecimalNumber *value4 = [EFBUnitSystem unitScaleForDistance:UNITForIn standardScale:value];
            
            self.mView.dataTextField.text = [EFBUnitSystem NotRounding:value afterPoint:10];
            self.kmView.dataTextField.text = [EFBUnitSystem NotRounding:value1 afterPoint:10];
            self.nmiView.dataTextField.text = [EFBUnitSystem NotRounding:value2 afterPoint:10];
            self.ftView.dataTextField.text = [EFBUnitSystem NotRounding:value3 afterPoint:10];
            self.inView.dataTextField.text = [EFBUnitSystem NotRounding:value4 afterPoint:10];
        }
            break;
        case kTextFieldTagForFt:
        {
            NSDecimalNumber *value = [EFBUnitSystem standardScaleForDistance:UNITForFt scale:condition];
            NSDecimalNumber *value1 = [EFBUnitSystem unitScaleForDistance:UNITForKm standardScale:value];
            NSDecimalNumber *value2 = [EFBUnitSystem unitScaleForDistance:UNITForNmi standardScale:value];
            NSDecimalNumber *value3 = [EFBUnitSystem unitScaleForDistance:UNITForMi standardScale:value];
            NSDecimalNumber *value4 = [EFBUnitSystem unitScaleForDistance:UNITForIn standardScale:value];
            
            self.mView.dataTextField.text = [EFBUnitSystem NotRounding:value afterPoint:10];
            self.kmView.dataTextField.text = [EFBUnitSystem NotRounding:value1 afterPoint:10];
            self.nmiView.dataTextField.text = [EFBUnitSystem NotRounding:value2 afterPoint:10];
            self.miView.dataTextField.text = [EFBUnitSystem NotRounding:value3 afterPoint:10];
            self.inView.dataTextField.text = [EFBUnitSystem NotRounding:value4 afterPoint:10];
        }
            break;
        case kTextFieldTagForIn:
        {
            NSDecimalNumber *value = [EFBUnitSystem standardScaleForDistance:UNITForIn scale:condition];
            NSDecimalNumber *value1 = [EFBUnitSystem unitScaleForDistance:UNITForKm standardScale:value];
            NSDecimalNumber *value2 = [EFBUnitSystem unitScaleForDistance:UNITForNmi standardScale:value];
            NSDecimalNumber *value3 = [EFBUnitSystem unitScaleForDistance:UNITForMi standardScale:value];
            NSDecimalNumber *value4 = [EFBUnitSystem unitScaleForDistance:UNITForFt standardScale:value];

            self.mView.dataTextField.text = [EFBUnitSystem NotRounding:value afterPoint:10];
            self.kmView.dataTextField.text = [EFBUnitSystem NotRounding:value1 afterPoint:10];
            self.nmiView.dataTextField.text = [EFBUnitSystem NotRounding:value2 afterPoint:10];
            self.miView.dataTextField.text = [EFBUnitSystem NotRounding:value3 afterPoint:10];
            self.ftView.dataTextField.text = [EFBUnitSystem NotRounding:value4 afterPoint:10];
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
