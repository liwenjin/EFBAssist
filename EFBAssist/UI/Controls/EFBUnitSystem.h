//
//  EFBUnitSystem.h
//  hnaefb
//
//  Created by EFB on 13-9-22.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EFBUnitSystem : NSObject

+ (NSDecimalNumber *)notRounding:(NSDecimalNumber *)number afterPoint:(int)position;
+ (NSString *)NotRounding:(NSDecimalNumber *)number afterPoint:(int)position;
@end

@interface EFBUnitSystem (speed)

//标准单位（m/s）
+ (NSDecimalNumber *)standardScaleForSpeed:(NSString *)unitString scale:(NSDecimalNumber *)number;
+ (NSDecimalNumber *)unitScaleForSpeed:(NSString *)unit standardScale:(NSDecimalNumber *)standard;

@end

@interface EFBUnitSystem (weight)

//标准单位（kg）
+ (NSDecimalNumber *)standardScaleForWeight:(NSString *)unitString scale:(NSDecimalNumber *)number;
+ (NSDecimalNumber *)unitScaleForWeight:(NSString *)unit standardScale:(NSDecimalNumber *)standard;

@end

@interface EFBUnitSystem (distance)

//标准单位（m）
+ (NSDecimalNumber *)standardScaleForDistance:(NSString *)unitString scale:(NSDecimalNumber *)number;
+ (NSDecimalNumber *)unitScaleForDistance:(NSString *)unit standardScale:(NSDecimalNumber *)standard;
@end

@interface EFBUnitSystem (pressure)

//标准单位（HPA）
+ (NSDecimalNumber *)standardScaleForPressure:(NSString *)unitString scale:(NSDecimalNumber *)number;
+ (NSDecimalNumber *)unitScaleForPressure:(NSString *)unit standardScale:(NSDecimalNumber *)standard;
@end

@interface EFBUnitSystem (temperature)

//标准单位（˚C）
+ (NSDecimalNumber *)standardScaleForTemperature:(NSString *)unitString scale:(NSDecimalNumber *)number;
+ (NSDecimalNumber *)unitScaleForTemperature:(NSString *)unit standardScale:(NSDecimalNumber *)standard;
@end

@interface EFBUnitSystem (volume)

//标准单位（L）
+ (NSDecimalNumber *)standardScaleForVolume:(NSString *)unitString scale:(NSDecimalNumber *)number;
+ (NSDecimalNumber *)unitScaleForVolume:(NSString *)unit standardScale:(NSDecimalNumber *)standard;
@end

@interface EFBUnitSystem (density)

//标准单位（Kg/m³）
+ (NSDecimalNumber *)standardScaleForDensity:(NSString *)unitString scale:(NSDecimalNumber *)number;
+ (NSDecimalNumber *)unitScaleForDensity:(NSString *)unit standardScale:(NSDecimalNumber *)standard;
@end