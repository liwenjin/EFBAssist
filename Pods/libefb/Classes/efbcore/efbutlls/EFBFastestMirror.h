//
//  EFBFastestMirror.h
//  EFBFrameworkProject
//
//  Created by 徐 洋 on 13-9-11.
//  Copyright (c) 2013年 ADCC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EFBFastestMirror : NSObject

@property (assign, nonatomic) float timeout;

/*
    
 */
- (id)initWithMirrors:(NSArray *)mirrors;

/*
 Retrieve the sorted list of mirrors
 */
- (NSArray *)mirrorList:(int)top;

@end
