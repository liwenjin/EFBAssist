//
//  EFBCrypto.h
//  muefb
//
//  Created by chu-imac on 13-9-22.
//
//

#import <Foundation/Foundation.h>

@interface EFBCrypto : NSObject


+ (NSString *)MD5Password:(NSString *)stringID;


+ (NSString *)MD5PasswordForChart:(NSString *)stringID;

+ (NSString *)MD5PasswordForChartFile:(NSString *)stringID fileName:(NSString *)fileName;

@end
