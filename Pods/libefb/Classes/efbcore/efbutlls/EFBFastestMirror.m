//
//  EFBFastestMirror.m
//  EFBFrameworkProject
//
//  Created by 徐 洋 on 13-9-11.
//  Copyright (c) 2013年 ADCC. All rights reserved.
//

#import "EFBFastestMirror.h"

const float DefaultTimeout = 5.0f;

@interface EFBPingRequest : NSURLRequest

@property (retain, nonatomic) id userInfo;

+ (EFBPingRequest *)pingRequestWithURL:(NSURL *)url timeout:(float)timeout;

@end

@implementation EFBPingRequest

- (void)dealloc
{
}

+ (EFBPingRequest *)pingRequestWithURL:(NSURL *)url timeout:(float)timeout
{
    EFBPingRequest * r = [EFBPingRequest requestWithURL:url cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:timeout];
    
    return r;
}


@end

/*
 
    Implementations
 
 */

@interface EFBFastestMirror() <NSURLConnectionDataDelegate>

@property (retain, nonatomic) NSArray *mirrors;
@property (retain, nonatomic) NSMutableDictionary *results;
@property (retain, nonatomic) NSMutableDictionary *connections;

@end


@implementation EFBFastestMirror

- (void)dealloc
{
}

- (id)initWithMirrors:(NSArray *)mirrors
{
    self = [super init];
    if (self) {
        self.mirrors = mirrors;
        self.results = [NSMutableDictionary dictionary];
        self.connections = [NSMutableDictionary dictionary];
        self.timeout = DefaultTimeout;
    }
    
    return self;
}

- (NSArray *)mirrorList:(int)top
{
    [self pollMirrors];
    
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];    
    while ([self.connections count]>0 && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    
    NSArray *sortedMirrors = nil;
    @synchronized(self) {
        sortedMirrors = [self.mirrors sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSNumber *tm1 = [self.results objectForKey:obj1];
            NSNumber *tm2 = [self.results objectForKey:obj2];
            
            if (!tm1 && !tm1) {
                return NSOrderedSame;
            }
            else if (!tm1) {
                return NSOrderedDescending;
            }
            else if (!tm2){
                return NSOrderedAscending;
            }
            
            return [tm1 compare:tm2];
        }];
    }
    return sortedMirrors;
}

- (void)addResults:(NSString *)mirror host:(NSString *)host time:(float)tm
{
    @synchronized(self) {
        NSNumber *t = [NSNumber numberWithFloat:tm];
        [self.results setObject:t forKey:mirror];
        
        NSLog(@"%@\t\t%@\n", mirror, t);
    }
}

const NSString * kMirror = @"mirror";
const NSString * kStart  = @"start-time";

- (void)pollMirrors
{
    [self.connections removeAllObjects];
    
    for (NSString *mirror in self.mirrors) {
        NSURL *url = [NSURL URLWithString:mirror];
        
        EFBPingRequest *request = [EFBPingRequest pingRequestWithURL:url timeout:self.timeout];
        request.userInfo = @{kMirror: mirror,
                             kStart: [NSDate date]
                             };
        
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
        [self.connections setObject:connection forKey:mirror];
    }
}

#pragma - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    EFBPingRequest *ping = (EFBPingRequest *)connection.originalRequest;
    NSString * mirror = [ping.userInfo objectForKey:kMirror];
    NSString * host = [ping.URL host];
    
    [self addResults:mirror host:host time:99999999999];
    
    // Joining
    @synchronized(self) {
        [self.connections removeObjectForKey:mirror];
        NSLog(@"Coonection failed: %@", error);
    }
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
//        if ([trustedHosts containsObject:challenge.protectionSpace.host])
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

#pragma - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    EFBPingRequest *ping = (EFBPingRequest *)connection.originalRequest;
    NSString * mirror = [ping.userInfo objectForKey:kMirror];
    NSString * host = [ping.URL host];
    NSDate * start = [ping.userInfo objectForKey:kStart];
    
    NSDate * now = [NSDate date];
    
    NSTimeInterval sec = [now timeIntervalSinceDate:start];
    
    [self addResults:mirror host:host time:sec];
    
    // Joining
    @synchronized(self) {
        [self.connections removeObjectForKey:mirror];
    }
}

@end
