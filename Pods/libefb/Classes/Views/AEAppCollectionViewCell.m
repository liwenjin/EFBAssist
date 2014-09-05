//
//  AEAppCollectionViewCell.m
//  Pods
//
//  Created by 徐 洋 on 14-5-28.
//
//
#import <PixateFreestyle.h>

#import "AEAppCollectionViewCell.h"

@implementation AEAppCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 54, 80, 20)];
        _titleLabel.styleClass = @"title";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
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

@end
