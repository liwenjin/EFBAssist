//
//  EFBCalculatorUnitCellView.m
//  hnaefb
//
//  Created by EFB on 13-9-9.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import "EFBCalculatorUnitCellView.h"

@implementation EFBCalculatorUnitCellView

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

- (void)dealloc {
    [_dataTextField release];
    [_parameterNameLabel release];
    [_textFieldBgImageView release];
    [super dealloc];
}

-(void)setDataTextFieldImage:(EFBDataTextFieldImage)aImage
{
    if (aImage == kTextFieldTagForNormal)
    {
        self.dataTextField.background = [UIImage imageNamed:@"utilitiesTextFieldBackgroundImage@2x.png"];
    }
    else if (aImage == kTextFieldTagForInput)
    {
        self.dataTextField.background = [UIImage imageNamed:@"utilitiesTextFieldBackgroundImage_input@2x.png"];
    }
    else if (aImage == kTextFieldTagForResult)
    {
        self.dataTextField.background = [UIImage imageNamed:@"utilitiesTextFieldBackgroundImage_result@2x.png"];
    } 
}

@end
