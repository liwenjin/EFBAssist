//
//  EFBContext.h
//  EFBFrameworkProject
//
//  Created by 徐 洋 on 13-8-7.
//  Copyright (c) 2013年 ADCC. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kScreenNightMode    @"NightMode"
#define kScreenBrightness   @"Brightness"

#define kSoftwareVersion    @"CFBundleShortVersionString"
#define kHardwareId         @"efb-hardware-id"
#define kFlightDictionary   @"efb-flight-dictionary"
#define kFlightNumber   @"efb-flight-no"
#define kFlightTail   @"efb-flight-tail"
#define kFlightDate   @"efb-flight-date"
#define kFlightDeparture   @"efb-flight-departure"
#define kFlightDestination   @"efb-flight-destination"

// backward cmpatible
#define CTX_NIGHTMODE  kScreenNightMode
#define CTX_BRIGHTNESS kScreenBrightness

@interface EFBContext : NSObject

+ (NSMutableDictionary *)sharedInstance;


+ (EFBContext *)sharedDefaultInstance;

- (void)setValue:(NSString *)value forKey:(NSString *)key;
- (void)deleteValue:(NSArray *)keyArray;
- (NSString *)objectForkey:(NSString *)key;
- (NSDictionary *)getContextDic;
- (void)resetAllValue;
@end
