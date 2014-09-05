//
//  EFBUnitTranslatedDetailViewController.m
//  hnaefb
//
//  Created by EFB on 13-9-6.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import "EFBUnitTranslatedDetailViewController.h"

#define origin_x                  88.0f
#define origin_y                  175.0f
#define origin_width              592.0f
#define origin_height             680.0f

@interface EFBUnitTranslatedDetailViewController ()

@end

@implementation EFBUnitTranslatedDetailViewController
@synthesize buttonTag;

#pragma mark - view lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(nightmodeChanged:) name:EFBNightModeChanged object:nil];
    }
    return self;
}

- (void)dealloc
{
    [_speedTranslatedViewController release];
    [_weightTranslatedViewController release];
    [_distanceTranslatedViewController release];
    [_pressureTranslatedViewController release];
    [_temperatureTranslatedViewController release];
    [_volumeTranslatedViewController release];
    [_densityTranslatedViewController release];
    [_buttonArray release];
    [_speedButton release];
    [_weightButton release];
    [_distanceButton release];
    [_pressureButton release];
    [_temperatureButton release];
    [_volumeButton release];
    [_densityButton release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [_speedButton setSelected:YES];
    [_weightButton setSelected:NO];
    [_distanceButton setSelected:NO];
    [_pressureButton setSelected:NO];
    [_temperatureButton setSelected:NO];
    [_volumeButton setSelected:NO];
    [_densityButton setSelected:NO];
    
    [_speedButton setTitle:NSLocalizedString(@"utilities-btn-speed",@"速度") forState:UIControlStateNormal];
    [_weightButton setTitle:NSLocalizedString(@"utilities-btn-weight",@"重量") forState:UIControlStateNormal];
    [_distanceButton setTitle:NSLocalizedString(@"utilities-btn-distance",@"距离") forState:UIControlStateNormal];
    [_pressureButton setTitle:NSLocalizedString(@"utilities-btn-pressure",@"压强") forState:UIControlStateNormal];
    [_temperatureButton setTitle:NSLocalizedString(@"utilities-btn-temperature",@"温度") forState:UIControlStateNormal];
    [_volumeButton setTitle:NSLocalizedString(@"utilities-btn-volume",@"体积") forState:UIControlStateNormal];
    [_densityButton setTitle:NSLocalizedString(@"utilities-btn-density",@"密度") forState:UIControlStateNormal];
    
    self.buttonArray = @[_speedButton,_weightButton,_distanceButton,_pressureButton,_temperatureButton,_volumeButton,_densityButton];
  
    buttonTag = 0;
    
    BOOL nightMode = [[UIApplication sharedApplication] nightlyMode];
    UIColor *color = nightMode ? [UIColor whiteColor] : [UIColor blackColor];
    [self changeButtonColor:color];

    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"en"]) {
        [_distanceButton setTitleEdgeInsets:UIEdgeInsetsMake(10.0f, 15.0f, 11.0f, 1.0f)];
        [_pressureButton setTitleEdgeInsets:UIEdgeInsetsMake(10.0f, 15.0f, 11.0f, 1.0f)];
        _temperatureButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_temperatureButton setTitleEdgeInsets:UIEdgeInsetsMake(10.0f, 35.0f, 11.0f, 1.0f)];
        [_volumeButton setTitleEdgeInsets:UIEdgeInsetsMake(10.0f, 5.0f, 11.0f, 1.0f)];
        [_densityButton setTitleEdgeInsets:UIEdgeInsetsMake(10.0f, 5.0f, 11.0f, 1.0f)];
    }
    
    [self initViewControllers];
}

- (void)changeButtonColor:(UIColor *)color
{
    for (int i = 0; i < [self.buttonArray count]; i ++)
    {
        UIButton *button = (UIButton *)self.buttonArray[i];
        [button setTitleColor:color forState:UIControlStateNormal];
        [button setTitleColor:color forState:UIControlStateHighlighted];
        [button setTitleColor:color forState:UIControlStateSelected];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
   
}

- (void)viewDidUnload {
    [self setSpeedTranslatedViewController:nil];
    [self setWeightTranslatedViewController:nil];
    [self setDistanceTranslatedViewController:nil];
    [self setPressureTranslatedViewController:nil];
    [self setTemperatureTranslatedViewController:nil];
    [self setVolumeTranslatedViewController:nil];
    [self setDensityTranslatedViewController:nil];
    [self setButtonArray:nil];
    [self setSpeedButton:nil];
    [self setWeightButton:nil];
    [self setDistanceButton:nil];
    [self setPressureButton:nil];
    [self setTemperatureButton:nil];
    [self setVolumeButton:nil];
    [self setDensityButton:nil];
    [super viewDidUnload];
}

#define H_COUNT 5
#define V_COUNT 4
- (void)viewWillLayoutSubviews
{
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        CGRect rect = CGRectMake(origin_x, origin_y, 850, 520);
        _currentViewController.view.frame = rect;
    }
    else
    {
        CGRect rect = CGRectMake(origin_x, origin_y, origin_width, origin_height);
        _currentViewController.view.frame = rect;
    }
    
    int colNum = V_COUNT;
    int rowInter = 15;
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        // 如果是横屏
        rowInter = 30;
        colNum = H_COUNT;
    }
    
    int buttonWidth = 129;
    int buttonHeight = 44;
    
    //先计算列间隔和行间隔
    int colInter=(self.view.bounds.size.width-buttonWidth*colNum)/(colNum+1);
    
    
    for (int i=0; i<[self.buttonArray count]; i++) {
        int x=colInter+i%colNum*(buttonWidth+colInter);
        int y=rowInter+i/colNum*(buttonHeight+rowInter);
        UIView *view = [self.buttonArray objectAtIndex:i];
        
        view.frame = CGRectMake(x, y, buttonWidth, buttonHeight);
        
    }

}

#pragma mark - initViews
- (void)initViewControllers
{
    self.speedTranslatedViewController = [[[EFBSpeedTranslatedViewController alloc] init] autorelease];
    CGRect rect = CGRectMake(origin_x, origin_y, origin_width, origin_height);
    self.speedTranslatedViewController.view.frame = rect;
    [self setCurrentViewController:self.speedTranslatedViewController];

    self.weightTranslatedViewController = [[[EFBWeightTranslatedViewController alloc] init] autorelease];
    self.distanceTranslatedViewController = [[[EFBDistanceTranslatedViewController alloc] init] autorelease];
    self.pressureTranslatedViewController = [[[EFBPressureTranslatedViewController alloc] init] autorelease];
    self.temperatureTranslatedViewController = [[[EFBTemperatureTranslatedViewController alloc] init] autorelease];
    self.volumeTranslatedViewController = [[[EFBVolumeTranslatedViewController alloc] init] autorelease];
    self.densityTranslatedViewController = [[[EFBDensityTranslatedViewController alloc] init] autorelease];
}

#pragma mark - TabBarClick
- (IBAction)selectedTab:(UIButton *)button
{
    [button setExclusiveTouch:YES];
    int tag = button.tag;
    
    if (tag == buttonTag) {
        return;
    }
    buttonTag = tag;
    [_speedButton setSelected:NO];
    [_weightButton setSelected:NO];
    [_distanceButton setSelected:NO];
    [_pressureButton setSelected:NO];
    [_temperatureButton setSelected:NO];
    [_volumeButton setSelected:NO];
    [_densityButton setSelected:NO];
    
    CGRect rect = CGRectMake(origin_x, origin_y, origin_width, origin_height);
    switch (tag) {
        case 0:
            [_speedButton setSelected:YES];
            self.speedTranslatedViewController.view.frame = rect;
            [self setCurrentViewController:self.speedTranslatedViewController];
            break;
        case 1:
            [_weightButton setSelected:YES];
            self.weightTranslatedViewController.view.frame = rect;
            [self setCurrentViewController:self.weightTranslatedViewController];
            break;
        case 2:
            [_distanceButton setSelected:YES];
            self.distanceTranslatedViewController.view.frame = rect;
            [self setCurrentViewController:self.distanceTranslatedViewController];
            break;
        case 3:
            [_pressureButton setSelected:YES];
            self.pressureTranslatedViewController.view.frame = rect;
            [self setCurrentViewController:self.pressureTranslatedViewController];
            break;
        case 4:
            [_temperatureButton setSelected:YES];
            self.temperatureTranslatedViewController.view.frame = rect;
            [self setCurrentViewController:self.temperatureTranslatedViewController];
            break;
        case 5:
            [_volumeButton setSelected:YES];
            self.volumeTranslatedViewController.view.frame = rect;
            [self setCurrentViewController:self.volumeTranslatedViewController];
            break;
        case 6:
            [_densityButton setSelected:YES];
            self.densityTranslatedViewController.view.frame = rect;
            [self setCurrentViewController:self.densityTranslatedViewController];
            break;
        default:
            break;
    }
}

- (void)setCurrentViewController:(UIViewController *) newViewCtrl{
	if (_currentViewController != newViewCtrl)
	{
		if ( _currentViewController )
        {
			[_currentViewController.view removeFromSuperview];
			//[_currentViewController release];
		}
		_currentViewController = newViewCtrl;
		[self.view addSubview:_currentViewController.view];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)nightmodeChanged:(NSNotification*)notification
{
    BOOL enabled = [[notification.userInfo objectForKey:EFBNightModeChanged] boolValue];
//    self.view.backgroundColor = enabled ? [UIColor blackColor] : [UIColor whiteColor];
    UIColor *color = enabled ? [UIColor whiteColor] : [UIColor blackColor];
    [self changeButtonColor:color];

}

@end
