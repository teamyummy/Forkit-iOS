//
//  SearchViewController.m
//  Forkit
//
//  Created by david on 2016. 11. 28..
//  Copyright © 2016년 david. All rights reserved.
//

#import "SearchViewController.h"
#import "RestaurantListCell.h"
#import "RestaurantDetailViewController.h"

//cell reuse identifier
static NSString * const ReuseIdentifierRestaurantList = @"RestaurantListCell";

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate>

@property UITextField *searchBarTextField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property NSString *currentTypedCharacter;

//set search restaurant data list
@property NSArray *searchDataList;

@property (weak, nonatomic) IBOutlet UITableView *searchResultTableView;

@end

@implementation SearchViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createTextField];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchBarTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - View Creation

- (void)createTextField
{
    self.searchBarTextField = [[UITextField alloc]initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  self.navigationController.navigationBar.frame.size.width,
                                                                  21.0)];
    self.searchBarTextField.textAlignment = NSTextAlignmentCenter;
    self.searchBarTextField.textColor = [UIColor whiteColor];
    self.searchBarTextField.tintColor = [UIColor whiteColor];
    self.searchBarTextField.delegate = self;
    self.searchBarTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // 첫 글자 소문자로 변경
    self.navigationItem.titleView = _searchBarTextField;
}

#pragma mark - click Button

- (IBAction)clickPopButton:(UIBarButtonItem *)sender
{
    [self.searchBarTextField endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clcikSearchButton:(UIBarButtonItem *)sender
{
    NSString *searchValue = self.searchBarTextField.text;
    
    if (searchValue.length == 0 ||
        [searchValue containsString:@" "] ||
        [searchValue containsString:@"&"] ||
        [searchValue containsString:@"?"] ||
        [searchValue containsString:@"="])
    {
        _searchDataList = nil;
        [self.searchResultTableView reloadData];
        self.resultLabel.text = @"다시 입력해 주세요";
    } else
    {
        [self.searchBarTextField endEditing:YES];
        self.resultLabel.text = @" ";
        //request
        SearchViewController * __weak weakSelf = self;
        
        [FIRequestObject requestRestaurantList:@{ParamNameSerachKey:searchValue}
                     didReceiveUpdateDataBlock:^{
                         
                         [weakSelf didReceiveListUpdated];
                         
                     }];
    }
}

//completion request
- (void)didReceiveListUpdated
{
    if ([[[FIDataManager sharedManager] shopDatas] count] == 0)
    {
         self.resultLabel.text = @"검색결과가 없습니다.";
        [self.searchBarTextField becomeFirstResponder];
    }else
    {
        self.resultLabel.text = @" ";
    }
    self.searchDataList = [[FIDataManager sharedManager] shopDatas];
    [self.searchResultTableView reloadData];
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self clcikSearchButton:nil];
    return YES;
}

/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (([self.currentTypedCharacter isEqualToString:@" "] &&
         [string isEqualToString:@" "]) ||
        ([self.currentTypedCharacter isEqualToString:@""] &&
         [string isEqualToString:@""]))
    {
        self.searchBar.text = @"";
    }
    self.currentTypedCharacter = string;
    return YES;
}
 */

#pragma mark - Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestaurantListCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierRestaurantList forIndexPath:indexPath];
    
    NSDictionary *restaurantDataTempDict;
    restaurantDataTempDict = [self.searchDataList objectAtIndex:indexPath.row];
    
    if (self.searchDataList != nil)
    {
        
        cell.restaurantTitleLabel.text = [restaurantDataTempDict objectForKey:JSONRestaurnatNameKey];
        
        cell.restaurantAddressLabel.text = [restaurantDataTempDict objectForKey:JSONRestaurnatAddressKey];
        
        cell.restaurantScoreLabel.text = [restaurantDataTempDict objectForKey:JSONRestaurnatAvgReviewScoreKey];
        
        cell.restaurantReviewCountLabel.text = [restaurantDataTempDict objectForKey:JSONRestaurnatTotalReviewCountKey];
        
        cell.restaurantLikeCountLabel.text = [restaurantDataTempDict objectForKey:JSONRestaurnatTotalLikeKey];
        
        NSArray *images = [restaurantDataTempDict objectForKey:JSONCommonImagesKey];
        
        if (images != nil && [images count] != 0)
        {
            [cell.restaurantImageView sd_setImageWithURL:[[images objectAtIndex:0] objectForKey:JSONCommonSmallImageURLKey]];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[RestaurantDetailViewController class]])
    {
        RestaurantListCell *cell = sender;
        NSIndexPath *cellIndex = [_searchResultTableView indexPathForCell:cell];
        NSDictionary *restaurantDatas = [_searchDataList objectAtIndex:cellIndex.row];
        
        RestaurantDetailViewController *restaurantDetailVC = segue.destinationViewController;
        restaurantDetailVC.restaurantDatas = restaurantDatas;
    }
}


@end
