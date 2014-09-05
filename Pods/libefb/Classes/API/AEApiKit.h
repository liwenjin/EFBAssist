//
//  AEApiKit.h
//  Pods
//
//  Created by 徐 洋 on 14-5-28.
//
//

#import <Foundation/Foundation.h>

@interface AEApiKit : NSObject

+ (void)apiInitializeWithBaseURL:(NSURL *)baseURL;

+ (void)apiRequestDeviceInfo:(NSString *)deviceId
                  completion:(void(^)(id response, NSError *error))completion;

+ (void)apiLoginWithUsername:(NSString *)username
                    password:(NSString *)password
                  completion:(void(^)(id response, NSError *error))completion;

+ (void)apiRequestContentUpdateWithDeviceId:(NSString *)deviceId
                                 completion:(void(^)(id response, NSError *error))completion;

+ (void)apiStartHeartbeatWithInterval:(NSInteger)seconds
                                block:(void(^)(NSMutableDictionary * hbData, BOOL *repeat))block;

+ (void)apiStopHeartbeat;

@end
