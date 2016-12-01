//
//  SearchViewController.m
//  Forkit
//
//  Created by david on 2016. 11. 28..
//  Copyright © 2016년 david. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchingResultTableViewCell.h"

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate>

@property UITextField *searchBar;
@property NSArray *searchingResult;
@property UILabel *resultLabel;
@property NSString *currentTypedCharacter;
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
    self.searchResultTableView.contentInset = UIEdgeInsetsMake(-60, 0, 0, 0);
    
    self.searchBar = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, 21.0)];
    self.searchBar.textAlignment = NSTextAlignmentCenter;
    self.searchBar.textColor = [UIColor whiteColor];
    self.searchBar.tintColor = [UIColor whiteColor];
    self.searchBar.delegate = self;
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone; // 첫 글자 소문자로 변경
    self.navigationItem.titleView = self.searchBar;
    
    self.resultLabel = [[UILabel alloc] init];
    self.resultLabel.text = @"";
    self.resultLabel.frame = CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, 30);
    self.resultLabel.textAlignment = NSTextAlignmentCenter;
    
//                        WithTitle:@"" frame:CGRectMake(0,70,300,30) textColor:[UIColor blackColor]];
//    resu
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
    }
    
    [self.searchResultTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self clcikSearchButton:nil];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"%lu %lu %@ (%@)", range.length, range.location, string, self.currentTypedCharacter);
//    static NSString *currentTypedCharacter = string;
//    if (range.length == 1) { // 입력된 텍스트가 줄어드는 순간 길이를 0으로 만듦
////        self.searchBar.text = @"";
//        textField.text = string;
//    }
    if ([string isEqualToString:@" "] || ([self.currentTypedCharacter isEqualToString:@""] && [string isEqualToString:@""])) {
        self.searchBar.text = @"";
    }
    self.currentTypedCharacter = string;
//    NSLog(@"%lu %lu %@ %@", range.length, range.location, string, self.currentTypedCharacter);
    return YES;
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
