//
//  EFBTitleBar.m
//  EFBFrameworkProject
//
//  Created by 徐 洋 on 13-8-8.
//  Copyright (c) 2013年 ADCC. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <PixateFreeStyle.h>
#import "EFBTitleBar.h"
#import "EFBUIStyle.h"

#define TOP_PADDING         20.0f
#define LEFT_PADDING        20.0f
#define USERNAME_WIDTH      70.0f

@interface EFBTitleBar()

@property (retain, nonatomic) NSArray * constraints;

@end

@implementation EFBTitleBar

- (void)dealloc
{
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.styleClass = @"title-bar";

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.styleClass = @"caption";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:5]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:60]];
    }
    return self;
}

- (void)placeTitleBarToView:(UIView *)view
{
    if (self.superview) {
        [self removeFromSuperview];
    }
    
    self.frame = view.bounds;
    [view addSubview:self];
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    _constraints = @[[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                     [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1 constant:0],
                     [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1 constant:0],
                     [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:64]];
    
    [view addConstraints:_constraints];
}

- (void)removeFromSuperview
{
    if (self.constraints) {
        [self.superview removeConstraints:_constraints];
    }
    
    [super removeFromSuperview];
}

@end
