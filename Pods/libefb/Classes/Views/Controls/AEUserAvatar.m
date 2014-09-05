//
//  AEUserAvatar.m
//  efbapp
//
//  Created by 徐 洋 on 14-3-17.
//  Copyright (c) 2014年 ADCC. All rights reserved.
//

#import <PixateFreestyle.h>

#import "AEUserAvatar.h"

@implementation AEUserAvatar

- (id)initWithAvatarStyle:(AEAvatarStyle)style
{
    float avatarWidth = 100.0f;
    float avatarHeight = 100.0f;
    
    if (style == AEAvatarDetailStyle) {
        avatarWidth = 220.0f;
        avatarHeight = 100.0f;
    }
    
    CGRect frame = CGRectMake(0, 0, avatarWidth, avatarHeight);
    self = [super initWithFrame:frame];
    if (self) {
        self.styleClass = @"avatar";
        
        // Initialization code
        self.userInteractionEnabled = YES;
        
        self.highlighted = false;
        _avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 84, 84)];
        _avatarImage.userInteractionEnabled = NO;
        _avatarImage.styleClass = @"avatar-icon";
        
        UILabel *tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 80, 20)];
        tmpLabel.text = @"欢迎您：";
        tmpLabel.styleClass = @"name-field";
        tmpLabel.userInteractionEnabled = NO;
        tmpLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:tmpLabel];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 5, 80, 20)];
        _nameLabel.text = @"nameLable";
        _nameLabel.userInteractionEnabled = NO;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.styleClass = @"name-field";
        
        
        tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 35, 75, 20)];
        tmpLabel.text = @"所属部门：";
        tmpLabel.styleClass = @"other-field";
        tmpLabel.userInteractionEnabled = NO;
        tmpLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:tmpLabel];
        
        _departmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 35, 80, 20)];
        _departmentLabel.backgroundColor = [UIColor clearColor];
        _departmentLabel.userInteractionEnabled = NO;
        _departmentLabel.textAlignment = NSTextAlignmentLeft;
        _departmentLabel.styleClass = @"other-field";
        
        tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 65, 75, 20)];
        tmpLabel.text = @"职务：";
        tmpLabel.styleClass = @"other-field";
        tmpLabel.userInteractionEnabled = NO;
        tmpLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:tmpLabel];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 65, 80, 20)];
        _titleLabel.text = @"title";
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.userInteractionEnabled = NO;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.styleClass = @"other-field";
        
        [self addSubview:_avatarImage];
        [self addSubview:_nameLabel];
        [self addSubview:_titleLabel];
        [self addSubview:_departmentLabel];
        
//        if (style == AEAvatarDetailStyle) {
//            self.avatarImage.center = CGPointMake(self.avatarImage.center.x, avatarHeight/2);
//            self.nameLabel.frame = CGRectMake(90, 20, 100, 30);
//            self.titleLabel.frame = CGRectMake(90, 55, 100, 20);
//            self.titleLabel.hidden = NO;
//
//        }
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    self.avatarImage.highlighted = self.highlighted;
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
