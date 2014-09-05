//
//  EFBContextViewCell.m
//  muefb
//
//  Created by Jiang Shangxiu on 11/19/12.
//
//

#import "EFBDictionaryViewCell.h"
#import <UIApplication+EFB.h>

@implementation EFBDictionaryViewCell
@synthesize keyLabel;
@synthesize detailLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(void)nightmodeChanged
{
//    NSString* nightmode = [[EFBContext instance] objectForKey:CTX_NIGHTMODE];
    BOOL nightmode = [[UIApplication sharedApplication] nightlyMode];

    if (nightmode) {
        [keyLabel setTextColor:[UIColor blackColor]];
        [detailLabel setTextColor:[UIColor blackColor]];
    }
    else
    {
        [keyLabel setTextColor:[UIColor whiteColor]];
        [detailLabel setTextColor:[UIColor whiteColor]];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [keyLabel release];
    [detailLabel release];
    [super dealloc];
}
@end
