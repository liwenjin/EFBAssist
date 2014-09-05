//
//  EFBTaskListView.h
//  EFBFrameworkProject
//
//  Created by 徐 洋 on 13-8-14.
//  Copyright (c) 2013年 ADCC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFBAppButton.h"

@class EFBAppListView;

@protocol EFBAppListViewDelegate <NSObject>

@required

- (void)applistView:(EFBAppListView *)applistView didSelectAppAtIndex:(NSInteger)index;
- (NSInteger)numberOfApps:(EFBAppListView *)applistView;
- (EFBAppButton *)applistView:(EFBAppListView *)applistView buttonForAppAtIndex:(NSInteger)index;

@end

@interface EFBAppListView : UIScrollView

- (id)initWithFrame:(CGRect)frame delegate:(id<EFBAppListViewDelegate>)delegate;

@end
