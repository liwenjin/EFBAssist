//
//  AELanguageTableViewCell.m
//  efbapp
//
//  Created by 徐 洋 on 14-3-17.
//  Copyright (c) 2014年 ADCC. All rights reserved.
//

#import "AELanguageTableViewCell.h"

@interface AELanguageTableViewCell()

@property (retain, nonatomic) UILabel * checkMark;

@end

@implementation AELanguageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 3, 36, 36)];
        _languageNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(58, 3, 200, 36)];
        _languageNameLabel.textColor = [UIColor colorWithRed:100.0/255 green:157.0/255 blue:1.0 alpha:1.0f];
        _checkMark = [[UILabel alloc] initWithFrame:CGRectMake(280, 3, 36, 36)];
        _checkMark.text = @"✔️";
        _checkMark.hidden = NO;
        
        [self addSubview:self.iconImage];
        [self addSubview:self.languageNameLabel];
        [self addSubview:self.checkMark];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.checkMark.hidden = !selected;
}

@end
