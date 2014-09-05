//
//  EFBColorSystem.m
//  EFBFrameworkProject
//
//  Created by 徐 洋 on 13-8-8.
//  Copyright (c) 2013年 ADCC. All rights reserved.
//
#import "EFBSlider.h"

#import "EFBUIStyle.h"

static UIColor * UIColorFromRGB(unsigned char r,unsigned char g,unsigned char b, CGFloat alpha)
{
    CGFloat red, green, blue;
    
    red     = r / 255.0f;
    green   = g / 255.0f;
    blue    = b / 255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@implementation EFBUIStyle

+ (id)defaultStyle
{
    static EFBUIStyle * __defaultStyle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ( __defaultStyle == nil ) {
            __defaultStyle = [[EFBUIStyle alloc] init];
        }
    });
    
    return __defaultStyle;
}

@end

@implementation EFBUIStyle (EFBUIStyleColor)

- (UIColor *)colorForTabBackground
{
    return UIColorFromRGB(0x2c, 0x2c, 0x2c, 1.0f);
}
- (UIColor *)colorForTabBarShadow
{
    return UIColorFromRGB(0, 0, 0, 1.0f);
}

- (UIColor *)colorForTitleBarBackground
{
    return UIColorFromRGB(0x26, 0x26, 0x26, 1.0f);
}

- (UIColor *)colorForTitleBarShadow
{
    return UIColorFromRGB(0, 0, 0, 1.0f);
}

- (UIColor *)colorForTabTitle
{
    return UIColorFromRGB(0xff, 0xff, 0xff, 1.0f);
}

- (UIColor *)colorForGenericBackground
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"framework-bg"]];
}

- (UIView *)seperatorHorizontalLineView:(CGFloat)length origin:(CGPoint)origin
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, length, 2)];
    UIView * upperLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, length, 1)];
    UIView * lowerLine = [[UIView alloc] initWithFrame:CGRectMake(0, 1, length, 1)];
    
    upperLine.backgroundColor = UIColorFromRGB(0x16, 0x16, 0x16, 1.0f);
    lowerLine.backgroundColor = UIColorFromRGB(0, 0, 0, 1.0f);
    
    [view addSubview:upperLine];
    [view addSubview:lowerLine];
    
    return view;
}

- (UIColor *)colorForMainMenuBackground
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"framework-mainmenu-bg"]];
}

@end

@implementation EFBUIStyle (EFBUIStyleFont)

- (UIFont *)fontForTabButton
{
    static NSString * fontName = @"HelveticaNeue-CondensedBlack";
    UIFont * font = [UIFont fontWithName:fontName size:16.0f];
    
    NSAssert(font, @"Font name \"%@\" not found", fontName);

    return font;
}

- (UIFont *)fontForUserNameOnTitleBar
{
    static NSString * fontName = @"HelveticaNeue-CondensedBlack";
    UIFont * font = [UIFont fontWithName:fontName size:21.0f];
    
    NSAssert(font, @"Font name \"%@\" not found", fontName);
    
    return font;
}

- (UIFont *)fontForTitleOnTitleBar
{
    static NSString * fontName = @"HelveticaNeue-CondensedBlack";
    UIFont * font = [UIFont fontWithName:fontName size:35.0f];
    
    NSAssert(font, @"Font name \"%@\" not found", fontName);
    
    return font;
}

- (UIFont *)fontForFlightNumber
{
    static NSString * fontName = @"HelveticaNeue-CondensedBlack";
    UIFont * font = [UIFont fontWithName:fontName size:35.0f];
    
    NSAssert(font, @"Font name \"%@\" not found", fontName);
    
    return font;
}

- (UIFont *)fontForTailNumber
{
    static NSString * fontName = @"HelveticaNeue-CondensedBlack";
    UIFont * font = [UIFont fontWithName:fontName size:20.0f];
    
    NSAssert(font, @"Font name \"%@\" not found", fontName);
    
    return font;
}

@end

@implementation EFBUIStyle (EFBUIStyleControl)

- (UILabel *)normalLabel
{
    UILabel * label = [[UILabel alloc] init];
    
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [self colorForTabTitle];
    [label setFont:[self fontForTabButton]];
    
    return label;
}

- (UISlider *)normalSlider
{
    UISlider * slider = [[EFBSlider alloc] init];
    
    UIImage * image = [[UIImage imageNamed:@"framework-slider"] resizableImageWithCapInsets:UIEdgeInsetsMake(3, 25, 3, 25)];
    
    [slider setMinimumTrackImage:image forState:UIControlStateNormal];
    [slider setMaximumTrackImage:image forState:UIControlStateNormal];

    [slider setThumbImage:[UIImage imageNamed:@"framework-slider-switch-button"] forState:UIControlStateNormal];
    
    
    return slider;
}

- (UISwitch *)normalSwitch
{
    UISwitch * switchCtrl = [[UISwitch alloc] init];
    if ([UISwitch instancesRespondToSelector:@selector(setOffImage:)]) {
        [switchCtrl setOffImage:[UIImage imageNamed:@"framework-switch"]];
        [switchCtrl setOnImage:[UIImage imageNamed:@"framework-switch"]];
    }
    return switchCtrl;
}

@end
