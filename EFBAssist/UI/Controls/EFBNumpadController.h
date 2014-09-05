//
//  EFBNumpadController.h
//  InputControlProj
//
//  Created by 徐 洋 on 13-7-15.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFBNumberPadViewController.h"

typedef enum {
    EFBNumpadButtonDone,
    EFBNumpadButtonNext,
}EFBNumpadButton;

#define EFBNumpadConfigTitle            @"title"
#define EFBNumpadConfigDescription      @"description"
#define EFBNumpadConfigInitial          @"initial"

@class EFBNumpadController;

@protocol EFBNumpadDelegate <NSObject>

@optional
- (BOOL)numpadShouldFinishInput:(EFBNumpadController *)numpad;
- (void)numpad:(EFBNumpadController *)numpad dismissedWithButton:(EFBNumpadButton)button;

@end

@interface EFBNumpadController : UIPopoverController

@property (retain, nonatomic) EFBNumberPadViewController * numPad;

@property (assign, nonatomic) id<EFBNumpadDelegate> numpadDelegate;

@property (assign, setter = setNumber:, getter=number) NSDecimalNumber * number;

@property (copy, nonatomic) NSString *unitString;

- (id)initWindPadWithTitle:(NSString *)title;
- (id)initWithTitle:(NSString *)title unit:(NSString *)unit unitArray:(NSArray *)unitArray;


@end
