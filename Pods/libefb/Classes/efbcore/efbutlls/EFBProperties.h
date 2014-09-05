//
//  EFBProperties.h
//  EFBFrameworkProject
//
//  Created by 徐 洋 on 13-8-7.
//  Copyright (c) 2013年 ADCC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCustomLogoFile     @"custom-icon"
#define kAdccLogoFile       @"adcc-icon"

@interface EFBProperties : NSObject

+ (NSDictionary *)frameworkProperties;
+ (void)saveProperties:(NSDictionary *)properties;

@end
