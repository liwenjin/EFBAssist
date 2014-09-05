//
//  ViewController.m
//  EFBFrameworkProject
//
//  Created by 徐 洋 on 13-8-5.
//  Copyright (c) 2013年 ADCC. All rights reserved.
//
#import <IIViewDeckController.h>
#import <PixateFreeStyle.h>

#import "EFBViewControllerContainer.h"
#import "EFBProperties.h"
#import "EFBUIStyle.h"

#import "AELoginViewController.h"
#import "AEIdentityManager.h"

#define STARTBUTTON_W    44.0f
#define STARTBUTTON_h    44.0f

#define MAINTABBAR_WIDTH    84.0f
#define MAINTABBAR_HEIGHT   600.0f
#define MAINTABBAR_HEIGHT_COLLAPSE  66.0f

@interface EFBViewControllerContainer ()

@property (nonatomic, copy, readwrite) NSArray *viewControllers;
@property (nonatomic, strong) UIView *privateContainerView; /// The view hosting the child view controllers views.

@end

@implementation EFBViewControllerContainer

- (instancetype)initWithViewControllers:(NSArray *)viewControllers {
	NSParameterAssert ([viewControllers count] > 0);
	if ((self = [super init])) {
		self.viewControllers = [viewControllers copy];
	}
	return self;
}

- (void)loadView {
    
	// Add  container and buttons views.
    
	UIView *rootView = [[UIView alloc] init];
	rootView.backgroundColor = [UIColor blackColor];
	rootView.opaque = YES;
    
	self.privateContainerView = [[UIView alloc] init];
	self.privateContainerView.backgroundColor = [UIColor blackColor];
	self.privateContainerView.opaque = YES;
    
	[self.privateContainerView setTranslatesAutoresizingMaskIntoConstraints:YES];
    self.privateContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.privateContainerView.frame = rootView.bounds;
	[rootView addSubview:self.privateContainerView];
    
	self.view = rootView;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.selectedViewController = (self.selectedViewController ?: self.viewControllers[0]);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.selectedViewController) {
        [self.selectedViewController viewWillAppear:animated];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.selectedViewController) {
        [self.selectedViewController viewDidAppear:animated];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
	return self.selectedViewController;
}

-(void)setSelectedViewController:(EFBBaseViewController *)selectedViewController {
	NSParameterAssert (selectedViewController);
	[self _transitionToChildViewController:selectedViewController];
	_selectedViewController = selectedViewController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toggleSiderPanel
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

#pragma mark Private Methods

- (void)_transitionToChildViewController:(UIViewController *)toViewController {
    
	UIViewController *fromViewController = ([self.childViewControllers count] > 0 ? self.childViewControllers[0] : nil);
	if (toViewController == fromViewController || ![self isViewLoaded]) {
		return;
	}
    
	UIView *toView = toViewController.view;
	[toView setTranslatesAutoresizingMaskIntoConstraints:YES];
	toView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	toView.frame = self.privateContainerView.bounds;
    
	[fromViewController willMoveToParentViewController:nil];
	[fromViewController.view removeFromSuperview];
	[fromViewController removeFromParentViewController];
	[self addChildViewController:toViewController];
	[toViewController didMoveToParentViewController:self];
	[self.privateContainerView addSubview:toView];
}

@end
