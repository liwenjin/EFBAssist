//
//  CalculatorCellView.m
//  calculator
//
//  Created by hanfei on 13-3-7.
//  Copyright (c) 2013年 ADCC. All rights reserved.
//

#import "CalculatorCellView.h"

@implementation CalculatorCellView

//@synthesize delegate = _delegate;
@synthesize parameterNameLabel = _parameterNameLabel;
@synthesize dataTextField = _dataTextField;
@synthesize unitButton = _unitButton;
@synthesize signButton = _signButton;

-(void)dealloc
{
    [_parameterNameLabel release];
    [_dataTextField release];
    [_unitButton release];
    [_signButton release];
    [_parameterLabel release];
    [super dealloc];
}

- (void)setDataTextFieldType:(EFBDataTextFieldType)aType
{
    if (aType == kTextFieldForNormal) {
        self.dataTextField.background = [UIImage imageNamed:@"utilitiesTextbox"];
    }
    else if (aType == kTextFieldForInput)
    {
        self.dataTextField.background = [UIImage imageNamed:@"utilitiesTextbox_active"];
    }
    else if (aType == kTextFieldForResult)
    {
        self.dataTextField.background = [UIImage imageNamed:@"utilitiesTextbox_display"];
    }
    
}

- (NSDecimalNumber *)decimalValue
{
    return [NSDecimalNumber decimalNumberWithString:self.dataTextField.text];
}

- (void)setDecimalValue:(NSDecimalNumber *)number
{
    self.dataTextField.text = [number description];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
