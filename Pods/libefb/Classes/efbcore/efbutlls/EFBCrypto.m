//
//  EFBCrypto.m
//  muefb
//
//  Created by chu-imac on 13-9-22.
//
//

#import "EFBCrypto.h"
#import "NSString+EFB.h"


NSString *EFBCryptoString= @"f2bdfb49a40158142fa744a7e9bf3175bc9f571a";
NSString *EFBCryptoChartString=@"653d411egw1e8feuvhtvug206i03fqv6";


@implementation EFBCrypto


+ (NSString *)MD5Password:(NSString *)stringID
{

    return [NSString MD5ForString:[stringID stringByAppendingString:EFBCryptoString]];
}


+(NSString *)MD5PasswordForChart:(NSString *)stringID
{
    NSString *enroutePass=nil;
    for(int time=0; time<3; time++){
        if (time==0) {
            enroutePass=[NSString MD5ForString:[EFBCryptoChartString stringByAppendingString:stringID]];
        }else{
            enroutePass=[NSString MD5ForString:enroutePass];
        }
    }
    return enroutePass;
}

+(NSString *)MD5PasswordForChartFile:(NSString *)stringID fileName:(NSString *)fileName
{
    NSString *enroutePass=nil;
    for(int time=0; time<3; time++){
        if (time==0) {
            if (fileName) {
                enroutePass=[NSString MD5ForString:[[EFBCryptoChartString stringByAppendingString:stringID] stringByAppendingString:fileName]];
            }else{
                enroutePass=[NSString MD5ForString:[EFBCryptoChartString stringByAppendingString:stringID]];
            }
        }else{
            enroutePass=[NSString MD5ForString:enroutePass];
        }
    }
    return enroutePass;
}

@end
