//
//  AECenterViewController.m
//  efbapp
//
//  Created by 徐 洋 on 14-3-17.
//  Copyright (c) 2014年 ADCC. All rights reserved.
//

#import <IIViewDeckController.h>

#import "AECenterViewController.h"
#import "AELoginViewController.h"
#import "AEIdentityManager.h"

@implementation AECenterViewController

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
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"TEST";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"三" style:UIBarButtonItemStylePlain target:self action:@selector(slideTapped:)];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    NSDictionary * currentUser = [[AEIdentityManager defaultManager] currentUser];
    if (currentUser == nil) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            AELoginViewController *login = [[AELoginViewController alloc] init];
            login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:login animated:YES completion:nil];
        });
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)slideTapped:(id)sender {
    BOOL ret = [self.viewDeckController toggleLeftViewAnimated:YES];
    NSLog(@"returns: %d", ret);
}

@end
