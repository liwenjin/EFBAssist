//
//  EFBTaskListView.m
//  EFBFrameworkProject
//
//  Created by 徐 洋 on 13-8-14.
//  Copyright (c) 2013年 ADCC. All rights reserved.
//

#import "EFBAppButton.h"
#import "EFBAppListView.h"

#define APPBUTTON_W         125.0f
#define APPBUTTON_H         125.0f

@interface EFBAppListView() {
    NSArray * _taskList;
    NSMutableArray * _buttonArray;
}

@property (nonatomic, assign) id<EFBAppListViewDelegate> applistDelegate;

@end

@implementation EFBAppListView

- (void)dealloc
{
}

- (id)initWithFrame:(CGRect)frame delegate:(id<EFBAppListViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.applistDelegate = delegate;
        
        [self createButtons];
    }
    
    return self;
}

- (void)createButtons
{
    _buttonArray = [[NSMutableArray alloc] initWithCapacity:[_taskList count]];
    
    if (self.applistDelegate && [self.applistDelegate conformsToProtocol:@protocol(EFBAppListViewDelegate)]) {
        NSInteger count = [self.applistDelegate numberOfApps:(EFBAppListView *)self];
        
        for (int index=0; index<count; index++) {
            EFBAppButton *button = [self.applistDelegate applistView:self buttonForAppAtIndex:index];

            [button addTarget:self action:@selector(appButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

            button.tag = index;
            [_buttonArray addObject:button];
        }
    }
    
}

- (void)layoutSubviews
{
    int cols = (int)CGRectGetWidth(self.bounds) / APPBUTTON_W;
    
    CGFloat sp_h = (CGRectGetWidth(self.bounds)-cols*APPBUTTON_W)/(cols-1);
    CGFloat sp_v = sp_h;//(CGRectGetHeight(self.bounds)-rows*APPBUTTON_H)/(rows-1);
    
    CGRect r = CGRectNull;
    
    for (int i=0; i<[_buttonArray count]; i ++) {
        int col = i % cols;
        int row = i / cols;
        
        CGFloat x = col * (APPBUTTON_W + sp_h);
        CGFloat y = row * (APPBUTTON_H + sp_v);
        
        UIButton * button = [_buttonArray objectAtIndex:i];
        CGRect frame = button.frame;
        frame.origin.x = x;
        frame.origin.y = y;
        button.frame = frame;
        [self addSubview:button];

        r = CGRectUnion(r, frame);
    }
    
    self.contentSize = r.size;
}

- (IBAction)appButtonTapped:(id)sender
{
    UIButton *button = sender;
    
    if (self.applistDelegate && [self.applistDelegate conformsToProtocol:@protocol(EFBAppListViewDelegate)]) {
        [self.applistDelegate applistView:self didSelectAppAtIndex:button.tag];
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
