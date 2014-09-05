//
//  AELeftViewController.m
//  efbapp
//
//  Created by 徐 洋 on 14-3-17.
//  Copyright (c) 2014年 ADCC. All rights reserved.
//

#import "UIApplication+EFB.h"
#import "EFBContext.h"
#import "AELeftViewController.h"

#import "AELoginViewController.h"
#import "AEInfoViewController.h"
#import "AEIdentityManager.h"
#import "AEUserAvatar.h"
#import "AESegmentControl.h"
#import "AEContainerViewController.h"

static NSString * const kADCCEfbManageSchema = @"adcc-efbmanage";

enum {
    LogOutConfirmationAlert,
};

@interface AELeftViewController () <AEAppListDelegate, UIAlertViewDelegate>

@property (retain, nonatomic) AEUserAvatar * userAvatar;

@property (weak, nonatomic) IBOutlet UISlider * brightnessSlider;
@property (unsafe_unretained, nonatomic) IBOutlet UISwitch *nightModeSwitch;
//@property (unsafe_unretained, nonatomic) IBOutlet AESegmentControl *segmentControl;

@property (retain, nonatomic) AEAppListViewController * appListViewController;
@property (retain, nonatomic) AEInfoViewController * infoViewController;

@property (retain, nonatomic) AEContainerViewController * container;

@end

@implementation AELeftViewController

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
    // Do any additional setup after loading the view.
    
    // register notification listener
    [[AEIdentityManager defaultManager] addNotificationListener:self action:@selector(loginNotification:)];
    
    self.userAvatar = [[AEUserAvatar alloc] initWithAvatarStyle:AEAvatarDetailStyle];
    self.userAvatar.frame = CGRectOffset(self.userAvatar.bounds, 20, 25);
    
    NSDictionary * currentUser = [[AEIdentityManager defaultManager] currentUser];
    if (currentUser) {
        self.userAvatar.nameLabel.text = [currentUser objectForKey:kUserName];
        self.userAvatar.titleLabel.text = [currentUser objectForKey:kUserTitle];
    }
    else {
        self.userAvatar.nameLabel.text = @"未登录";
        self.userAvatar.titleLabel.text = @"";
    }
    
//    [self.userAvatar addTarget:self action:@selector(avatarTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.userAvatar];
    
    
    // Generate container
    
    self.appListViewController = [[AEAppListViewController alloc] initWithNibName:nil bundle:nil];
    self.appListViewController.delegate = self;
    self.appListViewController.tabBarItem.title = @"应用";
    self.appListViewController.tabBarItem.image = [UIImage imageNamed:@"img-btn"];
    self.appListViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"img-btn-selected"];


    self.infoViewController = [[AEInfoViewController alloc] initWithNibName:nil bundle:nil];
    self.infoViewController.tabBarItem.title = @"信息";
    self.infoViewController.tabBarItem.image = [UIImage imageNamed:@"img-btn"];
    self.infoViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"img-btn-selected"];

    self.container = [[AEContainerViewController alloc]
                      initWithViewControllers:@[self.appListViewController,
                                                self.infoViewController]];
    [self addChildViewController:self.container];
    [self.container.view setFrame:CGRectMake(0, 140, 430, 400)];
    [self.view addSubview:self.container.view];
    [self.container didMoveToParentViewController:self];
    

}

- (void)viewDidAppear:(BOOL)animated
{
    NSString * strBright = [[EFBContext sharedDefaultInstance] objectForkey:kScreenBrightness];
    CGFloat bright = (strBright ? [strBright floatValue] : 1.0);
    self.brightnessSlider.value = bright;
    self.nightModeSwitch.on = [UIApplication sharedApplication].nightlyMode;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)brightnessValueChanged:(id)sender {
        
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationBrightnessChanged object:@(self.brightnessSlider.value)];
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

- (void)loginNotification:(NSNotification *)notification
{
    NSDictionary * currentUser = [[AEIdentityManager defaultManager] currentUser];
    if (currentUser) {
        self.userAvatar.nameLabel.text = [currentUser objectForKey:kUserName];
        self.userAvatar.titleLabel.text = [currentUser objectForKey:kUserTitle];
    }
    else {
        self.userAvatar.nameLabel.text = @"未登录";
        self.userAvatar.titleLabel.text = @"";
    }
}

- (IBAction)logoutTapped:(id)sender {
    UIAlertView * confirm = [[UIAlertView alloc] initWithTitle:@"退出" message:@"退出登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    
    confirm.tag = LogOutConfirmationAlert;
    
    [confirm show];
}

- (IBAction)avatarTapped:(id)sender {
    AELoginViewController * login = [[AELoginViewController alloc] initWithNibName:nil bundle:nil];
    login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    login.dismissable = YES;
    
    [self presentViewController:login animated:YES completion:nil];
}

- (IBAction)nightModeSwitchChanged:(id)sender {
    BOOL enabled = self.nightModeSwitch.on;
        
    [[UIApplication sharedApplication] setNightlyMode:enabled];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == LogOutConfirmationAlert) {
//        AELoginViewController * login;
        switch (buttonIndex) {
            case 0:
                return;
            case 1:
//                login = [[AELoginViewController alloc] initWithNibName:nil bundle:nil];
//                login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//                login.dismissable = YES;
                
                [[AEIdentityManager defaultManager] logoutWithCompletion:^(NSError *error) {
                    if (error) {
                        [[[UIAlertView alloc] initWithTitle:@"错误" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    }
                    else {
                        NSString * schema = [kADCCEfbManageSchema stringByAppendingString:@"://"];
                        NSURL * manageURL = [NSURL URLWithString:schema];
                        [[UIApplication sharedApplication] openURL:manageURL];
                    }
                }];
                
//                [self presentViewController:login animated:YES completion:nil];
                return;
            default:
                break;
        }
    }
}

- (void)appList:(AEAppListViewController *)appList didSelectedAtIndex:(NSInteger)index
{
    if (self.appListDelegate) {
        [self.appListDelegate appList:appList didSelectedAtIndex:index];
    }
}

@end