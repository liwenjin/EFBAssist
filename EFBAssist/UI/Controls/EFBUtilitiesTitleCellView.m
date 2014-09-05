//
//  EFBUtilitiesTitleCellView.m
//  hnaefb
//
//  Created by EFB on 13-8-26.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import "EFBUtilitiesTitleCellView.h"

@implementation EFBUtilitiesTitleCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _titleLable.textColor = [UIColor colorWithRed:48/255.0 green:62/255.0 blue:75/255.0 alpha:1.0];
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
    [_titleLable release];
    [super dealloc];
}
@end
