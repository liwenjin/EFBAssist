//
//  EFBFlightTask.m
//  efbcore
//
//  Created by chu-imac on 13-11-8.
//  Copyright (c) 2013年 ADCC. All rights reserved.
//

#import "EFBFlightTask.h"
#import "SSKeychain.h"
#import "EFBContext.h"

NSString *EFBServices = @"cn.com.adcc.efb";
NSString *EFBTaskDate = @"EFBTaskDate";
NSString *EFBTailNo = @"EFBTailNo";
NSString *EFBFlightNo = @"EFBFlightNo";
NSString *EFBTaskDeparture = @"EFBTaskDeparture";
NSString *EFBTaskArrvial  = @"EFBTaskArrvial";

@implementation EFBFlightTask


+ (void)getFlightTask
{
    NSError *errorTailNo = nil;
    NSString *tailNo=nil;
    NSError *errorFlightNo = nil;
    NSString *flightNo=nil;
    NSError *errorTaskDate = nil;
    NSString *taskDate=nil;
    NSError *errorTaskDeparture = nil;
    NSString *taskDeparture=nil;
    NSError *errorTaskArrival = nil;
    NSString *taskArrival=nil;
    
    tailNo= [SSKeychain passwordForService:EFBServices account:EFBTailNo error:&errorTailNo];
    flightNo= [SSKeychain passwordForService:EFBServices account:EFBFlightNo error:&errorFlightNo];
    taskDate= [SSKeychain passwordForService:EFBServices account:EFBTaskDate error:&errorTaskDate];
    taskDeparture= [SSKeychain passwordForService:EFBServices account:EFBTaskDeparture error:&errorTaskDeparture];
    taskArrival= [SSKeychain passwordForService:EFBServices account:EFBTaskArrvial error:&errorTaskArrival];
    
    if ([errorTailNo code]==SSKeychainErrorNotFound) {
        tailNo=@"";
    }
    if ([errorFlightNo code]==SSKeychainErrorNotFound) {
        flightNo=@"";
    }
    if ([errorTaskDeparture code]==SSKeychainErrorNotFound) {
        taskDeparture=@"";
    }
    if ([errorTaskArrival code]==SSKeychainErrorNotFound) {
        taskArrival=@"";
    }
    if ([errorTaskDeparture code]==SSKeychainErrorNotFound) {
        taskDeparture=@"";
    }
    
    NSDictionary * testFlightDict = [NSDictionary dictionaryWithObjectsAndKeys:flightNo, kFlightNumber, tailNo, kFlightTail, taskDeparture, kFlightDeparture, taskArrival, kFlightDestination, taskDate, kFlightDate, nil];
    
    [[EFBContext sharedInstance] setObject:testFlightDict forKey:kFlightDictionary];
    
}


@end
