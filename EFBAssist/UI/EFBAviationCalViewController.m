//
//  EFBAviationCalViewController.m
//  EFBAssist
//
//  Created by ⟢E⋆F⋆B⟣ on 14-3-17.
//  Copyright (c) 2014年 ADCC. All rights reserved.
//

#import "EFBAviationCalViewController.h"
#import <UIApplication+EFB.h>
#import <EFBTitleBar.h>

@interface EFBAviationCalViewController ()

@end

@implementation EFBAviationCalViewController

-(void)dealloc
{
    [_calculatorDetailViewController release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenTapped) name:@"HIDDENLAYER_TARGET" object:nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.calculatorDetailViewController = [[[EFBUtilitiesDetailViewController alloc] init] autorelease];
    self.calculatorDetailViewController.view.frame=CGRectMake(0, 67, self.view.bounds.size.width, self.view.bounds.size.height);
    self.calculatorDetailViewController.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_calculatorDetailViewController.view];
    
    [self contentViewDidLoad];

}

- (void)contentViewDidLoad
{
//    [super contentViewDidLoad];
	// Do any additional setup after loading the view.
    
    EFBTitleBar *titleBar = [[[EFBTitleBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 66.0f)] autorelease];
    titleBar.titleLabel.text = self.title;
    titleBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:titleBar];
    
    [self didFinishLoadView];
    
    BOOL nightMode = [[UIApplication sharedApplication] nightlyMode];
    self.view.backgroundColor = nightMode ? [UIColor blackColor] : [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fullScreenTapped:(id)sender
{
    self.fullScreenMode = !self.fullScreenMode;
}

- (void)fullScreenTapped
{
    self.fullScreenMode = !self.fullScreenMode;
}

- (void)efbNightModeChanged:(BOOL)enabled
{
    self.view.backgroundColor = enabled ? [UIColor blackColor] : [UIColor whiteColor];
}

@end
