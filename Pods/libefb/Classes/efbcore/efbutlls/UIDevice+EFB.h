//
//  UIDevice+EFB.h
//  EFBFrameworkProject
//
//  Created by 徐 洋 on 13-9-13.
//  Copyright (c) 2013年 ADCC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIDevice (EFB)

- (NSString *)efbHardwareId;

- (void)resetEfbHardwareId;

- (NSString *)efbDeviceId; //服务器分配的ID


@end
