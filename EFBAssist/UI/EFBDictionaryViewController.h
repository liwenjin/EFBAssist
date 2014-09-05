//
//  EFBDictionaryViewController.h
//  muefb
//
//  Created by EFB on 12-8-14.
//
//

#import <UIKit/UIKit.h>
#import <EFBBaseViewController.h>

@interface EFBDictionaryViewController : EFBBaseViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{
    
    UISearchBar *dicSearchBar_;
    UITableView *dicTableView_;
    NSMutableArray *selectArray_;
    NSMutableDictionary *datasouceDic_;
    NSArray *keyArray_;
    NSMutableDictionary *searchDic;
    
}

@property (nonatomic,retain) UISearchBar *dicSearchBar;
@property (nonatomic,retain) UITableView *dicTableView;
@property (nonatomic,retain) NSMutableArray *selectArray;
@property (nonatomic,retain) NSMutableDictionary *datasouceDic;
@property (nonatomic,retain) NSArray *keyArray;


@end
