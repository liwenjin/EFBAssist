//
//  AEAppListViewController.m
//  efbapp
//
//  Created by 徐 洋 on 14-3-17.
//  Copyright (c) 2014年 ADCC. All rights reserved.
//

#import <PixateFreeStyle.h>

#import "AEAppListViewController.h"

#import "AEAppCollectionViewCell.h"
#import "EFBViewControllerContainer.h"

#define kViewControllerList         @"EFBViewControllerList"
#define kViewControllerTitle        @"EFBViewControllerTitle"
#define kViewControllerIconPrefix   @"EFBTabIconPrefix"
#define kViewControllerClass        @"EFBViewControllerClass"
#define kHideMainTabbar             @"EFBHideTabbar"
#define kHideMainTabbarButtons      @"EFBHideTabbarButtons"
#define kHideVersion                @"EFBHideVersion"
#define kHideLogo                   @"EFBHideLogo"

static NSString *kCellIdentifier = @"AppCollectionCell";
static NSString *kHeaderIdentifier = @"AppCollectionHeader";

static NSString * const kStyleClass = @"styleClass";
static NSString * const kTitleText = @"TitleText";
static NSString * const kSchema = @"Schema";
static NSString * const kType = @"type";
static NSString * const kTypeApp = @"app";
static NSString * const kTypeModule = @"module";

#pragma mark - SectionHeaderView

@interface SectionHeaderView : UICollectionReusableView

@end

@implementation SectionHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.styleClass = @"section-header";
    }
    
    return self;
}

@end

#pragma mark - AEAppListViewController
@interface AEAppListViewController ()

@property (retain, nonatomic) NSArray * topList;
@property (retain, nonatomic) NSArray * taskList;
@property (retain, nonatomic) NSArray * moduleList;

@end

@implementation AEAppListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadConfiguration
{
    //
    NSString * plist = [[NSBundle mainBundle] pathForResource:APP_CONFIG_FILE ofType:@"plist"];
    NSDictionary * customConfig = [NSDictionary dictionaryWithContentsOfFile:plist];
    NSAssert(customConfig, @"[FATAL] Load custom.plist failed.");
    
    _taskList = [[customConfig objectForKey:kAppListRoot] copy];
    
    //
    NSString * plistPath = [[NSBundle mainBundle] pathForResource:@"app" ofType:@"plist"];
    NSDictionary * appPlist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    _moduleList = [[appPlist objectForKey:kViewControllerList] copy];
    
    //
    NSMutableArray * top = [[NSMutableArray alloc] initWithCapacity:1];
    if ([_moduleList count] > 1) {
        NSMutableArray * mods = [[NSMutableArray alloc] initWithCapacity:5];
        for (NSDictionary * mod in self.moduleList) {
            NSString * prefix = [mod objectForKey:kViewControllerIconPrefix];
            NSString * title = [mod objectForKey:kViewControllerTitle];
            [mods addObject:@{kStyleClass:prefix, kTitleText:title, kType:kTypeModule}];
        }
        [top addObject:mods];
    }
    
    NSMutableArray * apps = [[NSMutableArray alloc] initWithCapacity:5];
    for (NSDictionary * app in self.taskList) {
        NSString * icon = [app objectForKey:kAppIcon];
        NSString * title = [app objectForKey:kAppTitle];
        NSString * schema = [app objectForKey:kAppSchema];
        [apps addObject:@{kStyleClass:icon, kTitleText:title, kSchema:schema, kType:kTypeApp}];
    }
    [top addObject:apps];
    self.topList = top;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadConfiguration];
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [(UICollectionView *)self.view registerClass:[AEAppCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
    
    [(UICollectionView *)self.view registerClass:[SectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark 

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.topList count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray * list = [self.topList objectAtIndex:section];
    return [list count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AEAppCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    NSArray * list = [self.topList objectAtIndex:indexPath.section];
    NSDictionary* propDict = [list objectAtIndex:indexPath.row];
    
    cell.styleClass = [propDict objectForKey:kStyleClass];
    cell.titleLabel.text = [propDict objectForKey:kTitleText];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeaderIdentifier forIndexPath:indexPath];
    
    
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray * list = [self.topList objectAtIndex:indexPath.section];
    NSDictionary *propDict = [list objectAtIndex:indexPath.row];
    NSString * type = [propDict objectForKey:kType];
    
    if ([kTypeModule isEqualToString:type]) {
        // internal module
        if (self.delegate) {
            [self.delegate appList:self didSelectedAtIndex:indexPath.row];
        }
    }
    else {
        NSString *schema = [propDict objectForKey:kSchema];
        NSURL *url = [NSURL URLWithString:[schema stringByAppendingString:@"://"]];
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
