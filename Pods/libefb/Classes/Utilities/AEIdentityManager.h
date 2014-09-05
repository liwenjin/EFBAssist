//
//  AEIdentityManager.h
//  efbapp
//
//  Created by 徐 洋 on 14-3-18.
//  Copyright (c) 2014年 ADCC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AEModels.h"

@interface AEIdentityManager : NSObject

@property (retain, nonatomic) NSDictionary * currentUser;
@property (retain, nonatomic) NSDictionary * currentFlight;

+ (AEIdentityManager *)defaultManager;

- (void)loginWithUser:(NSString *)userId password:(NSString *)password completion:(void (^)(NSDictionary *user, NSError * error))completion;

- (void)logoutWithCompletion:(void(^)(NSError *error))completion;

- (void)addNotificationListener:(id)target action:(SEL)action;

- (void)removeListener:(id)target;

@end
