//
//  EFBDictionaryViewController.m
//  muefb
//
//  Created by EFB on 12-8-14.
//
//

#import "EFBDictionaryViewController.h"
#import "EFBDictionaryViewCell.h"
#import <UIApplication+EFB.h>
#import <EFBTitleBar.h>

@interface EFBDictionaryViewController ()

@end

@implementation EFBDictionaryViewController

@synthesize dicSearchBar = dicSearchBar_;
@synthesize dicTableView = dicTableView_;
@synthesize selectArray = selectArray_;
@synthesize datasouceDic = datasouceDic_;
@synthesize keyArray = keyArray_;

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

    [self contentViewDidLoad];
    
    self.dicSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 66.0f, self.view.bounds.size.width, 44)];
    self.dicSearchBar.delegate = self;
    self.dicSearchBar.showsCancelButton = YES;
    self.dicSearchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.dicSearchBar.barStyle = UIBarStyleBlack;
    self.dicSearchBar.placeholder = @"搜索";
    [self.view addSubview:self.dicSearchBar];
    
    UIView *searchBarView = [[self.dicSearchBar subviews] lastObject];
    for (UITextField *searchField in searchBarView.subviews) {
        if ([searchField isKindOfClass: NSClassFromString ( @"UISearchBarTextField" )]) {
            searchField.backgroundColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1.0f];;
            break ;
        }
    }
    for (UIView *view in searchBarView.subviews) {
        if ([view isKindOfClass: NSClassFromString ( @"UISearchBarBackground" )]) {
            [view removeFromSuperview];
            self.dicSearchBar.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0f];;
            break ;
        }
    }

    self.dicTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 110.0f, self.view.bounds.size.width, self.view.bounds.size.height -110) style:UITableViewStylePlain];
    self.dicTableView.delegate = self;
    self.dicTableView.dataSource = self;
    self.dicTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.dicTableView];
    dicTableView_.rowHeight=50.0;
    dicTableView_.backgroundColor=[UIColor clearColor];
    dicSearchBar_.autocapitalizationType=UITextAutocapitalizationTypeAllCharacters;

    [self loadData];
}

- (void)contentViewDidLoad
{
//    [super contentViewDidLoad];
	// Do any additional setup after loading the view.
//    self.titleBar.titleLabel.text = self.title;
    EFBTitleBar *titleBar = [[[EFBTitleBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 66.0f)] autorelease];
    titleBar.titleLabel.text = self.title;
    titleBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self .view addSubview:titleBar];
    [self didFinishLoadView];
    
    BOOL nightMode = [[UIApplication sharedApplication] nightlyMode];
    self.view.backgroundColor = nightMode ? [UIColor blackColor] : [UIColor whiteColor];
}

-(void) loadData
{
    NSMutableArray *dataSource = [[NSMutableArray alloc] init];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"abbr" ofType:@"txt"];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:enc error:nil];
    NSArray *array = [content componentsSeparatedByString:@"\n"];
    for (int i = 0; i < [array count]; i++) {
        NSString *tempStr = [array objectAtIndex:i];
        NSArray *tempArray = [tempStr componentsSeparatedByString:@"\t"];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[tempArray objectAtIndex:0],@"english",[tempArray objectAtIndex:1],@"chinaese", nil];
        [dataSource addObject:dic];
        [dic release];
    }
    [dataSource removeLastObject];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"english" ascending:NO comparator:^(id obj1, id obj2) {
        if ([obj1 compare: obj2 ] == NSOrderedAscending) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1  compare: obj2 ] == NSOrderedDescending) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    [dataSource sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSMutableDictionary *dicc = [[NSMutableDictionary alloc] init];
    for (int i = 0; i<[dataSource count]; i++) {
        NSString *str = [[[dataSource objectAtIndex:i] objectForKey:@"english"] substringToIndex:1];
        NSMutableArray *array = [dicc objectForKey:str];
        if (array == nil) {
            array = [[[NSMutableArray alloc] init] autorelease];
        }
        [array addObject:[dataSource objectAtIndex:i]];
        [dicc setObject:array forKey:str];
    }
    datasouceDic_ = [[NSMutableDictionary alloc] initWithDictionary:dicc];
    searchDic = [[NSMutableDictionary alloc] initWithDictionary:dicc];
    
    keyArray_ = [[NSArray alloc] initWithArray:[dicc allKeys]];
    
    self.keyArray = [keyArray_ sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 compare: obj2 ] == NSOrderedAscending) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        if ([obj1  compare: obj2 ] == NSOrderedDescending) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
        
    }];
    selectArray_ = [[NSMutableArray alloc] initWithArray:self.keyArray];
    [dicc release];
    [dataSource release];
    [self.dicTableView reloadData];
}

- (void)efbNightModeChanged:(BOOL)enabled
{
    [dicTableView_ reloadData];
    self.view.backgroundColor = enabled ? [UIColor blackColor] : [UIColor whiteColor];
}

#pragma mark - UITableView Delegate Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.keyArray count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray *array =[self.datasouceDic objectForKey:[self.keyArray objectAtIndex:section]];
    return [array count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
	static NSString * reuseIdentifier = @"contextCell";
    
	EFBDictionaryViewCell * cell = (EFBDictionaryViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EFBDictionaryViewCell" owner:self options:nil] objectAtIndex:0];
        cell.backgroundColor=[UIColor clearColor];
    }
    NSArray *array =[self.datasouceDic objectForKey:[self.keyArray objectAtIndex:section]];

    cell.selectedBackgroundView =[[[UIView alloc] initWithFrame:cell.frame] autorelease];
    cell.selectedBackgroundView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell50.png"]];
    
    cell.keyLabel.backgroundColor = [UIColor clearColor];
    cell.keyLabel.text = [[array objectAtIndex:row] objectForKey:@"english"];
    cell.detailLabel.text = [[array objectAtIndex:row] objectForKey:@"chinaese"];

    BOOL nightmode = [[UIApplication sharedApplication] nightlyMode];
    if (nightmode) {
        [cell.keyLabel setTextColor:[UIColor whiteColor]];
        [cell.detailLabel setTextColor:[UIColor whiteColor]];
    }
    else
    {
        [cell.keyLabel setTextColor:[UIColor blackColor]];
        [cell.detailLabel setTextColor:[UIColor blackColor]];
    }
	return cell;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.keyArray count] == 0)
        return nil;
    
    NSString *key = [self.keyArray objectAtIndex:section];
    if (key == UITableViewIndexSearch)
        return nil;
    
    return key;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.keyArray;
}

#pragma mark - UISearchBar Delegate Method
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    NSMutableArray *searchKeyArray = [[[NSMutableArray alloc] init] autorelease];
    NSMutableDictionary *tmpdataDic = [[[NSMutableDictionary alloc] initWithDictionary:searchDic] autorelease];
    NSMutableDictionary *tempSourceDic = [[[NSMutableDictionary alloc] init] autorelease];
    if (searchText.length<=0) {
        [searchKeyArray removeAllObjects];
        self.keyArray = self.selectArray;
        self.datasouceDic=searchDic;
        [self.dicTableView reloadData];
        return;
    }else {
        for (int i = 0; i < [self.selectArray count];i++) {
            NSMutableArray *array =  [tmpdataDic objectForKey:[self.selectArray objectAtIndex:i]];
            for (int j = 0; j<[array count]; j++) {
                NSString *str = [[array objectAtIndex:j] valueForKey:@"english"];
                if ([str length]>=[searchText length]) {
                    
                    NSRange r = [[str substringToIndex:[searchText length]] rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    if (r.location != NSNotFound) {
                        NSMutableArray *tempArray = [tempSourceDic objectForKey:[self.selectArray objectAtIndex:i]];
                        if (tempArray==nil) {
                            tempArray = [[[NSMutableArray alloc] init] autorelease];
                        }
                        [tempArray addObject:[array objectAtIndex:j]];
                        [tempSourceDic setObject:tempArray forKey:[self.selectArray objectAtIndex:i]];
                    }
                }
                               
            }
            
        }
    }
    NSArray *tmpkeyArray = [[NSArray alloc] initWithArray:[tempSourceDic allKeys]];
    
    NSArray *tempArray = [tmpkeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 compare: obj2 ] == NSOrderedAscending) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        if ([obj1  compare: obj2 ] == NSOrderedDescending) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
        
    }];
    for (int k = 0; k <[tempArray count];k++) {
        NSMutableArray *array1 = [tmpdataDic objectForKey:[tempArray objectAtIndex:k]];
        if ([array1 count]>0) {
            [searchKeyArray addObject:[tempArray objectAtIndex:k]];
        }
    }
    self.keyArray = searchKeyArray;
    self.datasouceDic=tempSourceDic;
    [self.dicTableView reloadData];
    
    [tmpkeyArray release];

}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{

    [self.dicSearchBar resignFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.dicSearchBar = nil;
    self.dicTableView = nil;
    self.selectArray = nil;
    self.datasouceDic = nil;
    self.keyArray = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)dealloc
{
    [dicSearchBar_ release];
    [dicTableView_ release];
    [selectArray_ release];
    [datasouceDic_ release];
    [keyArray_ release];
    [searchDic release];
    [super dealloc];
}

@end
