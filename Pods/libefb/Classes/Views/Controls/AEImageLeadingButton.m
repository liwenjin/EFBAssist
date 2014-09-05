//
//  AEImageLeadingButton.m
//  efbapp
//
//  Created by 徐 洋 on 14-3-17.
//  Copyright (c) 2014年 ADCC. All rights reserved.
//

#import "AEImageLeadingButton.h"

@implementation AEImageLeadingButton

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    if (self) {
        [self viewDidLoad];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self viewDidLoad];
    }
    return self;
}

- (void)viewDidLoad
{
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    self.imageView.image = [UIImage imageNamed:@"img-flag-china"];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 0, 100, 36)];
    self.titleLabel.text = @"简体中文";
        
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
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
