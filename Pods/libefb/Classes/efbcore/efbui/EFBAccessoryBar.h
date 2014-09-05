//
//  EFBAccessoryBar.h
//  EFBFrameworkProject
//
//  Created by 徐 洋 on 13-8-8.
//  Copyright (c) 2013年 ADCC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EFBAccessoryBarItem : UIBarButtonItem

@property (copy, nonatomic) NSString * styleClass;

@property (assign, nonatomic) BOOL selected;

- (instancetype)initWithStyleClass:(NSString *)styleClass target:(id)target action:(SEL)action;

@end

@interface EFBAccessoryBar : UIView

@property (readonly, nonatomic) CGFloat accessoryBarWidth;
@property (assign, nonatomic) BOOL isLocked;
@property (readonly, copy, nonatomic) NSArray * buttons;

- (instancetype)initWithItems:(NSArray *)items;

-(CGSize)preferedSize;

@end
