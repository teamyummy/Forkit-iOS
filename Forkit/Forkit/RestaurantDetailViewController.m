//
//  RestaurantDetailViewController.m
//  Forkit
//
//  Created by david on 2016. 11. 28..
//  Copyright © 2016년 david. All rights reserved.
//

#import "RestaurantDetailViewController.h"
#import "RestaurantDetailCell.h"
#import "ReviewViewController.h"
#import "CustomUIView.h"

static NSString * const reuseIdentifierTitleCell = @"RestaurantDetailTitleCell";
static NSString * const reuseIdentifierInfoCell = @"RestaurantDetailInfoCell";
static NSString * const reuseIdentifierReviewTitleCell = @"RestaurantDetailReviewTitleCell";
static NSString * const reuseIdentifierReviewCell = @"RestaurantDetailReviewCell";

@interface RestaurantDetailViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *customNavigationBar;
@property (weak, nonatomic) IBOutlet UITableView *RestaurantDetailTableView;
@property (weak, nonatomic) IBOutlet UILabel *customNavigationTitle;
@property NSArray *testArr;
@property NSArray *reivewTestList;

@end

@implementation RestaurantDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.navigationController setNavigationBarHidden:YES];
   
    [self preferredStatusBarStyle];
//    self.edgesForExtendedLayout = UIRectEdgeTop;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.testArr = @[@"dummyFoodImage", @"dummyFoodImage", @"dummyFoodImage", @"dummyFoodImage", @"dummyFoodImage"];
    self.reivewTestList = @[@"review", @"review", @"review", @"review", @"review", @"review"];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickPopButton:(UIButton *)sender
{
    self.navigationController.navigationBarHidden = NO; // 수정해야함
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Table View Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

#pragma mark - Table View Delegate
//row Number
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 3)
    {
        return self.reivewTestList.count;
    }
    return 1;
}
//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        RestaurantDetailTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTitleCell forIndexPath:indexPath];
        return cell;
    } else if (indexPath.section == 1)
    {
        RestaurantDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierInfoCell forIndexPath:indexPath];
        
        [self createScrollViewWithCell:cell];
        
        return cell;
    } else if (indexPath.section == 2)
    {
        RestaurantDetailReviewTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReviewTitleCell forIndexPath:indexPath];
        return cell;
    } else if (indexPath.section == 3)
    {
        RestaurantDetailReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReviewCell forIndexPath:indexPath];
        return cell;
    }
    return nil;
}

//header Height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 3)
    {
        return 0;
    }
    return 8;
}

//header View
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

//row Height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightForRow = 0;
    switch (indexPath.section)
    {
        case 0:
        case 1:
            heightForRow = 330;
            break;
            
        case 2:
            heightForRow = 48;
            break;
            
        case 3:
            heightForRow = 80;
            break;
    }
    return heightForRow;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
}
#pragma mark - Present Review Controller
- (IBAction)presentReviewController:(UIButton *)sender
{
    self.tabBarController.tabBar.hidden = YES;
    ReviewViewController *testAlertVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ReviewVC"];
    
    /*
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:testAlertVC animated:YES completion:nil];
    testAlertVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [UIView animateWithDuration:0.5 animations:^{
        testAlertVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    }];
     */
    [self addChildViewController:testAlertVC];
    [self.view addSubview:testAlertVC.view];
    testAlertVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    [UIView animateWithDuration:0.2 animations:^{
        testAlertVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.70];
    }];
}

#pragma mark - Scroll View Method
- (void)createScrollViewWithCell:(RestaurantDetailInfoCell *)cell
{
    CGFloat scrollViewWidth = cell.reviewPhotoScrollView.frame.size.width;
    CGFloat scrollViewHeight = cell.reviewPhotoScrollView.frame.size.height;
    CGFloat scrollViewLeading = 20;
    CGFloat contentImageViewWidth = scrollViewWidth - (scrollViewLeading * 2);
    cell.reviewPhotoScrollView.contentSize = CGSizeMake((scrollViewWidth /3) * _testArr.count - scrollViewLeading, scrollViewHeight);
    NSInteger i = 0;
    
    for (NSString *imageName in _testArr)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i * contentImageViewWidth/3) + scrollViewLeading, 0, contentImageViewWidth/3, scrollViewHeight)];
        [imageView setImage:[UIImage imageNamed:imageName]];
        [cell.reviewPhotoScrollView addSubview:imageView];
        i += 1;
    }
    cell.reviewPhotoScrollView.showsHorizontalScrollIndicator = NO;
}

#pragma mark - Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger currentOffsetY = scrollView.contentOffset.y;
    NSInteger customNavigationHeight = self.customNavigationBar.frame.size.height;
    if (currentOffsetY >= customNavigationHeight)
    {
        if (![_customNavigationBar.backgroundColor isEqual:[FIUtilities createKeyColor]])
        {
            _customNavigationBar.backgroundColor = [FIUtilities createKeyColor];
            _customNavigationTitle.textColor = [UIColor whiteColor];
        }
    }else
    {
        if (![_customNavigationBar.backgroundColor isEqual:[UIColor clearColor]])
        {
            _customNavigationBar.backgroundColor = [UIColor clearColor];
            _customNavigationTitle.textColor = [UIColor clearColor];
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}


@end
