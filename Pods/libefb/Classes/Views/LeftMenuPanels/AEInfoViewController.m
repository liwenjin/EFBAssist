//
//  AEInfoViewController.m
//  efbapp
//
//  Created by 徐 洋 on 14-3-17.
//  Copyright (c) 2014年 ADCC. All rights reserved.
//

#import "UIDevice+EFB.h"
#import "AEInfoViewController.h"

#ifdef DEBUG
static NSString * DEBUG_PREFIX = @"(DEBUG)";
#else
static NSString * DEBUG_PREFIX = @"";
#endif

@interface AEInfoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *udidLabel;

@end

@implementation AEInfoViewController

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
    
    self.udidLabel.text = [NSString stringWithFormat:@"%@%@", DEBUG_PREFIX, [[UIDevice currentDevice] efbHardwareId]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
