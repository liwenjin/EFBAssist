//
//  EFBAviationCalculator.h
//  hnaefb
//
//  Created by EFB on 13-9-17.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EFBAviationCalculator : NSObject

//ISA温度
+ (NSDecimalNumber *)calculatorISATemperatureDeltaWithOAT:(NSDecimalNumber *)oatNumber elevation:(NSDecimalNumber *)elevationNumber;
+ (NSDecimalNumber *)calculatorISATemperatureISATWithOAT:(NSDecimalNumber *)oatNumber elevation:(NSDecimalNumber *)elevationNumber;

//风分量
+ (NSDecimalNumber *)calculatorRunWayWindWithRunwayDirection:(NSDecimalNumber *)runwayDirection wind:(NSDecimalNumber *)wind;
+ (NSDecimalNumber *)calculatorCrossWindWithRunwayDirection:(NSDecimalNumber *)runwayDirection wind:(NSDecimalNumber *)wind;

//爬升率
+ (NSDecimalNumber *)calculatorClimbRateWithSpeed:(NSDecimalNumber *)speed rate:(NSDecimalNumber *)rate gradient:(NSDecimalNumber *)gradient rateOrGradient:(NSString *)rateOrGradient;

//下降高度
+ (NSDecimalNumber *)calculatorFallDistanceWithGradient:(NSDecimalNumber *)gradientNumber speed:(NSDecimalNumber *)speedNumber fallHeight:(NSDecimalNumber *)fallHeightNumber;

//压力高度
+ (NSDecimalNumber *)calculatorPressureHightViewWithQNH:(NSDecimalNumber *)QNH elevation:(NSDecimalNumber *)elevation;

//加油量
+ (NSDecimalNumber *)calculatorWeightByDensity:(NSDecimalNumber *)density volume:(NSDecimalNumber *)volume; 
@end
