//
//  CalculatorWindViewController.m
//  calculator
//
//  Created by hanfei on 13-3-6.
//  Copyright (c) 2013年 ADCC. All rights reserved.
//

#import "EFBUtilitiesDetailViewController.h"

#define origin_x                  88.0f
#define origin_y                  175.0f
#define origin_width              592.0f
#define origin_height             680.0f

@interface EFBUtilitiesDetailViewController ()

@end

@implementation EFBUtilitiesDetailViewController
@synthesize buttonTag;
@synthesize ISAViewController = _ISAViewController;
@synthesize windComponentViewController = _windComponentViewController;
@synthesize climbRateViewController = _climbRateViewController;
@synthesize dropDistanceViewController = _dropDistanceViewController;
@synthesize pressureHeightViewController = _pressureHeightViewController;
@synthesize refuelVolumeViewController = _refuelVolumeViewController;
#pragma mark - View lifecycle
- (void)dealloc
{
    [_climbRateViewController release];
    [_dropDistanceViewController release];
    [_pressureHeightViewController release];
    [_refuelVolumeViewController release];
    [_windComponentViewController release];
    [_ISAViewController release];
    [_buttonArray release];
    [_ISAButton release];
    [_windButton release];
    [_climbButton release];
    [_fallDistanceButton release];
    [_highPressureButton release];
    [_addOilButton release];
    [_backgroundImage release];
    [super dealloc];
}

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_ISAButton setSelected:YES];
    [_windButton setSelected:NO];
    [_climbButton setSelected:NO];
    [_fallDistanceButton setSelected:NO];
    [_highPressureButton setSelected:NO];
    [_addOilButton setSelected:NO];
    
    self.buttonArray = @[_ISAButton,_windButton,_climbButton,_fallDistanceButton,_highPressureButton,_addOilButton];
    /*
    for (int i = 0; i < [self.buttonArray count]; i ++)
    {
        UIButton *button = (UIButton *)[self.buttonArray objectAtIndex:i];
        
        int buttonWidth = 146;
        int buttonHeight = 54;
        int x = 15;
        int y = 75 + (buttonHeight +9)*i;
        
        button.frame = CGRectMake(x, y, buttonWidth, buttonHeight);
     
    }
     */
    buttonTag = 0;
    [self creatViewControllers];
    [self setTitleButton];
}

- (void)setTitleButton
{
    NSString *ISAString = NSLocalizedString(@"utilities-btn-ISA", @"ISA温度");
    NSString *windString = NSLocalizedString(@"utilities-btn-wind", @"风分量");
    NSString *rateString = NSLocalizedString(@"utilities-btn-climb-rate", @"爬升(下降)率\n 爬升(下降梯度)");
    NSString *dropString = NSLocalizedString(@"utilities-btn-drop-distance", @"下降距离");
    NSString *pressureString = NSLocalizedString(@"utilities-btn-pressure-altitude", @"压力高度");
    NSString *refuelString = NSLocalizedString(@"utilities-btn-refuel", @"加油量");

    UIEdgeInsets inset = UIEdgeInsetsMake(13.0f, 30.0f, 11.0f, 1.0f);
    UIEdgeInsets inset1 = UIEdgeInsetsMake(13.0f, 35.0f, 11.0f, 1.0f);
    UIEdgeInsets inset2 = UIEdgeInsetsMake(13.0f, 20.0f, 11.0f, 1.0f);

    [_ISAButton setTitleEdgeInsets:inset];
    [_ISAButton setTitle:ISAString forState:UIControlStateNormal];
    [_windButton setTitleEdgeInsets:inset2];
    [_windButton setTitle:windString forState:UIControlStateNormal];
    [_climbButton setTitleEdgeInsets:UIEdgeInsetsMake(13.0f, 40.0f, 11.0f, 1.0f)];
    [_climbButton setTitle:rateString forState:UIControlStateNormal];
    _climbButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [_fallDistanceButton setTitleEdgeInsets:inset1];
    [_fallDistanceButton setTitle:dropString forState:UIControlStateNormal];
    [_highPressureButton setTitleEdgeInsets:inset1];
    [_highPressureButton setTitle:pressureString forState:UIControlStateNormal];
    [_addOilButton setTitleEdgeInsets:inset2];
    [_addOilButton setTitle:refuelString forState:UIControlStateNormal];
    
    BOOL nightMode = [[UIApplication sharedApplication] nightlyMode];
    UIColor *color = nightMode ? [UIColor whiteColor] : [UIColor blackColor];
    [self changeButtonColor:color];
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"en"]) {
        _ISAButton.titleLabel.font = [UIFont systemFontOfSize:11.0f];
        _windButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _climbButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _fallDistanceButton.titleLabel.font = [UIFont systemFontOfSize:11.0f];
        _highPressureButton.titleLabel.font = [UIFont systemFontOfSize:11.0f];
        _addOilButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        
        [_windButton setTitleEdgeInsets:UIEdgeInsetsMake(13.0f, -20.0f, 11.0f, 1.0f)];
        [_climbButton setTitleEdgeInsets:UIEdgeInsetsMake(13.0f, -5.0f, 11.0f, 1.0f)];
    }
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

- (void)viewDidUnload
{
    [self setRefuelVolumeViewController:nil];
    [self setPressureHeightViewController:nil];
    [self setDropDistanceViewController:nil];
    [self setClimbRateViewController:nil];
    [self setWindComponentViewController:nil];
    [self setISAViewController:nil];
    [self setButtonArray:nil];
    [self setISAButton:nil];
    [self setWindButton:nil];
    [self setClimbButton:nil];
    [self setFallDistanceButton:nil];
    [self setHighPressureButton:nil];
    [self setAddOilButton:nil];
    [self setBackgroundImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#define H_COUNT 4
#define V_COUNT 3
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
    int colInter= (self.view.bounds.size.width-buttonWidth*colNum)/(colNum+1);
    int colInter1= 40;
    
    for (int i=0; i<[self.buttonArray count]; i++) {
        int x=colInter+i%colNum*(buttonWidth+colInter1);
        int y=rowInter+i/colNum*(buttonHeight+rowInter);
        UIView *view = [self.buttonArray objectAtIndex:i];
        
        view.frame = CGRectMake(x, y, buttonWidth, buttonHeight);
        
        if (i == 2) {
            view.frame = CGRectMake(x, y, 250, buttonHeight);
        }
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            if (i == 3) {
                view.frame = CGRectMake(x + 121 + 15, y, buttonWidth, buttonHeight);
            }
        }
        
    }

}

#pragma mark - initViews
- (void)creatViewControllers
{
    self.ISAViewController = [[[EFBISATemperatureViewController alloc]init]autorelease];
    self.ISAViewController.view.frame = CGRectMake(origin_x, origin_y, origin_width, origin_height);
    self.ISAViewController.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self setCurrentViewController:self.ISAViewController];
    
    self.windComponentViewController = [[[EFBWindComponentViewController alloc] init] autorelease];
    self.climbRateViewController = [[[EFBClimbRateViewController alloc] init] autorelease];

    self.dropDistanceViewController = [[[EFBDropDistanceViewController alloc] init] autorelease];
    self.pressureHeightViewController = [[[EFBPressureHeightViewController alloc] init] autorelease];
    self.refuelVolumeViewController = [[[EFBRefuelVolumeViewController alloc] init] autorelease];
}

#pragma mark - TabBar Method
- (IBAction)selectedTab:(UIButton *)button
{
    [button setExclusiveTouch:YES];
    int tag = button.tag;
    
    if (tag == buttonTag) {
        return;
    }
    buttonTag = tag;
    [_ISAButton setSelected:NO];
    [_windButton setSelected:NO];
    [_climbButton setSelected:NO];
    [_fallDistanceButton setSelected:NO];
    [_highPressureButton setSelected:NO];
    [_addOilButton setSelected:NO];
    
    CGRect rect = CGRectMake(origin_x, origin_y, origin_width, origin_height);
    switch (tag) {
        case 0:
            [_ISAButton setSelected:YES];
            self.ISAViewController.view.frame = rect;
            [self setCurrentViewController:self.ISAViewController];
            break;
        case 1:
            [_windButton setSelected:YES];
            self.windComponentViewController.view.frame = rect;
            [self setCurrentViewController:self.windComponentViewController];
            break;
        case 2:
            [_climbButton setSelected:YES];
            self.climbRateViewController.view.frame = rect;
            [self setCurrentViewController:self.climbRateViewController];
            break;
        case 3:
            [_fallDistanceButton setSelected:YES];
            self.dropDistanceViewController.view.frame = rect;
            [self setCurrentViewController:self.dropDistanceViewController];
            break;
        case 4:
            [_highPressureButton setSelected:YES];
            self.pressureHeightViewController.view.frame = rect;
            [self setCurrentViewController:self.pressureHeightViewController];
            break;
        case 5:
            [_addOilButton setSelected:YES];
            self.refuelVolumeViewController.view.frame = rect;
            [self setCurrentViewController:self.refuelVolumeViewController];
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

-(void)nightmodeChanged:(NSNotification*)notification
{
    BOOL enabled = [[notification.userInfo objectForKey:EFBNightModeChanged] boolValue];
    
    UIColor *color = enabled ? [UIColor whiteColor] : [UIColor blackColor];
    [self changeButtonColor:color];
}
@end
