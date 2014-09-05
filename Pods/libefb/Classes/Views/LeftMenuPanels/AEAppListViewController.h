//
//  AEAppListViewController.h
//  efbapp
//
//  Created by 徐 洋 on 14-3-17.
//  Copyright (c) 2014年 ADCC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define APP_CONFIG_FILE     @"custom"
#define kAppListRoot        @"app-list"
#define kAppTitle           @"app-title"
#define kAppIcon            @"app-icon"
#define kAppSchema          @"app-schema"

@class AEAppListViewController;

@protocol AEAppListDelegate <NSObject>

- (void)appList:(AEAppListViewController *)appList didSelectedAtIndex:(NSInteger)index;

@end

@interface AEAppListViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (assign, nonatomic) id<AEAppListDelegate> delegate;

@end
