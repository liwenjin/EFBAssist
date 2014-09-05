//
//  AELanguagePickerViewController.m
//  efbapp
//
//  Created by 徐 洋 on 14-3-17.
//  Copyright (c) 2014年 ADCC. All rights reserved.
//

#import "AELanguagePickerViewController.h"
#import "AELanguageTableViewCell.h"

@interface AELanguagePickerViewController () <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) NSString * localString;

@end

@implementation AELanguagePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _localString = @"zh_CN";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * reuseIdentifier = @"language-cell";
    AELanguageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[AELanguageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.iconImage.image = [UIImage imageNamed:@"img-flag-china"];
            cell.languageNameLabel.text = @"简体中文";
            [cell setSelected:[self.localString isEqualToString:@"zh_CN"] animated:NO];
            break;
        case 1:
            cell.iconImage.image = [UIImage imageNamed:@"img-flag-usa"];
            cell.languageNameLabel.text = @"English";
            [cell setSelected:[self.localString isEqualToString:@"en_US"] animated:NO];
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:YES];
}

#pragma mark - Events handlers

- (IBAction)closeTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
