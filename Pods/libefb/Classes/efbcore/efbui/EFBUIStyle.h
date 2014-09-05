//
//  EFBColorSystem.h
//  EFBFrameworkProject
//
//  Created by 徐 洋 on 13-8-8.
//  Copyright (c) 2013年 ADCC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EFBUIStyle : NSObject

+ (id)defaultStyle;

@end

@interface EFBUIStyle (EFBUIStyleColor)

- (UIColor *)colorForTabBackground;
- (UIColor *)colorForTabBarShadow;
- (UIColor *)colorForTabTitle;
- (UIColor *)colorForGenericBackground;
- (UIColor *)colorForTitleBarBackground;
- (UIColor *)colorForTitleBarShadow;
- (UIView *)seperatorHorizontalLineView:(CGFloat)length origin:(CGPoint)origin;
- (UIColor *)colorForMainMenuBackground;

@end

@interface EFBUIStyle (EFBUIStyleFont)

- (UIFont *)fontForTabButton;
- (UIFont *)fontForFlightNumber;
- (UIFont *)fontForTailNumber;
- (UIFont *)fontForUserNameOnTitleBar;
- (UIFont *)fontForTitleOnTitleBar;

@end

@interface EFBUIStyle (EFBUIStyleControl)

- (UILabel *)normalLabel;
- (UISlider *)normalSlider;
- (UISwitch *)normalSwitch;

@end
