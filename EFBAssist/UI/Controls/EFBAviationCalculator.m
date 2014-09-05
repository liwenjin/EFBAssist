//
//  EFBAviationCalculator.m
//  hnaefb
//
//  Created by EFB on 13-9-17.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import "EFBAviationCalculator.h"

@implementation EFBAviationCalculator


+ (NSDecimalNumber *)calculatorISATemperatureDeltaWithOAT:(NSDecimalNumber *)oatNumber elevation:(NSDecimalNumber *)elevationNumber
{
    NSDecimalNumber *ISADeltaValue = 0;
    
    NSDecimalNumber *value = [NSDecimalNumber decimalNumberWithString:@"15"];
    NSDecimalNumber *value1 = [NSDecimalNumber decimalNumberWithString:@"6.5"];
    NSDecimalNumber *value2 = [NSDecimalNumber decimalNumberWithString:@"1000"];
    
    NSDecimalNumber *result = [oatNumber decimalNumberBySubtracting:value];
    NSDecimalNumber *result1 = [elevationNumber decimalNumberByDividingBy:value2];
    NSDecimalNumber *result2 = [value1 decimalNumberByMultiplyingBy:result1];
    ISADeltaValue = [result decimalNumberByAdding:result2];
    
    return ISADeltaValue;
}

+ (NSDecimalNumber *)calculatorISATemperatureISATWithOAT:(NSDecimalNumber *)oatNumber elevation:(NSDecimalNumber *)elevationNumber 
{
    NSDecimalNumber *ISADeltaValue = 0;
    NSDecimalNumber *value = [NSDecimalNumber decimalNumberWithString:@"15"];
    NSDecimalNumber *value1 = [NSDecimalNumber decimalNumberWithString:@"6.5"];
    NSDecimalNumber *value2 = [NSDecimalNumber decimalNumberWithString:@"1000"];

    NSDecimalNumber *result1 = [elevationNumber decimalNumberByDividingBy:value2];
    NSDecimalNumber *result2 = [value1 decimalNumberByMultiplyingBy:result1];
    ISADeltaValue = [value decimalNumberBySubtracting:result2];
    
    return ISADeltaValue;
}

+ (NSDecimalNumber *)calculatorRunWayWindWithRunwayDirection:(NSDecimalNumber *)runwayDirection wind:(NSDecimalNumber *)wind
{
    NSDecimalNumber *runwaySpeedValue = 0;
    NSDecimalNumber *windDirectionValue = 0;
    NSDecimalNumber *windSpeedValue = 0;
    NSString *windString = [wind stringValue];
    NSDecimalNumber *PaiValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",M_PI/180]];
    
    if ([windString length] == 5) {
        NSString *windDirectionString = [windString substringWithRange:NSMakeRange(0, 3)];
        NSString *windSpeedString = [windString substringWithRange:NSMakeRange(3, 2)];
        windDirectionValue = [NSDecimalNumber decimalNumberWithString:windDirectionString];
        windSpeedValue = [NSDecimalNumber decimalNumberWithString:windSpeedString];
    }else{
        windDirectionValue = [NSDecimalNumber decimalNumberWithString:@"0"];
        windSpeedValue = [NSDecimalNumber decimalNumberWithString:windString];
    }
    NSDecimalNumber *result1 = [runwayDirection decimalNumberBySubtracting:windDirectionValue];
    NSDecimalNumber *result2 = [PaiValue decimalNumberByMultiplyingBy:result1];
    float resultValue = cosf([result2 floatValue]);
    runwaySpeedValue = [windSpeedValue decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",resultValue]]];
    return runwaySpeedValue;
}

+ (NSDecimalNumber *)calculatorCrossWindWithRunwayDirection:(NSDecimalNumber *)runwayDirection wind:(NSDecimalNumber *)wind
{
    NSDecimalNumber *crossWindValue = 0;
    NSDecimalNumber *windDirectionValue = 0;
    NSDecimalNumber *windSpeedValue = 0;
    NSString *windString = [wind stringValue];
       NSDecimalNumber *PaiValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",M_PI/180]];    
    
    if ([windString length] == 5) {
        NSString *windDirectionString = [windString substringWithRange:NSMakeRange(0, 3)];
        NSString *windSpeedString = [windString substringWithRange:NSMakeRange(3, 2)];
        windDirectionValue = [NSDecimalNumber decimalNumberWithString:windDirectionString];
        windSpeedValue = [NSDecimalNumber decimalNumberWithString:windSpeedString];
    }else{
        windDirectionValue = [NSDecimalNumber decimalNumberWithString:@"0"];
        windSpeedValue = [NSDecimalNumber decimalNumberWithString:windString];
    }
    NSDecimalNumber *result1 = [runwayDirection decimalNumberBySubtracting:windDirectionValue];
    NSDecimalNumber *result2 = [PaiValue decimalNumberByMultiplyingBy:result1];
    float resultValue = sinf([result2 floatValue]);
    crossWindValue = [windSpeedValue decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",resultValue]]];
    return crossWindValue;
}

+ (NSDecimalNumber *)calculatorClimbRateWithSpeed:(NSDecimalNumber *)speed rate:(NSDecimalNumber *)rate gradient:(NSDecimalNumber *)gradient rateOrGradient:(NSString *)rateOrGradient
{
    
    NSDecimalNumber *value = [NSDecimalNumber decimalNumberWithString:@"60"];
    NSDecimalNumber *climbRateValue = 0;
    if ([rateOrGradient isEqualToString:@"Rate"]) {
        NSDecimalNumber *result1 = [speed decimalNumberByMultiplyingBy:gradient];
        climbRateValue = [result1 decimalNumberByDividingBy:value];
    }else{
        NSDecimalNumber *result1 = [rate decimalNumberByMultiplyingBy:value];
        climbRateValue = [result1 decimalNumberByDividingBy:speed];

    }
    return climbRateValue;
}

+ (NSDecimalNumber *)calculatorFallDistanceWithGradient:(NSDecimalNumber *)gradientNumber speed:(NSDecimalNumber *)speedNumber fallHeight:(NSDecimalNumber *)fallHeightNumber
{
    NSDecimalNumber *value = [NSDecimalNumber decimalNumberWithString:@"60"];
    
    NSDecimalNumber *result1 = [fallHeightNumber decimalNumberByMultiplyingBy:speedNumber];
    NSDecimalNumber *result2 = [gradientNumber decimalNumberByMultiplyingBy:value];
    
    NSDecimalNumber *fallDistanceValue = [result1 decimalNumberByDividingBy:result2];
    return fallDistanceValue;
}

+ (NSDecimalNumber *)calculatorPressureHightViewWithQNH:(NSDecimalNumber *)QNH elevation:(NSDecimalNumber *)elevation
{
    NSDecimalNumber *pressureHightValue = 0;
    NSDecimalNumber *value = [NSDecimalNumber decimalNumberWithString:@"1013.25"];
    NSDecimalNumber *value2 = [NSDecimalNumber decimalNumberWithString:@"28"];
    NSDecimalNumber *value4 = [NSDecimalNumber decimalNumberWithString:@"3.281"];

    NSDecimalNumber *result1 = [value decimalNumberBySubtracting:QNH];
    NSDecimalNumber *result2 = [result1 decimalNumberByMultiplyingBy:value2];
    NSDecimalNumber *result3 = [elevation decimalNumberByMultiplyingBy:value4];
    pressureHightValue = [result3 decimalNumberByAdding:result2];

    return pressureHightValue;
}

+ (NSDecimalNumber *)calculatorWeightByDensity:(NSDecimalNumber *)density volume:(NSDecimalNumber *)volume 
{
    NSDecimalNumber *weightValue = 0;
    NSDecimalNumber *result1 = [density decimalNumberByMultiplyingBy:volume];

    NSDecimalNumber *value4 = [NSDecimalNumber decimalNumberWithString:@"0.001"];
    
    weightValue = [result1 decimalNumberByMultiplyingBy:value4];

    return weightValue;
}

@end
