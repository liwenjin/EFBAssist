//
//  EFBContextViewCell.h
//  muefb
//
//  Created by Jiang Shangxiu on 11/19/12.
//
//

#import <UIKit/UIKit.h>

@interface EFBDictionaryViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *keyLabel;
@property (retain, nonatomic) IBOutlet UILabel *detailLabel;

-(void)nightmodeChanged;
@end
