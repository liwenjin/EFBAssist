//
//  EFBCalculatorViewController.m
//  EFBAssist
//
//  Created by ⟢E⋆F⋆B⟣ on 14-3-17.
//  Copyright (c) 2014年 ADCC. All rights reserved.
//

#import "EFBCalculatorViewController.h"
#import <UIApplication+EFB.h>
#import <EFBTitleBar.h>

@interface EFBCalculatorViewController ()

@property (retain, nonatomic) EFBTitleBar *titleBar;
@end

@implementation EFBCalculatorViewController

- (void) dealloc
{
    [_calculator release];
    [_titleBar release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenTapped) name:@"HIDDENLAYER_TARGET" object:nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self contentViewDidLoad];

	// Do any additional setup after loading the view.
    self.calculator=[[[CalculatorViewController alloc]init] autorelease];
    self.calculator.view.frame=CGRectMake(0, 67, self.view.frame.size.width, self.view.frame.size.height-67);
    [self.view addSubview:_calculator.view];
    

}

- (void)contentViewDidLoad
{
//    [super contentViewDidLoad];
	// Do any additional setup after loading the view.
    
    self.titleBar = [[[EFBTitleBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 66.0f)] autorelease];
//    self.titleBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.titleBar.titleLabel.text = self.title;

    [self.view addSubview:self.titleBar];
    [self didFinishLoadView];

    BOOL nightMode = [[UIApplication sharedApplication] nightlyMode];
    self.view.backgroundColor = nightMode ? [UIColor blackColor] : [UIColor whiteColor];
}

- (void)viewWillLayoutSubviews
{
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        self.titleBar.frame = CGRectMake(0, 0, 1024, 66.0f);
    }else{
        self.titleBar.frame = CGRectMake(0, 0, 768, 66.0f);

    }
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
