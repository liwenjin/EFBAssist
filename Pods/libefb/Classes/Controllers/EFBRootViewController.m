//
//  EFBRootViewController.m
//  Pods
//
//  Created by 徐 洋 on 14-6-16.
//
//

#import <PixateFreestyle.h>
#import "EFBContext.h"
#import "EFBNotifications.h"
#import "EFBRootViewController.h"
#import "EFBBaseViewController.h"
#import "EFBViewControllerContainer.h"
#import "AELeftViewController.h"
#import "AEAppListViewController.h"


#define kViewControllerList         @"EFBViewControllerList"
#define kViewControllerTitle        @"EFBViewControllerTitle"
#define kViewControllerIconPrefix   @"EFBTabIconPrefix"
#define kViewControllerClass        @"EFBViewControllerClass"
#define kHideMainTabbar             @"EFBHideTabbar"
#define kHideMainTabbarButtons      @"EFBHideTabbarButtons"
#define kHideVersion                @"EFBHideVersion"
#define kHideLogo                   @"EFBHideLogo"
#define APP_PLIST_NAME      @"app"



@interface EFBRootViewController() <AEAppListDelegate>

@property (retain, nonatomic) AELeftViewController * leftController;
@property (retain, nonatomic) EFBViewControllerContainer * centerController;
@property (retain, nonatomic) NSArray * mainViewControllers;

@property (assign, nonatomic) BOOL isScreenLocked;
@property (retain, nonatomic) UIView * lockView;
@property (retain, nonatomic) UIView * maskView;

@end

@implementation EFBRootViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    [self _loadMainViewControllers];
    
    self.leftController = [[AELeftViewController alloc] initWithNibName:@"AELeftViewController" bundle:nil];
    self.leftController.appListDelegate = self;
    
    self.centerController = [[EFBViewControllerContainer alloc] initWithViewControllers:self.mainViewControllers];
    
    self = [super initWithCenterViewController:self.centerController leftViewController:self.leftController];
    if (self) {
        // Custom initialization
        
        self.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
    }
    return self;
}

- (BOOL)shouldAutorotate
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.leftSize = 1024 - 430;
    }
    else {
        self.leftSize = 768 - 430;
    }
    return !_isScreenLocked;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self _createLockView];
    
    // create maskView
    
    _maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    [_maskView setUserInteractionEnabled:NO];
    [_maskView setBackgroundColor:[UIColor blackColor]];
    
    NSString * strBright = [[EFBContext sharedDefaultInstance] objectForkey:kScreenBrightness];
    CGFloat bright = (strBright ? [strBright floatValue] : 1.0);
    [_maskView setAlpha:(1-bright)];
    [self.view addSubview:_maskView];
    
    [_maskView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_maskView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBaseline multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_maskView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_maskView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_maskView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];

    
    [[NSNotificationCenter defaultCenter] addObserverForName:kEFBScreenLocked
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
            [self _lockScreen];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kNotificationBrightnessChanged object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        CGFloat bright = [note.object floatValue];
        [self.maskView setAlpha:(1-bright)];
        
        [[EFBContext sharedDefaultInstance] setValue:[NSString stringWithFormat:@"%f", bright] forKey:kScreenBrightness];
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)appList:(AEAppListViewController *)appList didSelectedAtIndex:(NSInteger)index
{
    EFBBaseViewController * viewController = [self.mainViewControllers objectAtIndex:index];
    self.centerController.selectedViewController = viewController;
}

#pragma mark - Prive methods

- (void)_createLockView
{
    _lockView = [[UIView alloc] initWithFrame:self.view.bounds];
    _lockView.backgroundColor = [UIColor clearColor];
    [_lockView setUserInteractionEnabled:YES];
    [_lockView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    UIButton * unlockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    unlockBtn.styleClass = @"unlock";
    unlockBtn.bounds = CGRectMake(0, 0, 60, 60);
    [unlockBtn addTarget:self action:@selector(_unlockBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [_lockView addSubview:unlockBtn];
    [unlockBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [_lockView addConstraint:[NSLayoutConstraint constraintWithItem:unlockBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_lockView attribute:NSLayoutAttributeRight multiplier:1 constant:-5]];
    [_lockView addConstraint:[NSLayoutConstraint constraintWithItem:unlockBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lockView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (void)_loadMainViewControllers
{
    NSMutableArray * vcArray = [[NSMutableArray alloc] init];
    
    NSString * plistPath = [[NSBundle mainBundle] pathForResource:APP_PLIST_NAME ofType:@"plist"];
    NSDictionary * appPlist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSAssert(appPlist, @"%@.plist not found!", APP_PLIST_NAME);
    
    NSArray * vcList = [appPlist objectForKey:kViewControllerList];
    NSAssert(vcList, @"%@ not found in %@.plist", kViewControllerList, APP_PLIST_NAME);
    
    [vcList enumerateObjectsUsingBlock:^(NSDictionary * vcprop, NSUInteger i, BOOL *stop) {
        EFBBaseViewController * viewController;
        
        NSString * classSignature = [vcprop objectForKey:kViewControllerClass];
        Class vcClass = NSClassFromString(classSignature);
        viewController = [[vcClass alloc] init];
        NSAssert(viewController, @"ViewController <%@> create failed.", classSignature);
        viewController.title = [vcprop objectForKey:kViewControllerTitle];
        
        viewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        
        [vcArray addObject:viewController];
    }];
    
    self.mainViewControllers = vcArray;
}


- (void)_lockScreen
{
    [self.view addSubview:_lockView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_lockView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_lockView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_lockView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_lockView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight multiplier:1
                                                           constant:0]];
    _isScreenLocked = YES;
}

- (void)_unlockScreen
{
    [_lockView removeFromSuperview];
    _isScreenLocked = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kEFBScreenUnlocked object:nil];
}


- (void)_unlockBtnTapped:(id)sender
{
    [self _unlockScreen];
}

@end
