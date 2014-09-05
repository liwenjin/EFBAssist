//
//  AELoginBox.h
//  efbapp
//
//  Created by 徐 洋 on 14-3-18.
//  Copyright (c) 2014年 ADCC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AELoginBox : UIView

@property (retain, nonatomic) UITextField * userName;
@property (retain, nonatomic) UITextField * password;

@property (copy, nonatomic) void(^completion)(NSDictionary *user, NSError *error);

@end
