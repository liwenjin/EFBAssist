//
//  EFBNumberPadViewController.m
//  InputControlProj
//
//  Created by 徐 洋 on 13-7-15.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import "EFBNumberPadViewController.h"

#define NUMBER_BUTTON_SIZE      30.0f
#define MAX_ROWS                4
#define MAX_DIGITS              11

#define FUNCTION_IOS_VERSION_BEGIN(ver)  \
NSString *curVersion = [[UIDevice currentDevice] systemVersion]; \
if ([curVersion compare:@#ver] == NSOrderedDescending || [curVersion compare:@#ver] == NSOrderedSame) {
#define FUNCTION_IOS_VERSION_ELSE }else{
#define FUNCTION_IOS_VERSION_END }
@interface EFBNumberPadViewController ()

@property (assign,nonatomic) BOOL isZero;
@end

@implementation EFBNumberPadViewController
@synthesize selectIndex;
@synthesize isCanSelect;

-(id)init
{
    self = [super init];
    if (self)
    {
        _unitSegment = [[UISegmentedControl alloc]initWithItems:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.displayTextField.text = @"0";
    
    _unitSegment.frame = CGRectMake(6, 4, 204, 30);
    _unitSegment.segmentedControlStyle = UISegmentedControlStyleBar;
    _unitSegment.selectedSegmentIndex = selectIndex;
    [_unitSegment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    self.displayUnitButton.enabled = isCanSelect;
    [self.dropView addSubview:_unitSegment];
    
    FUNCTION_IOS_VERSION_BEGIN(7.0)
    self.view.backgroundColor = [UIColor clearColor];
    FUNCTION_IOS_VERSION_ELSE
    self.view.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1.0f];
    FUNCTION_IOS_VERSION_END
    
    [self.doneButton setTitle:NSLocalizedString(@"utilities-calculator-Done", @"完成") forState:UIControlStateNormal];
    [self.clearButton setTitle:NSLocalizedString(@"utilities-calculator-Clear", @"清除") forState:UIControlStateNormal];
    [self.deleteButton setTitle:NSLocalizedString(@"utilities-calculator-Delete", @"删除") forState:UIControlStateNormal];
    [self.nextButton setTitle:NSLocalizedString(@"utilities-calculator-Next", @"下一个") forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_unitSegment release];
    [_descriptionLabel release];
    [_displayTextField release];
    [_displayUnitButton release];
    [_dropView release];
    [_pointButton release];
    [_pOrNButton release];
    [_clearButton release];
    [_deleteButton release];
    [super dealloc];
}

//
// responds to 0~9 and dot "." and sign "-/+"

- (IBAction)onButtonClicked:(id)sender
{
    if (self.isWindPad) {
        [self doClickForWindPad:sender];
    }
    else {
        [self doClickForNormal:sender];
    }
}

- (void)doClickForWindPad:(id)sender
{
    NSString * title = [[(UIButton *)sender titleLabel] text];
    if ([self.displayTextField.text length] >= 5) {
        return;
    }
    
    if ([title isEqualToString:@"0"]) {
        self.isZero = YES;
    }
    
//    if ([title isEqualToString:@"-/+"]) {
//        BOOL isNegative = ![[self.displayTextField.text substringToIndex:1] isEqualToString:@"-"];
//        
//        if (isNegative) {
//            self.displayTextField.text = [NSString stringWithFormat:@"-%@",self.displayTextField.text];
//        }
//        else {
//            self.displayTextField.text = [self.displayTextField.text substringFromIndex:1];
//        }
//    }
//    else if ( [title isEqualToString:@"."] ) {
//        if ( [self.displayTextField.text rangeOfString:@"."].length == 0) {
//            self.displayTextField.text = [self.displayTextField.text stringByAppendingString:title];
//        }
//    }
//    else {
        // 0~9
//        if ([self.displayTextField.text isEqualToString:@"0"]) {
//            self.displayTextField.text = [self.displayTextField.text stringByAppendingString:title];
//           
//        }
//        else if ( [self.displayTextField.text isEqualToString:@"-0"] ) {
//            self.displayTextField.text = [self.displayTextField.text stringByAppendingString:title];
//        }
//        else {
        self.displayTextField.text = [self.displayTextField.text stringByAppendingString:title];
//        }
//    }
}

- (void)doClickForNormal:(id)sender
{
    NSString * title = [[(UIButton *)sender titleLabel] text];
    if ([self.displayTextField.text length] >= MAX_DIGITS) {
        return;
    }

    if ([title isEqualToString:@"-/+"]) {
        BOOL isNegative = ![[self.displayTextField.text substringToIndex:1] isEqualToString:@"-"];
        
        if (isNegative) {
            self.displayTextField.text = [NSString stringWithFormat:@"-%@",self.displayTextField.text];
        }
        else {
            self.displayTextField.text = [self.displayTextField.text substringFromIndex:1];
        }
    }
    else if ( [title isEqualToString:@"."] ) {
        if ( [self.displayTextField.text rangeOfString:@"."].length == 0) {
            self.displayTextField.text = [self.displayTextField.text stringByAppendingString:title];
        }
    }
    else {
        // 0~9
        if ([self.displayTextField.text isEqualToString:@"0"]) {
            self.displayTextField.text = title;
        }
        else if ( [self.displayTextField.text isEqualToString:@"-0"] ) {
            self.displayTextField.text = [NSString stringWithFormat:@"-%@",title];

        }
        else {
            self.displayTextField.text = [self.displayTextField.text stringByAppendingString:title];
        }
    }
}

- (IBAction)onClearClicked:(id)sender {
    if (self.isWindPad) {
        self.displayTextField.text = @"";
    }
    else {
        self.displayTextField.text = @"0";
    }
}

- (IBAction)onBackspaceClicked:(id)sender {
    NSString * displayString = self.displayTextField.text;
    NSString * tmp = @"";
    if ([displayString length]>0) {
        tmp = [displayString substringToIndex:[displayString length]-1];
    }

    if ([tmp length] == 0 || [tmp isEqualToString:@"-"] || [tmp isEqualToString:@"."]) {
        if (self.isWindPad) {
            self.displayTextField.text = @"";
        }
        else {
            self.displayTextField.text = @"0";
        }
    }
    else {
        self.displayTextField.text = tmp;
    }
    
}

- (void)viewDidUnload {
    [self setDropView:nil];
    [self setPointButton:nil];
    [self setPOrNButton:nil];
    [self setClearButton:nil];
    [self setDeleteButton:nil];
    [super viewDidUnload];
}


- (IBAction)dropDown:(id)sender {
//    _unitSegment.selectedSegmentIndex = selectIndex;
//    if ([sender isSelected])
//    {
//        [self hideAccountBox];
//    }
//    else
//    {
//        [self showAccountBox];
//    }
}

- (void)showAccountBox
{
    [_displayUnitButton setSelected:YES];
    //    [_drop_view setHidden:NO];
    
    [UIView animateWithDuration:0.3f animations:^{
        _dropView.frame = CGRectMake(11.0f, 58.0f, 218.0f, 36.0f);
    } completion:^(BOOL finished) {
        //        _descriptionLabel.frame = CGRectMake(3.0f, 87.0f, 235.0f, 45.0f);
    }];
    
}

- (void)hideAccountBox
{
    [_displayUnitButton setSelected:NO];
    
    [UIView animateWithDuration:0.3f animations:^{
        _dropView.frame = CGRectMake(11.0f, 20.0f, 218.0f, 36.0f);
    } completion:^(BOOL finished) {
        //          _descriptionLabel.frame = CGRectMake(3.0f, 64.0f, 235.0f, 58.0f);
    }];
    
    //    [_drop_view performSelector:@selector(setHidden:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.3f];
}

- (void)segmentAction:(UISegmentedControl *)Segment{
    
    NSInteger index = Segment.selectedSegmentIndex;
    NSString *title = [_unitSegment titleForSegmentAtIndex:index];
    [_displayUnitButton setTitle:title forState:UIControlStateNormal];
//    [self hideAccountBox];
}
@end
