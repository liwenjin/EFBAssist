//
//  EFBNumpadController.m
//  InputControlProj
//
//  Created by 徐 洋 on 13-7-15.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import "EFBNumpadController.h"

@interface EFBNumpadController()

@end

@implementation EFBNumpadController

- (NSDecimalNumber *)number
{
    return [NSDecimalNumber decimalNumberWithString:self.numPad.displayTextField.text];
}

- (NSString *)unitString
{
    return self.numPad.displayUnitButton.titleLabel.text;
}

- (void)setUnitString:(NSString *)unitString
{
    [self.numPad.displayUnitButton setTitle:[unitString description] forState:UIControlStateNormal];// [unitString description];
}

- (void)setNumber:(NSDecimalNumber *)number
{
    self.numPad.displayTextField.text = [number description];
}

- (id)initWindPadWithTitle:(NSString *)title
{
    self.numPad = [[[EFBNumberPadViewController alloc] init] autorelease];
    self.numPad.navigationItem.title = title;
    self.numPad.isWindPad = YES;
//    NSString *closeBtnTitle = NSLocalizedString(@"utilities-btn-close",@"关闭");
//    self.numPad.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:closeBtnTitle style:UIBarButtonItemStyleBordered target:self action:@selector(onCloseClicked:)] autorelease];
    
    UINavigationController * nav = [[[UINavigationController alloc] initWithRootViewController:self.numPad] autorelease];
    self = [super initWithContentViewController:nav];
    if (self) {
        self.popoverContentSize = CGSizeMake(241, 345);
        
        if ([UIPopoverController instancesRespondToSelector:@selector(backgroundColor)]) {
            self.backgroundColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        }

    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title unit:(NSString *)unit unitArray:(NSArray *)unitArray
{
    self.numPad = [[[EFBNumberPadViewController alloc] init] autorelease];
    self.numPad.navigationItem.title = title;
//    NSString * closeBtnTitle = NSLocalizedString(@"utilities-btn-close",@"关闭");
//    self.numPad.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:closeBtnTitle style:UIBarButtonItemStyleBordered target:self action:@selector(onCloseClicked:)] autorelease];
    self.numPad.isWindPad = NO;
    self.numPad.isCanSelect = YES;
    
    if ([unitArray count] == 0) {
        self.numPad.isCanSelect = NO;
    }else{
        for (int i = 0; i < [unitArray count]; i ++ ) {
            NSString *title = [unitArray objectAtIndex:i];
            if ([title isEqualToString:unit]) {
                self.numPad.selectIndex = i;
            }
            [self.numPad.unitSegment insertSegmentWithTitle:title atIndex:i animated:NO];
        }
    }
    
    UINavigationController * nav = [[[UINavigationController alloc] initWithRootViewController:self.numPad] autorelease];
    self = [super initWithContentViewController:nav];
    if (self) {
        self.popoverContentSize = CGSizeMake(241, 345);
        
        if ([UIPopoverController instancesRespondToSelector:@selector(backgroundColor)]) {
           self.backgroundColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        }
    }
    
    return self;
}

- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated
{
    [super presentPopoverFromRect:rect inView:view permittedArrowDirections:arrowDirections animated:animated];
    
    [_numPad.doneButton addTarget:self action:@selector(onDoneClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_numPad.nextButton addTarget:self action:@selector(onNextClicked:) forControlEvents:UIControlEventTouchUpInside];

}

- (IBAction)onCloseClicked:(id)sender
{
    [self dismissPopoverAnimated:NO];
}

-(void)shakeView
{
    UIView * viewToShake = self.contentViewController.view;
    CGFloat t =5.0;
    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    
    viewToShake.transform = translateLeft;
    
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        viewToShake.transform = translateRight;
    } completion:^(BOOL finished){
        if(finished){
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}

- (IBAction)onDoneClicked:(id)sender
{
    if (self.numpadDelegate) {
        
//        if ([self.numpadDelegate respondsToSelector:@selector(numpadShouldFinishInout:)]) {
            if ([self.numpadDelegate numpadShouldFinishInput:self] == NO) {
                // 拒绝输入
                [self shakeView];
                return;
            }
//        }
        
        [self dismissPopoverAnimated:NO];
        
        if ([self.numpadDelegate respondsToSelector:@selector(numpad:dismissedWithButton:)]) {
            [self.numpadDelegate numpad:self dismissedWithButton:EFBNumpadButtonDone];
        }
    }
}

- (IBAction)onNextClicked:(id)sender
{
    if (self.numpadDelegate) {
        
//        if ([self.numpadDelegate respondsToSelector:@selector(numpadShouldFinishInout:)]) {
            if ([self.numpadDelegate numpadShouldFinishInput:self] == NO) {
                // 拒绝输入
                [self shakeView];
                return;
            }
//        }
        
        [self dismissPopoverAnimated:NO];
        
        if ([self.numpadDelegate respondsToSelector:@selector(numpad:dismissedWithButton:)]) {
            [self.numpadDelegate numpad:self dismissedWithButton:EFBNumpadButtonNext];
        }
    }
}

@end
