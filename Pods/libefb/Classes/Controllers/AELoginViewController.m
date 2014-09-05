//
//  AELoginViewController.m
//  efbapp
//
//  Created by 徐 洋 on 14-3-17.
//  Copyright (c) 2014年 ADCC. All rights reserved.
//

#import <PixateFreeStyle.h>

#import "AELoginViewController.h"
#import "AELoginBox.h"
#import "AEUserAvatar.h"
#import "AEImageLeadingButton.h"
#import "AELanguagePickerViewController.h"
#import "AEIdentityManager.h"

@interface AELoginViewController ()

@property (retain, nonatomic) NSMutableArray * arrayUsers;
@property (retain, nonatomic) NSMutableArray * arrayAvatars;
@property (retain, nonatomic) UIScrollView * avatarsPanel;
@property (weak, nonatomic) IBOutlet AEImageLeadingButton *languageButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (retain, nonatomic) UIImageView * upperImageView;
@property (retain, nonatomic) UIImageView * lowerImageView;
@property (retain, nonatomic) UIView * bgView;
@property (retain, nonatomic) AELoginBox * loginBox;

@end

@implementation AELoginViewController

#pragma mark - Object initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _arrayAvatars = [NSMutableArray array];
        
        _arrayUsers = [NSMutableArray array];
        [_arrayUsers addObject:@{kUserName: @"test1"}];
        [_arrayUsers addObject:@{kUserName: @"test2"}];
        [_arrayUsers addObject:@{kUserName: @"test3"}];
        [_arrayUsers addObject:@{kUserName: @"test4"}];
        [_arrayUsers addObject:@{kUserName: @"test5"}];
        [_arrayUsers addObject:@{kUserName: @"test6"}];
//        [_arrayUsers addObject:@{kUserName: @"test7"}];
//        [_arrayUsers addObject:@{kUserName: @"test8"}];
//        [_arrayUsers addObject:@{kUserName: @"test9"}];
//        [_arrayUsers addObject:@{kUserName: @"test10"}];
//        [_arrayUsers addObject:@{kUserName: @"test11"}];
//        [_arrayUsers addObject:@{kUserName: @"test12"}];
//        [_arrayUsers addObject:@{kUserName: @"test13"}];
//        [_arrayUsers addObject:@{kUserName: @"test14"}];
//        [_arrayUsers addObject:@{kUserName: @"test15"}];
//        [_arrayUsers addObject:@{kUserName: @"test16"}];
//        [_arrayUsers addObject:@{kUserName: @"test17"}];
//        [_arrayUsers addObject:@{kUserName: @"test18"}];
//        [_arrayUsers addObject:@{kUserName: @"test19"}];
//        [_arrayUsers addObject:@{kUserName: @"test20"}];
//        [_arrayUsers addObject:@{kUserName: @"test21"}];
//        [_arrayUsers addObject:@{kUserName: @"test22"}];
//        [_arrayUsers addObject:@{kUserName: @"test23"}];
//        [_arrayUsers addObject:@{kUserName: @"test24"}];
//        [_arrayUsers addObject:@{kUserName: @"test25"}];
//        [_arrayUsers addObject:@{kUserName: @"test26"}];
//        [_arrayUsers addObject:@{kUserName: @"test27"}];
//        [_arrayUsers addObject:@{kUserName: @"test28"}];
//        [_arrayUsers addObject:@{kUserName: @"test29"}];
//        [_arrayUsers addObject:@{kUserName: @"test30"}];
//        [_arrayUsers addObject:@{kUserName: @"test31"}];
//        [_arrayUsers addObject:@{kUserName: @"test32"}];
//        [_arrayUsers addObject:@{kUserName: @"test33"}];
//        [_arrayUsers addObject:@{kUserName: @"test34"}];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.styleClass = @"login-bg";
    
    const float originX = 100.0f;
    const float originY = 400.0f;
    self.avatarsPanel = [[UIScrollView alloc] initWithFrame:CGRectMake(originX, originY, CGRectGetWidth(self.view.bounds)-2*originX, CGRectGetHeight(self.view.bounds)-600.0f)];
    self.avatarsPanel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:self.avatarsPanel];
    
    
    for (int i=0; i<[self.arrayUsers count]; i++) {
        NSDictionary * dictUser = [self.arrayUsers objectAtIndex:i];
        NSString * name = [dictUser objectForKey:kUserName];
        
        AEUserAvatar * avatar = [[AEUserAvatar alloc] initWithAvatarStyle:AEAvatarIconStyle];
        avatar.nameLabel.text = name;
        avatar.tag = i;
        [avatar addTarget:self action:@selector(onAvatarTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.avatarsPanel addSubview:avatar];
        [self.arrayAvatars addObject:avatar];
    }
    
    //
    
    NSDictionary * currentUser = [[AEIdentityManager defaultManager] currentUser];
    if (currentUser) {
        AEUserAvatar * avatar = [[AEUserAvatar alloc] initWithAvatarStyle:AEAvatarDetailStyle];
        avatar.center = CGPointMake(self.view.center.x, 250);
        [self.view addSubview:avatar];
        avatar.nameLabel.text = [currentUser objectForKey:kUserName];
        avatar.titleLabel.text = [currentUser objectForKey:kUserTitle];
        [self.view addSubview:avatar];
        
        UIButton * logoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        logoutButton.frame = CGRectMake(500, 250, 60, 30);
        [logoutButton setTitle:@"注销" forState:UIControlStateNormal];
        [logoutButton addTarget:self action:@selector(logoutTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:logoutButton];
        
    }
    else {
        AEUserAvatar * avatar = [[AEUserAvatar alloc] initWithAvatarStyle:AEAvatarIconStyle];
        avatar.center = CGPointMake(self.view.center.x, 250);
        [self.view addSubview:avatar];
        avatar.tag = -1;
        avatar.nameLabel.text = @"新用户";
        [self.view addSubview:avatar];
        
        [avatar addTarget:self action:@selector(onNewUserTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.closeButton.hidden = !self.dismissable;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [self layoutAvatars];
}

- (void)layoutAvatars
{
    const float avatarWidth = 100.0f;
    const float avatarHeight = 100.0f;
    
    CGFloat TOP_PADDING = 30.0f;
    CGFloat LEFT_PADDING = 30.0f;
    CGFloat RIGHT_PADDING = 30.0f;
    CGFloat BOTTOM_PADDING = 30.0f;
    
    const CGFloat BOTTOM_MARGIN = 30.0f;
    const CGFloat RIGHT_MARGIN = 30.0f;
    
    CGRect bounds = self.avatarsPanel.bounds;
    CGRect foo;
    
    CGRectDivide(bounds, &foo, &bounds, TOP_PADDING, CGRectMinYEdge);
    CGRectDivide(bounds, &foo, &bounds, LEFT_PADDING, CGRectMinXEdge);
    CGRectDivide(bounds, &foo, &bounds, BOTTOM_PADDING, CGRectMaxYEdge);
    CGRectDivide(bounds, &foo, &bounds, RIGHT_PADDING, CGRectMaxXEdge);

    NSInteger colsPerRow = (CGRectGetWidth(bounds) + RIGHT_MARGIN) / (avatarWidth + RIGHT_MARGIN);

    CGFloat padding = (CGRectGetWidth(bounds) - (avatarWidth + RIGHT_MARGIN) * MIN([self.arrayAvatars count], colsPerRow) + RIGHT_MARGIN)/2;
    bounds = CGRectInset(bounds, padding, 0);
    
    CGRect contentRect = CGRectZero;
    for (int i=0; i<[self.arrayAvatars count]; i++) {
        UIView * avatar = [self.arrayAvatars objectAtIndex:i];
        
        NSInteger row = i / colsPerRow;
        NSInteger col = i % colsPerRow;
        
        float x = bounds.origin.x + (avatarWidth + RIGHT_MARGIN) * col;
        float y = bounds.origin.y + (avatarHeight + BOTTOM_MARGIN) * row;
        
        avatar.frame = CGRectMake(x, y, avatarWidth, avatarHeight);
        contentRect = CGRectUnion(contentRect, avatar.frame);
    }
    
    contentRect.size.height += BOTTOM_PADDING;
    contentRect.size.width += RIGHT_PADDING;
    
    self.avatarsPanel.contentSize =  contentRect.size;
}

#pragma mark - Control's events handlers

- (IBAction)logoutTapped:(id)sender
{
    NSLog(@"logout");
    [[AEIdentityManager defaultManager] logoutWithCompletion:^(NSError *error) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (IBAction)onNewUserTapped:(id)sender
{
    NSLog(@"tapped on New user.");
    [self showLoginBoxForAvatar:sender];
}

- (IBAction)onAvatarTapped:(id)sender
{
    AEUserAvatar * avatar = sender;
    NSInteger index = avatar.tag;
    NSLog(@"tapped on user #%lu", (long)index);

    if (index >= [self.arrayUsers count]) {
        NSLog(@"Out of range");
    }
    
    NSDictionary * dictUser = [self.arrayUsers objectAtIndex:index];
    
    if (dictUser == nil) {
        return;
    }
    
    // show login box
    [self showLoginBoxForAvatar:avatar];
}


- (IBAction)cloaseTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)languageTapped:(id)sender {
    NSLog(@"tapped on language.");
    
    AELanguagePickerViewController * picker = [[AELanguagePickerViewController alloc] init];
    picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)showLoginBoxForAvatar:(AEUserAvatar *)avatar
{
    // captureScreen
    
    UIGraphicsBeginImageContext(self.view.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // split into upper & lower images
    
    CGPoint origin = [self.view convertPoint:avatar.bounds.origin fromView:avatar];
    CGRect rectUpper, rectLower;
    CGRectDivide(self.view.bounds, &rectUpper, &rectLower, origin.y+CGRectGetHeight(avatar.bounds), CGRectMinYEdge);
    
    CGImageRef cgImage = CGImageCreateWithImageInRect([theImage CGImage], rectUpper);
    UIImage * upper = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    self.upperImageView = [[UIImageView alloc] initWithImage:upper];
    self.upperImageView.frame = rectUpper;

    cgImage = CGImageCreateWithImageInRect([theImage CGImage], rectLower);
    UIImage * lower = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    self.lowerImageView = [[UIImageView alloc] initWithImage:lower];
    self.lowerImageView.frame = rectLower;
    
    // show upper & lower images

    self.bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView];
    
    self.loginBox = [[AELoginBox alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(rectUpper), CGRectGetWidth(rectUpper), 100)];
    if (avatar.tag != -1) {
        [self.loginBox.password becomeFirstResponder];
        self.loginBox.userName.hidden = YES;
    }
    else {
        [self.loginBox.userName becomeFirstResponder];
        self.loginBox.userName.hidden = NO;
    }
    [self.bgView addSubview:self.loginBox];
    
    // set completion block for login process
    __weak id this = self;
    self.loginBox.completion = ^void(NSDictionary *user, NSError *error) {
        if (error == nil) {
            [this dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"错误" message:[NSString stringWithFormat:@"登录失败，原因：%@",[error localizedDescription]] delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alert show];
        }
    };
    
    [self.bgView addSubview:self.upperImageView];
    [self.bgView addSubview:self.lowerImageView];
    
    AEUserAvatar * dummyAvatar = [[AEUserAvatar alloc] initWithAvatarStyle:AEAvatarIconStyle];
    dummyAvatar.frame = [self.bgView convertRect:avatar.bounds fromView:avatar];
    dummyAvatar.nameLabel.text = avatar.nameLabel.text;
    dummyAvatar.avatarImage.image = avatar.avatarImage.image;
    [self.bgView addSubview:dummyAvatar];
    
    // animate
    
    [UIView animateWithDuration:0.1 animations:^{
        self.upperImageView.alpha = 0.2f;
        self.lowerImageView.alpha = 0.2f;
        self.lowerImageView.frame = CGRectOffset(self.lowerImageView.frame, 0, 100.0f);
    } completion:^(BOOL finished) {
        if (finished) {
            NSLog(@"installing tap gesture recongnizers");
            
            // binding tap gensture
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            
            self.upperImageView.userInteractionEnabled = YES;
            [self.upperImageView addGestureRecognizer:tap];
            
            tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            self.lowerImageView.userInteractionEnabled = YES;
            [self.lowerImageView addGestureRecognizer:tap];
            
            tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [dummyAvatar addGestureRecognizer:tap];
        }
    }];
}

- (void)removeLoginBoxWithCompletion:(void(^)())completion
{
    [UIView animateWithDuration:0.1 animations:^{
        self.upperImageView.alpha = 1.0f;
        self.lowerImageView.alpha = 1.0f;
        self.lowerImageView.frame = CGRectOffset(self.lowerImageView.frame, 0, -100.0f);
    } completion:^(BOOL finished) {
        if (finished) {
            [self.bgView removeFromSuperview];
            if (completion) {
                completion();
            }
        }
    }];
}

- (void)tapped:(UITapGestureRecognizer *)gesture
{    
    [self removeLoginBoxWithCompletion:nil];
}

#pragma mark - AELoginBoxDelegate methods

- (BOOL)shouldDismissLoginBox:(AELoginBox *)loginBox withButton:(NSInteger)index
{
    return YES;
}

@end
