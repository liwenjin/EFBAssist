//
//  EFBUnitSystem.m
//  hnaefb
//
//  Created by EFB on 13-9-22.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import "EFBUnitSystem.h"

#define UNITForMPerS         @"m/s"
#define UNITForKmPerH        @"km/h"
#define UNITForKn            @"kn"

#define UNITForKg            @"kg"
#define UNITForLb            @"lb"

#define UNITForM             @"m"
#define UNITForKm            @"km"
#define UNITForNmi           @"nmi"
#define UNITForMi            @"mi"
#define UNITForFt            @"ft"
#define UNITForIn            @"in"

#define UNITForHPA           @"HPA"
#define UNITForMmHg          @"mmHg"
#define UNITForInHg          @"inHg"

#define UNITForC             @"˚C"
#define UNITForF             @"˚F"
#define UNITForK             @"K"

#define UNITForGPerCm        @"g/cm³"
#define UNITForKgPerM        @"kg/m³"
#define UNITForLbPerUSGal    @"lb/USgal"
#define UNITForKgperL        @"kg/L"

#define UNITForL             @"L"
#define UNITForUSGal         @"US gal"

@implementation EFBUnitSystem

+ (NSDecimalNumber *)notRounding:(NSDecimalNumber *)number afterPoint:(int)position
{
    NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    NSDecimalNumber *roundedOunces = [number decimalNumberByRoundingAccordingToBehavior:behavior];
    return roundedOunces;
}

+ (NSString *)NotRounding:(NSDecimalNumber *)number afterPoint:(int)position
{
    NSString *returnString = nil;
    NSString *resultValue = [NSString stringWithFormat:@"%@",number];
//    NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
//    formatter.numberStyle = NSNumberFormatterScientificStyle;
    
    if ([resultValue length] > 15) {
        NSArray *array = [resultValue componentsSeparatedByString:@"."];
        if ([array count] == 1) {
//            returnString = [formatter stringFromNumber:number];
            returnString = [NSString stringWithFormat:@"%e",[resultValue doubleValue]];
        }
        else
        {
            NSString *firstString = [array objectAtIndex:0];
            int firstLength = [firstString length];
            if (firstLength > 15) {
//                returnString = [formatter stringFromNumber:number];
                returnString = [NSString stringWithFormat:@"%e",[resultValue doubleValue]];

            }else{
                int i = 15-1-firstLength;
                if (i<0) {
                    i = 0;
                }
                NSDecimalNumberHandler *behavior_ = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:i raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
                NSDecimalNumber *roundedOunces_ = [number decimalNumberByRoundingAccordingToBehavior:behavior_];
                returnString = [NSString stringWithFormat:@"%@",roundedOunces_];
            }
        }
    }else{
        NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        NSDecimalNumber *roundedOunces = [number decimalNumberByRoundingAccordingToBehavior:behavior];
        returnString = [NSString stringWithFormat:@"%@",roundedOunces];
    }
    
    return returnString;
}

@end


@implementation EFBUnitSystem (speed)

+ (NSDecimalNumber *)standardScaleForSpeed:(NSString *)unitString scale:(NSDecimalNumber *)number
{
    NSDecimalNumber *decimalNumber = [NSDecimalNumber zero];
    NSDecimalNumber *decimal = [NSDecimalNumber decimalNumberWithString:@"3.6"];
    NSDecimalNumber *decimal1 = [NSDecimalNumber decimalNumberWithString:@"0.5144444444"];

    if ([unitString isEqualToString:UNITForMPerS]) {
        decimalNumber = number;
    }
    else if ([unitString isEqualToString:UNITForKmPerH])
    {
        decimalNumber = [number decimalNumberByDividingBy:decimal];
    }
    else if ([unitString isEqualToString:UNITForKn])
    {
        decimalNumber = [number decimalNumberByMultiplyingBy:decimal1];
    }
    return decimalNumber;
}

+ (NSDecimalNumber *)unitScaleForSpeed:(NSString *)unit standardScale:(NSDecimalNumber *)standard
{
    NSDecimalNumber *decimalNumber = [NSDecimalNumber zero];
    NSDecimalNumber *decimal = [NSDecimalNumber decimalNumberWithString:@"3.6"];
    NSDecimalNumber *decimal1 = [NSDecimalNumber decimalNumberWithString:@"1.94384449244"];
    
    if ([unit isEqualToString:UNITForMPerS]) {
        decimalNumber = standard;
    }
    else if ([unit isEqualToString:UNITForKmPerH])
    {
        decimalNumber = [standard decimalNumberByMultiplyingBy:decimal];
    }
    else if ([unit isEqualToString:UNITForKn])
    {
        decimalNumber = [standard decimalNumberByMultiplyingBy:decimal1];
    }

    return decimalNumber;
}

@end

@implementation EFBUnitSystem (weight)

+ (NSDecimalNumber *)standardScaleForWeight:(NSString *)unitString scale:(NSDecimalNumber *)number
{
    NSDecimalNumber *decimalNumber = [NSDecimalNumber zero];
    NSDecimalNumber *decimal = [NSDecimalNumber decimalNumberWithString:@"0.45359237"];

    if ([unitString isEqualToString:UNITForKg]) {
        decimalNumber = number;
    }
    else if ([unitString isEqualToString:UNITForLb])
    {
        decimalNumber = [number decimalNumberByMultiplyingBy:decimal];
    }
   
    return decimalNumber;
}

+ (NSDecimalNumber *)unitScaleForWeight:(NSString *)unit standardScale:(NSDecimalNumber *)standard
{
    NSDecimalNumber *decimalNumber = [NSDecimalNumber zero];
    NSDecimalNumber *decimal = [NSDecimalNumber decimalNumberWithString:@"2.204622621849"];
    
    if ([unit isEqualToString:UNITForKg]) {
        decimalNumber = standard;
    }
    else if ([unit isEqualToString:UNITForLb])
    {
        decimalNumber = [standard decimalNumberByMultiplyingBy:decimal];
    }
    
    return decimalNumber;
}

@end

@implementation EFBUnitSystem (distance)

+ (NSDecimalNumber *)standardScaleForDistance:(NSString *)unitString scale:(NSDecimalNumber *)number
{
    NSDecimalNumber *decimalNumber = [NSDecimalNumber zero];
    NSDecimalNumber *decimal = [NSDecimalNumber decimalNumberWithString:@"1000"];
    NSDecimalNumber *decimal1 = [NSDecimalNumber decimalNumberWithString:@"1852"];
    NSDecimalNumber *decimal2 = [NSDecimalNumber decimalNumberWithString:@"1609.344"];
    NSDecimalNumber *decimal3 = [NSDecimalNumber decimalNumberWithString:@"0.3048"];
    NSDecimalNumber *decimal4 = [NSDecimalNumber decimalNumberWithString:@"0.0254"];

    if ([unitString isEqualToString:UNITForM]) {
        decimalNumber = number;
    }
    else if ([unitString isEqualToString:UNITForKm])
    {
        decimalNumber = [number decimalNumberByMultiplyingBy:decimal];
    }
    else if ([unitString isEqualToString:UNITForNmi])
    {
        decimalNumber = [number decimalNumberByMultiplyingBy:decimal1];
    }
    else if ([unitString isEqualToString:UNITForMi])
    {
        decimalNumber = [number decimalNumberByMultiplyingBy:decimal2];
    }
    else if ([unitString isEqualToString:UNITForFt])
    {
        decimalNumber = [number decimalNumberByMultiplyingBy:decimal3];
    }
    else if ([unitString isEqualToString:UNITForIn])
    {
        decimalNumber = [number decimalNumberByMultiplyingBy:decimal4];
    }
    return decimalNumber;
}

+ (NSDecimalNumber *)unitScaleForDistance:(NSString *)unit standardScale:(NSDecimalNumber *)standard
{
    NSDecimalNumber *decimalNumber = [NSDecimalNumber zero];
    NSDecimalNumber *decimal = [NSDecimalNumber decimalNumberWithString:@"1000"];
    NSDecimalNumber *decimal1 = [NSDecimalNumber decimalNumberWithString:@"1852"];
    NSDecimalNumber *decimal2 = [NSDecimalNumber decimalNumberWithString:@"1609.344"];
    NSDecimalNumber *decimal3 = [NSDecimalNumber decimalNumberWithString:@"0.3048"];
    NSDecimalNumber *decimal4 = [NSDecimalNumber decimalNumberWithString:@"0.0254"];
    
    if ([unit isEqualToString:UNITForM]) {
        decimalNumber = standard;
    }
    else if ([unit isEqualToString:UNITForKm])
    {
        decimalNumber = [standard decimalNumberByDividingBy:decimal];
    }
    else if ([unit isEqualToString:UNITForNmi])
    {
        decimalNumber = [standard decimalNumberByDividingBy:decimal1];
    }
    else if ([unit isEqualToString:UNITForMi])
    {
        decimalNumber = [standard decimalNumberByDividingBy:decimal2];
    }
    else if ([unit isEqualToString:UNITForFt])
    {
        decimalNumber = [standard decimalNumberByDividingBy:decimal3];
    }
    else if ([unit isEqualToString:UNITForIn])
    {
        decimalNumber = [standard decimalNumberByDividingBy:decimal4];
    }
    return decimalNumber;
}
@end

@implementation EFBUnitSystem (pressure)

+ (NSDecimalNumber *)standardScaleForPressure:(NSString *)unitString scale:(NSDecimalNumber *)number
{
    NSDecimalNumber *decimalNumber = [NSDecimalNumber zero];
    NSDecimalNumber *decimal = [NSDecimalNumber decimalNumberWithString:@"1.33322368421"];
    NSDecimalNumber *decimal1 = [NSDecimalNumber decimalNumberWithString:@"33.86388157894"];
    if ([unitString isEqualToString:UNITForHPA])
    {
        decimalNumber = number;
    }
    else if ([unitString isEqualToString:UNITForMmHg])
    {
        decimalNumber = [number decimalNumberByMultiplyingBy:decimal];
    }
    else if ([unitString isEqualToString:UNITForInHg])
    {
        decimalNumber = [number decimalNumberByMultiplyingBy:decimal1];
    }
    return decimalNumber;
}

+ (NSDecimalNumber *)unitScaleForPressure:(NSString *)unit standardScale:(NSDecimalNumber *)standard
{
    NSDecimalNumber *decimalNumber = [NSDecimalNumber zero];
    NSDecimalNumber *decimal = [NSDecimalNumber decimalNumberWithString:@"0.750061682704"];
    NSDecimalNumber *decimal1 = [NSDecimalNumber decimalNumberWithString:@"0.029529987509"];
    if ([unit isEqualToString:UNITForHPA])
    {
        decimalNumber = standard;
    }
    else if ([unit isEqualToString:UNITForMmHg])
    {
        decimalNumber = [standard decimalNumberByMultiplyingBy:decimal];
    }
    else if ([unit isEqualToString:UNITForInHg])
    {
        decimalNumber = [standard decimalNumberByMultiplyingBy:decimal1];
    }
    return decimalNumber;
}

@end

@implementation EFBUnitSystem (temperature)

+ (NSDecimalNumber *)standardScaleForTemperature:(NSString *)unitString scale:(NSDecimalNumber *)number
{
    NSDecimalNumber *decimalNumber = [NSDecimalNumber zero];
    NSDecimalNumber *decimal = [NSDecimalNumber decimalNumberWithString:@"32"];
    NSDecimalNumber *decimal1 = [NSDecimalNumber decimalNumberWithString:@"273.15"];
    NSDecimalNumber *decimal2 = [NSDecimalNumber decimalNumberWithString:@"5"];
    NSDecimalNumber *decimal3 = [NSDecimalNumber decimalNumberWithString:@"9"];

    if ([unitString isEqualToString:UNITForC])
    {
        decimalNumber = number;
    }
    else if ([unitString isEqualToString:UNITForF])
    {
        NSDecimalNumber *value = [decimal2 decimalNumberByDividingBy:decimal3];
        NSDecimalNumber *value1= [number decimalNumberBySubtracting:decimal];
        decimalNumber = [value1 decimalNumberByMultiplyingBy:value];
    }
    else if ([unitString isEqualToString:UNITForK])
    {
        decimalNumber = [number decimalNumberBySubtracting:decimal1];
    }
    return decimalNumber;
}

+ (NSDecimalNumber *)unitScaleForTemperature:(NSString *)unit standardScale:(NSDecimalNumber *)standard
{
    NSDecimalNumber *decimalNumber = [NSDecimalNumber zero];
    NSDecimalNumber *decimal = [NSDecimalNumber decimalNumberWithString:@"32"];
    NSDecimalNumber *decimal1 = [NSDecimalNumber decimalNumberWithString:@"273.15"];
    NSDecimalNumber *decimal2 = [NSDecimalNumber decimalNumberWithString:@"5"];
    NSDecimalNumber *decimal3 = [NSDecimalNumber decimalNumberWithString:@"9"];
    
    if ([unit isEqualToString:UNITForC])
    {
        decimalNumber = standard;
    }
    else if ([unit isEqualToString:UNITForF])
    {
        NSDecimalNumber *value = [decimal3 decimalNumberByDividingBy:decimal2];
        NSDecimalNumber *value1= [standard decimalNumberByMultiplyingBy:value];
        decimalNumber = [value1 decimalNumberByAdding:decimal];
    }
    else if ([unit isEqualToString:UNITForK])
    {
        decimalNumber = [standard decimalNumberByAdding:decimal1];
    }
    return decimalNumber;
}

@end

@implementation EFBUnitSystem (volume)

+ (NSDecimalNumber *)standardScaleForVolume:(NSString *)unitString scale:(NSDecimalNumber *)number
{
    NSDecimalNumber *decimalNumber = [NSDecimalNumber zero];
    NSDecimalNumber *decimal = [NSDecimalNumber decimalNumberWithString:@"3.785412"];
    if ([unitString isEqualToString:UNITForL])
    {
        decimalNumber = number;
    }
    else if ([unitString isEqualToString:UNITForUSGal])
    {
        decimalNumber = [number decimalNumberByMultiplyingBy:decimal];
    }
    return decimalNumber;
}

+ (NSDecimalNumber *)unitScaleForVolume:(NSString *)unit standardScale:(NSDecimalNumber *)standard;
{
    NSDecimalNumber *decimalNumber = [NSDecimalNumber zero];
    NSDecimalNumber *decimal = [NSDecimalNumber decimalNumberWithString:@"0.264172"];
    
    if ([unit isEqualToString:UNITForL])
    {
        decimalNumber = standard;
    }
    else if ([unit isEqualToString:UNITForUSGal])
    {
        decimalNumber = [standard decimalNumberByMultiplyingBy:decimal];
    }
    return decimalNumber;
}

@end

@implementation EFBUnitSystem (density)

+ (NSDecimalNumber *)standardScaleForDensity:(NSString *)unitString scale:(NSDecimalNumber *)number
{
    NSDecimalNumber *decimalNumber = [NSDecimalNumber zero];
    NSDecimalNumber *decimal = [NSDecimalNumber decimalNumberWithString:@"1000"];
    NSDecimalNumber *decimal2 = [NSDecimalNumber decimalNumberWithString:@"119.826"];

    if ([unitString isEqualToString:UNITForGPerCm])
    {
        decimalNumber = [number decimalNumberByMultiplyingBy:decimal];
    }
    else if ([unitString isEqualToString:UNITForKgPerM])
    {
        decimalNumber = number;
    }
    else if ([unitString isEqualToString:UNITForLbPerUSGal])
    {
        decimalNumber = [number decimalNumberByMultiplyingBy:decimal2];
    }
    else if ([unitString isEqualToString:UNITForKgperL])
    {
        decimalNumber = [number decimalNumberByMultiplyingBy:decimal];
    }
    return decimalNumber;
}

+ (NSDecimalNumber *)unitScaleForDensity:(NSString *)unit standardScale:(NSDecimalNumber *)standard
{
    NSDecimalNumber *decimalNumber = [NSDecimalNumber zero];
    NSDecimalNumber *decimal = [NSDecimalNumber decimalNumberWithString:@"1000"];
    NSDecimalNumber *decimal2 = [NSDecimalNumber decimalNumberWithString:@"0.008345434212"];
    
    if ([unit isEqualToString:UNITForGPerCm])
    {
        decimalNumber = [standard decimalNumberByDividingBy:decimal];
    }
    else if ([unit isEqualToString:UNITForKgPerM])
    {
        decimalNumber = standard;
    }
    else if ([unit isEqualToString:UNITForLbPerUSGal])
    {
        decimalNumber = [standard decimalNumberByMultiplyingBy:decimal2];
    }
    else if ([unit isEqualToString:UNITForKgperL])
    {
        decimalNumber = [standard decimalNumberByDividingBy:decimal];
    }
    return decimalNumber;
}

@end

