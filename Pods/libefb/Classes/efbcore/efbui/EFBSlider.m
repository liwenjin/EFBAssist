//
//  EFBSlider.m
//  EFBFrameworkProject
//
//  Created by 徐 洋 on 13-8-14.
//  Copyright (c) 2013年 ADCC. All rights reserved.
//

#import "EFBSlider.h"

@implementation EFBSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addTarget:self action:@selector(getSlideValue:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (CGRect)trackRectForBounds:(CGRect)bounds
{
    bounds.size.height = 7.0f;
    return bounds;
}

-(void)getSlideValue:(id)sender
{
    UISlider *slider=(UISlider *)sender;    
    [[UIScreen mainScreen] setBrightness:slider.value];
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
