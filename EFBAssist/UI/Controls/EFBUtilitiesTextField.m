//
//  EFBUtilitiesTextField.m
//  hnaefb
//
//  Created by EFB on 13-9-10.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import "EFBUtilitiesTextField.h"

#define kLeftPadding  10
#define kTopPadding   0

@implementation EFBUtilitiesTextField

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(5, 5, 5, 10);
    [self setBackground:[[UIImage imageNamed:@"utilitiesTextbox"] resizableImageWithCapInsets:edgeInsets]];
    [self textRectForBounds:CGRectMake(5, 0, CGRectGetWidth(self.frame)-10, CGRectGetWidth(self.frame))];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self awakeAfterUsingCoder:nil];
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + kLeftPadding,
                      bounds.origin.y + kTopPadding,
                      bounds.size.width - 10, bounds.size.height - kTopPadding);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
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
