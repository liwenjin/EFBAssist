//
//  EFBCalculatorUnitCellView.h
//  hnaefb
//
//  Created by EFB on 13-9-9.
//  Copyright (c) 2013年 徐 洋. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EFBDataTextFieldImage) {
    kTextFieldTagForNormal = 101,
    kTextFieldTagForInput,
    kTextFieldTagForResult
};
@interface EFBCalculatorUnitCellView : UIView

@property (retain, nonatomic) IBOutlet UIImageView *textFieldBgImageView;
@property (retain, nonatomic) IBOutlet UITextField *dataTextField;
@property (retain, nonatomic) IBOutlet UILabel *parameterNameLabel;

//-(void)setDataTextFieldImage:(EFBDataTextFieldImage)aImage;
@end
