//
//  EFBProperties.m
//  EFBFrameworkProject
//
//  Created by 徐 洋 on 13-8-7.
//  Copyright (c) 2013年 ADCC. All rights reserved.
//

#import "EFBProperties.h"

#define PLIST_FILE      @"framework"

@implementation EFBProperties

+ (NSDictionary *)frameworkProperties
{
    NSString * path = [[NSBundle mainBundle] pathForResource:PLIST_FILE ofType:@"plist"];
    NSDictionary * prop = [NSDictionary dictionaryWithContentsOfFile:path];
    return prop;
}

+ (void)saveProperties:(NSDictionary *)properties
{
    NSString * path = [[NSBundle mainBundle] pathForResource:PLIST_FILE ofType:@"plist"];
    [properties writeToFile:path atomically:YES];
}

@end
