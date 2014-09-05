//
//  EFBAccessoryBar.m
//  EFBFrameworkProject
//
//  Created by 徐 洋 on 13-8-8.
//  Copyright (c) 2013年 ADCC. All rights reserved.
//

#import <PixateFreeStyle/PixateFreestyle.h>

#import "EFBUIStyle.h"
#import "EFBAccessoryBar.h"

#define ACCESSORY_BUTTON_WIDTH  51.0f
#define ACCESSORY_BUTTON_HEIGHT  51.0f

@implementation EFBAccessoryBarItem

- (instancetype)initWithStyleClass:(NSString *)styleClass target:(id)target action:(SEL)action
{
    self = [super init];
    if (self) {
        self.target = target;
        self.action = action;
        self.styleClass = styleClass;
    }
    
    return self;
}

@end

@interface EFBAccessoryBar ()

@property (retain, nonatomic) NSArray * privateItems;
@property (copy, nonatomic, readwrite) NSArray * buttons;
@end

@implementation EFBAccessoryBar

- (instancetype)initWithItems:(NSArray *)items
{
    self = [super init];
    if (self) {
        self.styleClass = @"accessory-bar";
        self.privateItems = [items copy];
        
        [self _addButtonsToView];
    }
    
    return self;
}

-(CGSize)preferedSize
{
    CGFloat width = ACCESSORY_BUTTON_WIDTH;
    CGFloat height = ACCESSORY_BUTTON_HEIGHT * [self.privateItems count];
    
    return CGSizeMake(width, height);
}


#pragma mark - Private methods

- (void)_addButtonsToView
{
    NSMutableArray * btnArray = [[NSMutableArray alloc] init];
    
    [self.privateItems enumerateObjectsUsingBlock:^(EFBAccessoryBarItem * item, NSUInteger idx, BOOL *stop) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ACCESSORY_BUTTON_WIDTH, ACCESSORY_BUTTON_HEIGHT)];
        button.styleClass = item.styleClass;
        icon.styleClass = @"icon";
        
        button.tag = idx;
        button.enabled = item.enabled;
        button.selected = item.selected;
        
        [button addTarget:item.target action:item.action forControlEvents:UIControlEventTouchUpInside];
        
        [button addSubview:icon];
        [self addSubview:button];

        [button setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:0 constant:(idx + 0.5) * ACCESSORY_BUTTON_HEIGHT]];
        
        [btnArray addObject:button];
    }];
    
    self.buttons = btnArray;
}

@end
