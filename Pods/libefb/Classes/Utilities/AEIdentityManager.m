//
//  AEIdentityManager.m
//  efbapp
//
//  Created by 徐 洋 on 14-3-18.
//  Copyright (c) 2014年 ADCC. All rights reserved.
//

#import "SSKeychain.h"
#import "AEIdentityManager.h"
#import "AEError.h"
#import "EFBContext.h"

static NSString * kLoginNotification = @"kLoginNotification";
static NSString * kFlightDomain = @"com.adcc.efb.flight";

//
// backward compatible to MUEFB 1.0
//
static NSString * kEFBService  = @"cn.com.adcc.efb";
static NSString * kEFBUserName = @"userIdentity";
static NSString * kEFBPassword = @"password";

@interface AEIdentityManager(Private)


+ (void) _setDict:(id)dict forPasteboardType:(NSString *)type;
+ (NSMutableDictionary*) _getDictFromPasteboardType:(NSString *)type;

@end

@implementation AEIdentityManager

+ (AEIdentityManager *)defaultManager
{
    static AEIdentityManager * __instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[AEIdentityManager alloc] init];
    });
    
    return __instance;
}

+ (void) _setDict:(id)dict forPasteboardType:(NSString *)type
{
    UIPasteboard * pb = [UIPasteboard pasteboardWithName:type create:YES];

    [pb setData:[NSKeyedArchiver archivedDataWithRootObject:dict] forPasteboardType:type];
}

+ (NSMutableDictionary*) _getDictFromPasteboardType:(NSString *)type
{
    UIPasteboard * pboard = [UIPasteboard pasteboardWithName:type create:NO];
    
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    id item = [pboard dataForPasteboardType:type];
#else
	id item = [pboard dataForType:type];
#endif
    if (item) {
        @try{
            item = [NSKeyedUnarchiver unarchiveObjectWithData:item];
        } @catch(NSException* e) {
            NSLog(@"Unable to unarchive item %@ on pasteboard!", [pboard name]);
            item = nil;
        }
    }
    
    // return an instance of a MutableDictionary
    return (item == nil || [item isKindOfClass:[NSDictionary class]]) ? item : nil;
}

+ (void)_setUserDict:(NSDictionary *)dict forKeychainService:(NSString *)service
{
    NSString * username = [dict objectForKey:kUserName];
    NSString * password = [dict objectForKey:kUserEncryptPassword];
    NSString * uid = [dict objectForKey:kUserId];
    NSString * title = [dict objectForKey:kUserTitle];
    NSString * gender = [dict objectForKey:kUserGender];
    
    if (username) {
        [SSKeychain setPassword:username forService:service account:kEFBUserName];
    }
    else {
        return;
    }
    
    if (password) [SSKeychain setPassword:password forService:service account:kEFBPassword];
    if (uid)      [SSKeychain setPassword:uid forService:service account:kUserId];
    if (title)    [SSKeychain setPassword:title forService:service account:kUserTitle];
    if (gender)   [SSKeychain setPassword:gender forService:service account:kUserGender];
}

+ (NSDictionary *)_getUserDictFromKeychainService:(NSString *)service
{
    NSString * username = [SSKeychain passwordForService:service account:kEFBUserName];
    NSString * password = [SSKeychain passwordForService:service account:kEFBPassword];

    if (username == nil) {
        return nil;
    }
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:username, kUserName, nil];
    
    if (password) {
        [dict setObject:password forKey:kUserEncryptPassword];
    }
    
    NSString * title = [SSKeychain passwordForService:service account:kUserTitle];
    if (title) {
        [dict setObject:title forKey:kUserTitle];
    }
    NSString * uid = [SSKeychain passwordForService:service account:kUserId];
    if (uid) {
        [dict setObject:uid forKey:kUserId];
    }
    NSString * gender = [SSKeychain passwordForService:service account:kUserGender];
    if (gender) {
        [dict setObject:gender forKey:kUserGender];
    }

    return dict;
}

- (void)setCurrentFlight:(NSDictionary *)currentFlight
{
    [AEIdentityManager _setDict:currentFlight forPasteboardType:kFlightDomain];
}

- (NSDictionary *)currentFlight
{
    return [AEIdentityManager _getDictFromPasteboardType:kFlightDomain];
}

- (void)setCurrentUser:(NSDictionary *)currentUser
{
//    [AEIdentityManager _setDict:currentUser forPasteboardType:kIdentityDomain];
    [AEIdentityManager _setUserDict:currentUser forKeychainService:kEFBService];
}

- (NSDictionary *)currentUser
{
//    return [AEIdentityManager _getDictFromPasteboardType:kIdentityDomain];
    return [AEIdentityManager _getUserDictFromKeychainService:kEFBService];
}


- (void)logoutWithCompletion:(void(^)(NSError *error))completion
{
    self.currentUser = nil;
    self.currentFlight = nil;
    [[EFBContext sharedDefaultInstance] deleteValue:@[kUserName, kUserEncryptPassword]];
    if (completion) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotification object:self];
        });
    }
}

- (void)loginWithUser:(NSString *)userId password:(NSString *)password completion:(void (^)(NSDictionary *user, NSError * error))completion
{

    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotification object:self];
}

- (void)addNotificationListener:(id)target action:(SEL)action
{
    [[NSNotificationCenter defaultCenter] addObserver:target selector:action name:kLoginNotification object:self];
}

- (void)removeListener:(id)target
{
    [[NSNotificationCenter defaultCenter] removeObserver:target];
}

@end
