//
//  AEUserAvatar.h
//  efbapp
//
//  Created by 徐 洋 on 14-3-17.
//  Copyright (c) 2014年 ADCC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AEAvatarStyle) {
    AEAvatarIconStyle,
    AEAvatarDetailStyle,
};

@interface AEUserAvatar : UIControl

@property (retain, nonatomic) UILabel * nameLabel;
@property (retain, nonatomic) UIImageView * avatarImage;
@property (retain, nonatomic) UILabel * departmentLabel;
@property (retain, nonatomic) UILabel * titleLabel;

- (id)initWithAvatarStyle:(AEAvatarStyle)style;

@end
