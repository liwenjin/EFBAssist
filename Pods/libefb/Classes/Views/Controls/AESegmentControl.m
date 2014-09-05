//
//  AESegmentControl.m
//  Pods
//
//  Created by 徐 洋 on 14-6-12.
//
//
#import <PixateFreestyle/PixateFreestyle.h>

#import "AESegmentControl.h"

@interface AESegmentControl ()

@property (readonly, nonatomic) NSArray * buttonArray;

@end

@implementation AESegmentControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.styleClass = @"ae-segment";
        
        _selectedIndex = -1;
    }
    return self;
}

- (void)setSegments:(NSArray *)segments
{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    NSInteger index = 0;
    
    for (NSString * seg in segments) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index++;
        button.styleClass = @"segment-button";
        [button setTitle:seg forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(onButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [array addObject:button];
    }
    
    ((UIButton *)[array objectAtIndex:0]).selected = YES;
    _buttonArray = array;
    _segments = [segments copy];
    _selectedIndex = 0;

}

- (void)onButtonTapped:(UIButton *)btn
{
    NSInteger index = btn.tag;
    if (btn.selected) {
        return;
    }
    
    if (_selectedIndex >= 0) {
        UIButton * lastBtn = [self.buttonArray objectAtIndex:_selectedIndex];
        lastBtn.selected = NO;
    }
    
    _selectedIndex = index;
    btn.selected = YES;
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setSelectedIndex:(NSInteger)index
{
    if (_selectedIndex == index) {
        return;
    }
    
    if (_selectedIndex >= 0) {
        UIButton * lastBtn = [self.buttonArray objectAtIndex:_selectedIndex];
        lastBtn.selected = NO;
    }
    
    if (index >= 0 && index<[self.buttonArray count]) {
        _selectedIndex = index;
        UIButton * btn = [self.buttonArray objectAtIndex:index];
        btn.selected = YES;
    }
    else {
        _selectedIndex = -1;
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)layoutSubviews
{
    int number = [self.buttonArray count];
    if (number <= 0) {
        return;
    }
    
    CGFloat vPadding = 2.0f;
    CGFloat hPadding = 2.0f;
    CGFloat margin = 3.0f;
    CGFloat x = hPadding;
    CGFloat y = vPadding+1;
    CGFloat height = CGRectGetHeight(self.bounds) - 2*vPadding;
    CGFloat width = (CGRectGetWidth(self.bounds) - 2*hPadding - margin*(number-1)) / number;
    
    for (UIButton * btn in self.buttonArray) {
        btn.frame = CGRectMake(x, y, width, height);
        [self addSubview:btn];
        
        x += width + margin;
    }
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
