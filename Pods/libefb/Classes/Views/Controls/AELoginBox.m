//
//  AELoginBox.m
//  efbapp
//
//  Created by 徐 洋 on 14-3-18.
//  Copyright (c) 2014年 ADCC. All rights reserved.
//

#import "AELoginBox.h"

#import "AEIdentityManager.h"

@interface AELoginBox () <UITextFieldDelegate>

@end

@implementation AELoginBox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // #E6E9ED
        self.backgroundColor = [UIColor colorWithRed:0xe6/255.0 green:0xe9/255.0 blue:0xed/255.0 alpha:1.0f];
        
        _userName = [[UITextField alloc] initWithFrame:CGRectMake(200, 15, 300, 30)];
        _userName.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _userName.autocorrectionType = UITextAutocorrectionTypeNo;
        _userName.placeholder = @"请输入用户名";
        _userName.keyboardType = UIReturnKeyNext;
        _userName.borderStyle = UITextBorderStyleRoundedRect;
        _userName.tag = 1;
        _userName.delegate = self;
        
        _password = [[UITextField alloc] initWithFrame:CGRectMake(200, 55, 300, 30)];
        _password.placeholder = @"请输入密码";
        _password.keyboardType = UIReturnKeyGo;
        _password.secureTextEntry = YES;
        _password.borderStyle = UITextBorderStyleRoundedRect;
        _password.tag = 99;
        _password.delegate = self;

        [self addSubview:_userName];
        [self addSubview:_password];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (NSString *)encryptPassword:(NSString *)password
{
    return password;
}

- (void)doLogin
{
    NSString * userName = [self.userName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    userName = [userName lowercaseString];
    
    [[AEIdentityManager defaultManager] loginWithUser:userName password:[self encryptPassword:self.password.text] completion:self.completion];
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField == self.password) {
        [textField resignFirstResponder];

        [self doLogin];
    }
    else {
        [self.password becomeFirstResponder];
    }
    
    return true;
}

@end
