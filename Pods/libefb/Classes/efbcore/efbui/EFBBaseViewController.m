//
//  EFBBaseViewController.m
//  EFBFrameworkProject
//
//  Created by 徐 洋 on 13-8-5.
//  Copyright (c) 2013年 ADCC. All rights reserved.
//

#import <PixateFreestyle.h>
#import "EFBContext.h"
#import "EFBUIStyle.h"
#import "EFBBaseViewController.h"
#import "EFBViewControllerContainer.h"
#import "EFBNotifications.h"

#define STARTBUTTON_W    44.0f

#define TITLEBAR_HEIGHT 64.0f
#define DEFAULT_WIDTH   668.0f
#define DEFAULT_HEIGHT   1004.0f


@interface EFBBaseViewController ()

@property (retain, nonatomic) EFBAccessoryBar * accessoryBar;
@property (retain, nonatomic) UIButton * expandButton;

@end

@implementation EFBBaseViewController

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNightModeChanged:) name:kScreenNightMode object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kEFBScreenUnlocked object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self unlockScreen];
    }];
    [self _buildExpandButton];
    
}

- (void)didFinishLoadView
{
    [self.view bringSubviewToFront:self.expandButton];
    [self.view bringSubviewToFront:self.accessoryBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSLog(@"EFBBaseViewController: didReceiveMemoryWarning");
}

- (void)onNightModeChanged:(NSNotification *)notification
{
    BOOL enabled = [[notification.userInfo objectForKey:kScreenNightMode] boolValue];
    
    [self efbNightModeChanged:enabled];
}

- (void)efbNightModeChanged:(BOOL)enabled
{
    // Needs be overwritten by subclasses
    NSLog(@"efbNightModeChanged: %@", @(enabled));
}

- (void)setFullScreenMode:(BOOL)enable
{
    _fullScreenMode = enable;
        
    [self.view setNeedsLayout];
}

- (void)setExpandButtonHidden:(BOOL)expandButtonHidden
{
    _expandButtonHidden = expandButtonHidden;
    
    self.expandButton.hidden = self.expandButtonHidden;
}

- (void)expandButtonTapped:(id)sender
{
    [(EFBViewControllerContainer *)self.parentViewController toggleSiderPanel];
}

- (void)setAccessoryItems:(NSArray *)accessoryItems
{
    NSParameterAssert(accessoryItems);
    
    if (self.accessoryBar) {
        [self.accessoryBar removeFromSuperview];
    }
    
    _accessoryItems = [accessoryItems copy];
    EFBAccessoryBar * accBar = [[EFBAccessoryBar alloc] initWithItems:self.accessoryItems];
    
    CGSize size = [accBar preferedSize];
    
    [accBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:accBar];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:accBar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:size.width]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:accBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:size.height]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:accBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-5]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:accBar attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    

    self.accessoryBar = accBar;
}

- (void)lockScreen
{
    self.accessoryBar.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kEFBScreenLocked object:nil];
}

- (void)unlockScreen
{
    self.accessoryBar.hidden = NO;
}

#pragma mark - Private methods

- (void)_buildExpandButton
{
    UIButton * expButton = [UIButton buttonWithType:UIButtonTypeCustom];
    expButton.styleId = @"expand-btn";
    
    UIImageView * icon = [[UIImageView alloc] init];
    icon.styleClass = @"icon";
    icon.frame = CGRectMake(0, 20, 44, 44);
    [expButton addSubview:icon];
    
    [self.view addSubview:expButton];
    
    [expButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.expandButton = expButton;
    
    [expButton addTarget:self action:@selector(expandButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:expButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:expButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:64]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:expButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:expButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
}

@end
