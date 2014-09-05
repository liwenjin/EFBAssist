//
//  EFBAppButton.m
//  EFBFrameworkProject
//
//  Created by 徐 洋 on 13-8-14.
//  Copyright (c) 2013年 ADCC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SKInnerShadowLayer.h"
#import "EFBUIStyle.h"
#import "EFBAppButton.h"

#define TITLE_H     34.0f

#define DEF_APPBUTTON_W         125.0f
#define DEF_APPBUTTON_H         125.0f

@interface EFBAppButton()

@property (retain, nonatomic) UIView * efbBackgroundView;
@property (retain, nonatomic) SKInnerShadowLayer * innerShadowlayer;

@end

@implementation EFBAppButton

- (void)dealloc
{
}

- (id)initWithTitle:(NSString *)title image:(UIImage *)image
{
    CGRect frame = CGRectMake(0, 0, DEF_APPBUTTON_W, DEF_APPBUTTON_H);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.efbBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.efbBackgroundView.userInteractionEnabled = NO;
        [self addSubview:self.efbBackgroundView];
        
        const CGFloat icon_w = 45.0f;
        const CGFloat icon_h = 45.0f;
        
        CGFloat yoffset = -15.0f;
        CGFloat icon_x = (CGRectGetWidth(frame) -icon_w)/2;
        CGFloat icon_y = (CGRectGetHeight(frame) -icon_h)/2 + yoffset;
        
        
        UIImageView * iconView = [[UIImageView alloc] initWithFrame:CGRectMake(icon_x, icon_y, icon_w, icon_h)];
        iconView.image = image;
        [self.efbBackgroundView addSubview:iconView];
        
        CGFloat x = 0;
        CGFloat y = icon_y + icon_h;
        CGFloat w = CGRectGetWidth(self.bounds);
        CGFloat h = TITLE_H;
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        titleLabel.textColor = [[EFBUIStyle defaultStyle] colorForTabTitle];
        titleLabel.font = [[EFBUIStyle defaultStyle] fontForTabButton];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.efbBackgroundView addSubview:titleLabel];
                
        self.innerShadowlayer = [[SKInnerShadowLayer alloc] init];
        
        self.innerShadowlayer.frame = CGRectIntegral(frame);
        self.innerShadowlayer.cornerRadius = 7.0f;
        self.innerShadowlayer.innerShadowOffset = CGSizeMake(0, 0);
        self.innerShadowlayer.innerShadowRadius = 7.0f;
        
        self.innerShadowlayer.innerShadowOpacity = 0.8f;
        self.innerShadowlayer.innerShadowColor = [UIColor blackColor].CGColor;
        
        self.innerShadowlayer.borderColor = [UIColor colorWithWhite:0.05f alpha:1.0f].CGColor;
        self.innerShadowlayer.borderWidth = 1.0f;
        
        [self.efbBackgroundView.layer addSublayer:self.innerShadowlayer];
		[self.efbBackgroundView.layer setCornerRadius:7.0];
    }

    return self;
}

- (void)setSelected:(BOOL)selected
{
    if (selected) {
        self.efbBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"app-tab-selected-bg"]];
    }
    else {
        self.efbBackgroundView.backgroundColor = [UIColor clearColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        self.efbBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"app-tab-selected-bg"]];
    }
    else {
        self.efbBackgroundView.backgroundColor = [UIColor clearColor];
    }
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
