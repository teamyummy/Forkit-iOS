//
//  SearchViewController.m
//  Forkit
//
//  Created by david on 2016. 11. 28..
//  Copyright © 2016년 david. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchingResultTableViewCell.h"

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource>

@property UITextField *searchBar;
@property NSArray *searchingResult;
@property CustomTitleLabel *resultLabel;
//@property UITableView *searchResultTableView;
@property (weak, nonatomic) IBOutlet UITableView *searchResultTableView;

@end

@implementation SearchViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTextField];
}

#pragma mark - View Creation

- (void)createTextField
{
    self.searchBar = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, 21.0)];
    self.searchBar.textAlignment = NSTextAlignmentCenter;
    self.searchBar.textColor = [UIColor whiteColor];
    self.searchBar.tintColor = [UIColor whiteColor];
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone; // 첫 글자 소문자로 변경
    self.navigationItem.titleView = self.searchBar;
    
    self.resultLabel = [[CustomTitleLabel alloc] initWithTitle:@"" frame:CGRectMake(10,70,300,30) textColor:[UIColor blackColor]];
    [self.view addSubview:self.resultLabel];
    
    [self.searchBar becomeFirstResponder];
}

#pragma mark - IBActions

- (IBAction)clickPopButton:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clcikSearchButton:(UIBarButtonItem *)sender {
    NSLog(@"buttonCliced %@", self.searchBar.text);
    self.resultLabel.text = @"";
    self.searchingResult = [[NSArray alloc] initWithArray:[[FIDataManager sharedManager] searchName:self.searchBar.text]];
    
    if (self.searchingResult.count == 0) {
        self.resultLabel.text = @"검색결과가 없습니다.";
        return ;
    }
    
    [self.searchResultTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchingResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchingResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchingResultCell" forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:@"dummyFoodImage"];
    cell.shopNameLabel.text = self.searchingResult[indexPath.row][@"name"];
    cell.shopAddressLabel.text = self.searchingResult[indexPath.row][@"address"];
    cell.scoreImageView.image = [UIImage imageNamed:@"dummyFoodImage"];
    cell.shopInfoDetailLabel.text = [NSString stringWithFormat:@"리뷰 %@ 즐겨찾기 %@", self.searchingResult[indexPath.row][@"review_count"], self.searchingResult[indexPath.row][@"favorite_count"]];
    
    NSLog(@"%@", cell);
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
