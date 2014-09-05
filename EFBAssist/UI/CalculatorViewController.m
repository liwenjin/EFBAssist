//
//  CalculatorViewController.m
//  EFBCalculator
//
//  Created by  on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import <UIApplication+EFB.h>


@interface CalculatorViewController()

@property (nonatomic, copy) NSString *firstNumber;
@property (nonatomic, copy) NSString *secondNumber;

- (void)convertNumber;
- (NSString *)formatDouble:(NSString *)number;

@end

@implementation CalculatorViewController

@synthesize firstNumber = _firstNumber;
@synthesize secondNumber = _secondNumber;
@synthesize leftResultField;
@synthesize rightResultField;
@synthesize leftUnitLabel;
@synthesize rightUnitLabel;
@synthesize leftDescLabel;
@synthesize rightDescLabel;
@synthesize contentView;
@synthesize contentViewLandscape;
@synthesize leftDescLabelLandscape,rightDescLabelLandscape,leftUnitLabelLandscape,rightUnitLabelLandscape,leftResultFieldLandscape,rightResultFieldLandscape;
@synthesize strRetrunFirst,strRetrunSecod;
@synthesize imagebgLandscape = _imagebgLandscape;
@synthesize imagebg = _imagebg;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (id)init
{
    
    self = [super init];
    if (self) {
        observerAdded = false;
        operatorRepeat=NO;
        self.firstNumber = @"0";
        self.secondNumber = @"0";
        self.leftResultField.text = @"0";
        self.leftResultFieldLandscape.text=@"0";
        leftResultField.adjustsFontSizeToFitWidth=YES;
        rightResultField.adjustsFontSizeToFitWidth=YES;
        rightResultFieldLandscape.adjustsFontSizeToFitWidth=YES;
        leftResultFieldLandscape.adjustsFontSizeToFitWidth=YES;
        
        NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(tabBarInterfaceOrientation:) name:@"efbAssistViewControllerInterfaceOrientation" object:nil];
        [center addObserver:self selector:@selector(nightmodeChanged:) name:EFBNightModeChanged
                     object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    observerAdded = YES;
    [self addObserver:self forKeyPath:@"firstNumber" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    _currentConvertType = EFBCConvertTypeNMToKM;
    _operator = EFBCOperatorTypeBlank;
    
    [self.NMToKMBtn setSelected:YES];
    [self.FootToMBtn setSelected:NO];
    [self.PToKGBtn setSelected:NO];
    [self.LToGallonBtn setSelected:NO];
    
    [self.NMToKMBtn1 setSelected:YES];
    [self.FootToMBtn1 setSelected:NO];
    [self.PToKGBtn1 setSelected:NO];
    [self.LToGallonBtn1 setSelected:NO];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 30, 10, 10);
    [self.NMToKMBtn setTitleEdgeInsets:UIEdgeInsetsMake(10, 35, 10, 1)];
    [self.FootToMBtn setTitleEdgeInsets:insets];
    [self.PToKGBtn setTitleEdgeInsets:insets];
    [self.LToGallonBtn setTitleEdgeInsets:insets];
    
    [self.NMToKMBtn1 setTitleEdgeInsets:UIEdgeInsetsMake(10, 35, 10, 1)];
    [self.FootToMBtn1 setTitleEdgeInsets:insets];
    [self.PToKGBtn1 setTitleEdgeInsets:insets];
    [self.LToGallonBtn1 setTitleEdgeInsets:insets];

    
    self.contentView.hidden = YES;
    self.contentViewLandscape.hidden=YES;
    [self setLabelColors];
    
}

-(void)tabBarInterfaceOrientation:(NSNotification*)notification
{
    orientationController = (UIViewController*)notification.object;
    
}

-(void)backToAssistView{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ((object == self) && [keyPath isEqualToString:@"firstNumber"]){
        [self convertNumber];
    }
}

- (void)convertNumber
{
    double firstNumber = [self.firstNumber doubleValue];
    NSString *leftUnitText=nil;
    NSString *rightUnitText=nil;
    NSString *leftDescText=nil;
    NSString *rightDescText=nil;
    NSString *rightResultText=nil;
    double doubleResult = 0.0;
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    NSString *seamile1 = [currentLanguage isEqualToString:@"en"] ? @"" : @"(nmi)";
    NSString *km1 = [currentLanguage isEqualToString:@"en"] ? @"" : @"(km)";
    NSString *foot1 = [currentLanguage isEqualToString:@"en"] ? @"" : @"(ft)";
    NSString *mile1 = [currentLanguage isEqualToString:@"en"] ? @"" : @"(m)";
    NSString *pound1 = [currentLanguage isEqualToString:@"en"] ? @"" : @"(lb)";
    NSString *kilogram1 = [currentLanguage isEqualToString:@"en"] ? @"" : @"(kg)";
    NSString *litre1 = [currentLanguage isEqualToString:@"en"] ? @"" : @"(l)";
    NSString *gallon1 = [currentLanguage isEqualToString:@"en"] ? @"" : @"(gal)";
    
    if (_currentConvertType==EFBCConvertTypeNMToKM) {
        NSString *seamile=NSLocalizedString(@"calculator-unit-seamile",@"海里");
        NSString *km=NSLocalizedString(@"calculator-unit-km",@"公里");
     
        leftUnitText = [NSString stringWithFormat:@"%@ %@",seamile,seamile1];
        rightUnitText = [NSString stringWithFormat:@"%@ %@",km,km1];
        leftDescText = [NSString
                        stringWithFormat:@"1%@=1.852%@",seamile,km];
        rightDescText = [NSString stringWithFormat:@"1%@=0.5399568%@",km,seamile];
        
        doubleResult = firstNumber*1.852;
        
    }else if(_currentConvertType==EFBCConvertTypeKMToNM){
        NSString *seamile=NSLocalizedString(@"calculator-unit-seamile",@"海里");
        NSString *km=NSLocalizedString(@"calculator-unit-km",@"公里");
        leftUnitText = [NSString stringWithFormat:@"%@ %@",km,km1];
        rightUnitText= [NSString stringWithFormat:@"%@ %@",seamile,seamile1];
        leftDescText= [NSString stringWithFormat:@"1%@=0.5399568%@",km,seamile];
        rightDescText =[NSString
                        stringWithFormat:@"1%@=1.852%@",seamile,km];
        doubleResult = firstNumber*0.5399568;
        
    }else if(_currentConvertType==EFBCConvertTypeFootToMeter){
        NSString *foot=NSLocalizedString(@"calculator-unit-foot",@"英尺");
        NSString *mile=NSLocalizedString(@"calculator-unit-mile",@"米");
        leftUnitText = [NSString stringWithFormat:@"%@ %@",foot,foot1];
        rightUnitText = [NSString stringWithFormat:@"%@ %@",mile,mile1];
        leftDescText =[NSString
                       stringWithFormat:@"1%@=0.3048%@",foot,mile];
        rightDescText =[NSString stringWithFormat:@"1%@=3.2808399%@",mile,foot];
        doubleResult = firstNumber*0.3048;
        
    }else if (_currentConvertType==EFBCConvertTypeMeterToFoot) {
        NSString *foot=NSLocalizedString(@"calculator-unit-foot",@"英尺");
        NSString *mile=NSLocalizedString(@"calculator-unit-mile",@"米");
        leftUnitText =[NSString stringWithFormat:@"%@ %@",mile,mile1];
        rightUnitText = [NSString stringWithFormat:@"%@ %@",foot,foot1];
        leftDescText =[NSString stringWithFormat:@"1%@=3.2808399%@",mile,foot];
        rightDescText = [NSString
                         stringWithFormat:@"1%@=0.3048%@",foot,mile];
        doubleResult = firstNumber*3.2808399;
        
    }else if (_currentConvertType==EFBCConvertTypePoundToKG) {
        NSString *pound=NSLocalizedString(@"calculator-unit-pound",@"磅");
        NSString *kilogram=NSLocalizedString(@"calculator-unit-kilogram",@"千克");
        
        leftUnitText = [NSString stringWithFormat:@"%@ %@",pound,pound1];
        rightUnitText = [NSString stringWithFormat:@"%@ %@",kilogram,kilogram1];
        leftDescText =[NSString stringWithFormat:@"1%@=0.45359237%@",pound,kilogram];
        rightDescText =[NSString stringWithFormat:@"1%@=2.2046226%@",kilogram,pound];
        
        doubleResult = firstNumber*0.45359237;
        
    }else if (_currentConvertType==EFBCConvertTypeKGToPound) {
        NSString *pound=NSLocalizedString(@"calculator-unit-pound",@"磅");
        NSString *kilogram=NSLocalizedString(@"calculator-unit-kilogram",@"千克");
        
        leftUnitText = [NSString stringWithFormat:@"%@ %@",kilogram,kilogram1];
        rightUnitText = [NSString stringWithFormat:@"%@ %@",pound,pound1];
        leftDescText = [NSString stringWithFormat:@"1%@=2.2046226%@",kilogram,pound];
        rightDescText = [NSString stringWithFormat:@"1%@=0.45359237%@",pound,kilogram];
        
        doubleResult = firstNumber*2.2046226;
        
    }else if (_currentConvertType==EFBCConvertTypeLiterToGallon) {
        NSString *litre=NSLocalizedString(@"calculator-unit-litre",@"升");
        NSString *gallon=NSLocalizedString(@"calculator-unit-gallon",@"加仑");
        
        leftUnitText = [NSString stringWithFormat:@"%@ %@",litre,litre1];
        rightUnitText = [NSString stringWithFormat:@"%@ %@",gallon,gallon1];
        leftDescText = [NSString stringWithFormat:@"1%@=0.2641720%@",litre,gallon];
        rightDescText = [NSString stringWithFormat:@"1%@=3.7854117%@",gallon,litre];
        
        doubleResult = firstNumber*0.2641720;
    }else if (_currentConvertType==EFBCConvertTypeGallonToLiter) {
        NSString *litre=NSLocalizedString(@"calculator-unit-litre",@"升");
        NSString *gallon=NSLocalizedString(@"calculator-unit-gallon",@"加仑");
        
        leftUnitText = [NSString stringWithFormat:@"%@ %@",gallon,gallon1];
        rightUnitText =[NSString stringWithFormat:@"%@ %@",litre,litre1];
        leftDescText=[NSString stringWithFormat:@"1%@=3.7854117%@",gallon,litre];
        rightDescText =[NSString stringWithFormat:@"1%@=0.2641720%@",litre,gallon];
        
        doubleResult = firstNumber*3.7854117;
    }
    if (doubleResult == INFINITY) {
        doubleResult = DBL_MAX;
    }
    rightResultText = [NSString stringWithFormat:@"%0.9g",doubleResult];
    
    if (!self.contentView.hidden) {
        self.leftUnitLabel.text=leftUnitText;
        self.rightUnitLabel.text=rightUnitText;
        self.leftDescLabel.text=leftDescText;
        self.rightDescLabel.text=rightDescText;
        self.rightResultField.text=rightResultText;
    }else {
        self.leftUnitLabelLandscape.text=leftUnitText;
        self.rightUnitLabelLandscape.text=rightUnitText;
        self.leftDescLabelLandscape.text=leftDescText;
        self.rightDescLabelLandscape.text=rightDescText;
        self.rightResultFieldLandscape.text=rightResultText;
    }
    
    
}


- (void)viewDidUnload
{
    [self setLeftResultField:nil];
    [self setRightResultField:nil];
    [self setLeftUnitLabel:nil];
    [self setRightUnitLabel:nil];
    [self setLeftDescLabel:nil];
    [self setRightDescLabel:nil];
    [self setContentView:nil];
    
    [self setContentViewLandscape:nil];
    [self setLeftDescLabelLandscape:nil];
    [self setRightDescLabelLandscape:nil];
    [self setLeftUnitLabelLandscape:nil];
    [self setRightUnitLabelLandscape:nil];
    [self setLeftUnitLabelLandscape:nil];
    [self setRightDescLabelLandscape:nil];
    //self.navigationBar = nil;
    [self setImagebgLandscape:nil];
    [self setImagebg:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    
    return YES;
}



- (void)viewWillLayoutSubviews
{
    [self setLabelColors];
    
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        self.contentView.hidden=YES;
        self.contentViewLandscape.hidden=NO;
        [self.view bringSubviewToFront:contentViewLandscape];
        [self convertNumber];
        
    }else
    {
        self.contentView.hidden=NO;
        self.contentViewLandscape.hidden=YES;
        [self.view bringSubviewToFront:contentView];
        [self convertNumber];
    }
}

-(void)nightmodeChanged:(NSNotification*)notification
{
    [self setLabelColors];
}

-(void)setLabelColors
{
    
    BOOL nightMode = [[UIApplication sharedApplication] nightlyMode];
    if (nightMode) {
        [self.NMToKMBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

        [self.NMToKMBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.FootToMBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.PToKGBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.LToGallonBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.NMToKMBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.FootToMBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.PToKGBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.LToGallonBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.NMToKMBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.FootToMBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.PToKGBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.LToGallonBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.NMToKMBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.FootToMBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.PToKGBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.LToGallonBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        [leftUnitLabel setTextColor:[UIColor whiteColor]];
        [leftUnitLabelLandscape setTextColor:[UIColor whiteColor]];
        [rightUnitLabel setTextColor:[UIColor whiteColor]];
        [rightUnitLabelLandscape setTextColor:[UIColor whiteColor]];
        [leftDescLabel setTextColor:[UIColor whiteColor]];
        [leftDescLabelLandscape setTextColor:[UIColor whiteColor]];
        [rightDescLabel setTextColor:[UIColor whiteColor]];
        [rightDescLabelLandscape setTextColor:[UIColor whiteColor]];
        _imagebg.image=[UIImage imageNamed:@"new-calculator-nightmode.png"];
        _imagebgLandscape.image=[UIImage imageNamed:@"new-calculator-nightmode.png"];
        
        _image_bg_line.image = [UIImage imageNamed:@""];
        _image_bg_landLine.image = [UIImage imageNamed:@""];
        
        _image_bg_line.layer.masksToBounds=YES;
        _image_bg_line.layer.cornerRadius=1.0;
        _image_bg_line.layer.borderWidth=2.0;
        _image_bg_line.layer.borderColor=[VIEWCOLOR CGColor];
        
        _image_bg_landLine.layer.masksToBounds=YES;
        _image_bg_landLine.layer.cornerRadius=1.0;
        _image_bg_landLine.layer.borderWidth=2.0;
        _image_bg_landLine.layer.borderColor=[VIEWCOLOR CGColor];
    }
    else
    {
        [self.NMToKMBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];

        [self.NMToKMBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.FootToMBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.PToKGBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.LToGallonBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.NMToKMBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.FootToMBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.PToKGBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.LToGallonBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self.NMToKMBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [self.FootToMBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [self.PToKGBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [self.LToGallonBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [self.NMToKMBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [self.FootToMBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [self.PToKGBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [self.LToGallonBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        
        [leftUnitLabel setTextColor:[UIColor blackColor]];
        [leftUnitLabelLandscape setTextColor:[UIColor blackColor]];
        [rightUnitLabel setTextColor:[UIColor blackColor]];
        [rightUnitLabelLandscape setTextColor:[UIColor blackColor]];
        [leftDescLabel setTextColor:[UIColor blackColor]];
        [leftDescLabelLandscape setTextColor:[UIColor blackColor]];
        [rightDescLabel setTextColor:[UIColor blackColor]];
        [rightDescLabelLandscape setTextColor:[UIColor blackColor]];
        
        _imagebg.image=[UIImage imageNamed:@"new-calculator.png"];
        _imagebgLandscape.image=[UIImage imageNamed:@"new-calculator.png"];
        
        _image_bg_line.image = [UIImage imageNamed:@"bg_line.png"];
        _image_bg_landLine.image = [UIImage imageNamed:@"bg_line.png"];
        
        _image_bg_line.layer.masksToBounds=YES;
        _image_bg_line.layer.cornerRadius=1.0;
        _image_bg_line.layer.borderWidth=0.0;
        _image_bg_line.layer.borderColor=[[UIColor clearColor] CGColor];
        
        _image_bg_landLine.layer.masksToBounds=YES;
        _image_bg_landLine.layer.cornerRadius=1.0;
        _image_bg_landLine.layer.borderWidth=2.0;
        _image_bg_landLine.layer.borderColor=[[UIColor clearColor] CGColor];

    }
    
    NSString *seamile=NSLocalizedString(@"calculator-unit-seamile",@"海里");
    NSString *km=NSLocalizedString(@"calculator-unit-km",@"公里");
    NSString *foot=NSLocalizedString(@"calculator-unit-foot",@"英尺");
    NSString *mile=NSLocalizedString(@"calculator-unit-mile",@"米");
    NSString *pound=NSLocalizedString(@"calculator-unit-pound",@"磅");
    NSString *kilogram=NSLocalizedString(@"calculator-unit-kilogram",@"千克");
    NSString *litre=NSLocalizedString(@"calculator-unit-litre",@"升");
    NSString *gallon=NSLocalizedString(@"calculator-unit-gallon",@"加仑");
    
    [self.NMToKMBtn setTitle:[NSString stringWithFormat:@"%@/%@",seamile,km] forState:UIControlStateNormal];
    [self.FootToMBtn setTitle:[NSString stringWithFormat:@"%@/%@",foot,mile]  forState:UIControlStateNormal];
    [self.PToKGBtn setTitle:[NSString stringWithFormat:@"%@/%@",pound,kilogram]  forState:UIControlStateNormal];
    [self.LToGallonBtn setTitle:[NSString stringWithFormat:@"%@/%@",litre,gallon]  forState:UIControlStateNormal];
    [self.NMToKMBtn1 setTitle:[NSString stringWithFormat:@"%@/%@",seamile,km]  forState:UIControlStateNormal];
    [self.FootToMBtn1 setTitle:[NSString stringWithFormat:@"%@/%@",foot,mile]  forState:UIControlStateNormal];
    [self.PToKGBtn1 setTitle:[NSString stringWithFormat:@"%@/%@",pound,kilogram]  forState:UIControlStateNormal];
    [self.LToGallonBtn1 setTitle:[NSString stringWithFormat:@"%@/%@",litre,gallon]  forState:UIControlStateNormal];
}

- (IBAction)numberButtonTapped:(id)sender {
    operatorRepeat=NO;
    
    if ([self.firstNumber isEqualToString:@"Error"] || _operator == EFBCOperatorTypeEqual) {
        self.firstNumber = [NSString stringWithFormat:@"%d", [sender tag]];
        _operator = EFBCOperatorTypeBlank;
        if ( [self formatDouble:self.firstNumber]) {
            self.leftResultField.text = self.firstNumber;
            self.leftResultFieldLandscape.text=self.firstNumber;
            self.strRetrunFirst=self.firstNumber;
        }else{
            self.firstNumber=strRetrunFirst;
        }
        
    }
    
    else if (_operator != EFBCOperatorTypeBlank) {
        if (self.secondNumber.length > 9) {
            return;
        }
        if ([self.secondNumber isEqualToString:@"0"]) {
            self.secondNumber = [NSString stringWithFormat:@"%d", [sender tag]];
        } else {
            self.secondNumber = [NSString stringWithFormat:@"%@%d", self.secondNumber, [sender tag]];
        }
        if ( [self formatDouble:self.secondNumber]) {
            self.leftResultField.text = self.secondNumber;
            self.leftResultFieldLandscape.text=self.secondNumber;
            self.strRetrunSecod=self.secondNumber;
        }else{
            self.secondNumber=strRetrunSecod;
        }
        
    }
    else {
        if (self.firstNumber.length > 9) {
            return;
        }
        if ([self.firstNumber isEqualToString:@"0"]) {
            self.firstNumber = [NSString stringWithFormat:@"%d", [sender tag]];
        } else {
            self.firstNumber = [NSString stringWithFormat:@"%@%d", self.firstNumber, [sender tag]];
        }
        
        if ([self formatDouble:self.firstNumber]) {
            self.leftResultField.text =self.firstNumber;
            self.leftResultFieldLandscape.text=self.firstNumber;
            self.strRetrunFirst=self.firstNumber;
        }else{
            self.firstNumber=strRetrunFirst;
        }
        
    }
}


- (NSString *)formatDouble:(NSString *)number
{
    NSString *numberReturn;
    
    
    if ([number isEqualToString:@"Error"] || [number hasSuffix:@"."]){
        numberReturn=number;
    }else{
        
        double doubleNumber = [number doubleValue];
        if (doubleNumber == INFINITY) {
            doubleNumber = FLT_MAX;
        }
        
        numberReturn = [NSString stringWithFormat:@"%0.9g", doubleNumber];
    }
    return numberReturn;
}

- (IBAction)clearButtonTapped:(id)sender {
    self.firstNumber = @"0";
    self.secondNumber = @"0";
    _operator = EFBCOperatorTypeBlank;
    self.leftResultField.text = @"0";
    self.leftResultFieldLandscape.text=@"0";
}

- (IBAction)deleteButtonTapped:(id)sender {
    
    if (_operator != EFBCOperatorTypeBlank && _operator != EFBCOperatorTypeEqual && !operatorRepeat)
    {
        if ([self.secondNumber length] == 1){
            self.secondNumber = @"0";
            if ([self formatDouble:self.secondNumber]) {
                self.leftResultField.text = self.secondNumber;
                self.leftResultFieldLandscape.text=self.secondNumber;
            }
            
        }
        else if([self.secondNumber length] >1){
            self.secondNumber = [self.secondNumber substringToIndex:self.secondNumber.length-1];
            if ([self formatDouble:self.secondNumber]) {
                self.leftResultField.text = self.secondNumber;
                self.leftResultFieldLandscape.text=self.secondNumber;
            }
            
        }
        
    }else
    {
        if ([self.firstNumber length] == 1){
            self.firstNumber = @"0";
            self.secondNumber=@"0";
            if ([self formatDouble:self.firstNumber]) {
                self.leftResultField.text = self.firstNumber;
                self.leftResultFieldLandscape.text=self.firstNumber;
            }
            
        }
        else if([self.firstNumber length] > 1){
            self.firstNumber = [self.firstNumber substringToIndex:self.firstNumber.length-1];
            if ( [self formatDouble:self.firstNumber]) {
                self.leftResultField.text = self.firstNumber;
                self.leftResultFieldLandscape.text=self.firstNumber;
            }
            
        }
    }
    
    
}


- (IBAction)dotButtonTapped:(id)sender {
    if (_operator == EFBCOperatorTypeEqual) {
        self.firstNumber = @"0.";
        _operator = EFBCOperatorTypeBlank;
        if ([self formatDouble:self.firstNumber]) {
            self.leftResultField.text = self.firstNumber;
            self.leftResultFieldLandscape.text=self.firstNumber;
        }
        
    }
    if (_operator != EFBCOperatorTypeBlank) {
        if ([self.secondNumber rangeOfString:@"."].location == NSNotFound)
            self.secondNumber = [NSString stringWithFormat:@"%@.", self.secondNumber];
        if ([self formatDouble:self.secondNumber]) {
            self.leftResultField.text = self.secondNumber;
            self.leftResultFieldLandscape.text=self.secondNumber;
        }
        
    } else {
        if ([self.firstNumber rangeOfString:@"."].location == NSNotFound)
            self.firstNumber = [NSString stringWithFormat:@"%@.", self.firstNumber];
        if ([self formatDouble:self.firstNumber]) {
            self.leftResultField.text = self.firstNumber;
            self.leftResultFieldLandscape.text=self.firstNumber;
        }
    }
}

- (IBAction)operatorButtonTapped:(id)sender {
    
    if (_operator != EFBCOperatorTypeBlank && !operatorRepeat) {
        [self equalButtonTapped:nil];
    }
    
    _operator = (EFBCOperatorType)[sender tag];
    operatorRepeat=YES;
    
}

- (IBAction)equalButtonTapped:(id)sender {
    
    if (_operator != EFBCOperatorTypeBlank && self.secondNumber && ![self.secondNumber isEqualToString:@""] && !operatorRepeat)
    {
        switch (_operator) {
            case EFBCOperatorTypePlus:
                self.firstNumber = [NSString stringWithFormat:@"%0.9g", [self.firstNumber doubleValue]+[self.secondNumber doubleValue]];
                break;
            case EFBCOperatorTypeMinus:
                self.firstNumber = [NSString stringWithFormat:@"%0.9g", [self.firstNumber doubleValue]-[self.secondNumber doubleValue]];
                break;
            case EFBCOperatorTypeMultiply:
                self.firstNumber = [NSString stringWithFormat:@"%0.9g", [self.firstNumber doubleValue]*[self.secondNumber doubleValue]];
                break;
            case EFBCOperatorTypeDivide:
                if ([self.secondNumber doubleValue] == 0)
                    self.firstNumber = @"Error";
                else
                    self.firstNumber = [NSString stringWithFormat:@"%0.9g", [self.firstNumber doubleValue]/[self.secondNumber doubleValue]];
                break;
            default:
                break;
        }
        self.secondNumber = @"0";
        _operator = EFBCOperatorTypeEqual;
        if ([self formatDouble:self.firstNumber]) {
            self.leftResultField.text = self.firstNumber;
            self.leftResultFieldLandscape.text=self.firstNumber;
            
        }
        
    }
}

- (IBAction)convertButtonTapped:(id)sender {
    _currentConvertType = (EFBCConvertType)[sender tag];
    [self convertNumber];
    
    [self.NMToKMBtn setSelected:NO];
    [self.FootToMBtn setSelected:NO];
    [self.PToKGBtn setSelected:NO];
    [self.LToGallonBtn setSelected:NO];
    
    [self.NMToKMBtn1 setSelected:NO];
    [self.FootToMBtn1 setSelected:NO];
    [self.PToKGBtn1 setSelected:NO];
    [self.LToGallonBtn1 setSelected:NO];
    
    switch (_currentConvertType) {
        case 1:
            [self.NMToKMBtn setSelected:YES];
            [self.NMToKMBtn1 setSelected:YES];
            break;
        case 2:
            [self.FootToMBtn setSelected:YES];
            [self.FootToMBtn1 setSelected:YES];
            break;
        case 3:
            [self.PToKGBtn setSelected:YES];
            [self.PToKGBtn1 setSelected:YES];
            break;
        case 4:
            [self.LToGallonBtn setSelected:YES];
            [self.LToGallonBtn1 setSelected:YES];
            break;
        default:
            break;
    }
}

- (IBAction)exchangeButtonTapped:(id)sender {
    _currentConvertType = (EFBCConvertType)(-_currentConvertType);
    [self convertNumber];
}


- (void)dealloc {
    
    if (observerAdded) {
        [self removeObserver:self forKeyPath:@"firstNumber"];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nightmodeChanged" object:nil];
    
    [strRetrunSecod release];
    [strRetrunFirst release];
    [_firstNumber release];
    [_secondNumber release];
    [leftResultField release];
    [rightResultField release];
    [leftUnitLabel release];
    [rightUnitLabel release];
    [leftDescLabel release];
    [rightDescLabel release];
    [contentView release];
    [contentViewLandscape release];
    [_imagebgLandscape release];
    [_imagebg release];
    [_image_bg_line release];
    [_image_bg_landLine release];
    [_NMToKMBtn release];
    [_FootToMBtn release];
    [_PToKGBtn release];
    [_LToGallonBtn release];
    [_NMToKMBtn1 release];
    [_FootToMBtn1 release];
    [_PToKGBtn1 release];
    [_LToGallonBtn1 release];
    [super dealloc];
}


@end
