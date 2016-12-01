//
//  RestaurantDetailViewController.m
//  Forkit
//
//  Created by david on 2016. 11. 28..
//  Copyright © 2016년 david. All rights reserved.
//

#import "RestaurantDetailViewController.h"
#import "RestaurantDetailCell.h"

static NSString * const reuseIdentifierTitleCell = @"RestaurantDetailTitleCell";
static NSString * const reuseIdentifierInfoCell = @"RestaurantDetailInfoCell";
static NSString * const reuseIdentifierReviewCell = @"RestaurantDetailReviewCell";

@interface RestaurantDetailViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *customNavigationBar;
@property (weak, nonatomic) IBOutlet UITableView *RestaurantDetailTableView;
@property (weak, nonatomic) IBOutlet UILabel *customNavigationTitle;
@property NSArray *testArr;

@end

@implementation RestaurantDetailViewController

- (IBAction)testClickReviewAlert:(UIButton *)sender
{

//    UIStoryboard *restaurantStoryboard = [UIStoryboard storyboardWithName:@"RestaurantDetail" bundle:nil];
    
    
//    [self presentViewController:testAlertVC animated:NO completion:^{
//        testAlertVC.view.alpha = 0;
//        [UIView animateWithDuration:0.5
//                         animations:^{
//                             testAlertVC.view.alpha = 1;
//                         }];
//    }];
 /*
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"1"
                                                                   message:@"1"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIView *reviewView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
    reviewView.backgroundColor = [UIColor blueColor];
    
//    alert.view = reviewView;
    [self presentViewController:alert animated:YES completion:nil];
   */
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
//    [self.navigationController setNavigationBarHidden:YES];
   
    [self preferredStatusBarStyle];
//    self.edgesForExtendedLayout = UIRectEdgeTop;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.testArr = @[@"dummyFoodImage", @"dummyFoodImage", @"dummyFoodImage", @"dummyFoodImage", @"dummyFoodImage"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickPopButton:(UIButton *)sender
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Table View Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

#pragma mark - Table View Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    NSString *reuseIdentifier;
    switch (indexPath.section)
    {
        case 0:
            reuseIdentifier = reuseIdentifierTitleCell;
            break;
        
        case 1:
            reuseIdentifier = reuseIdentifierInfoCell;
            break;
            
        case 2:
            reuseIdentifier = reuseIdentifierReviewCell;
            break;
     
    }
    RestaurantDetailTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if ([reuseIdentifier isEqualToString:reuseIdentifierInfoCell])
    {
        cell.
    }
     */
    
    if (indexPath.section == 0)
    {
        RestaurantDetailTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTitleCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        [cell.clickPresentReviewButton addTarget:self action:@selector(presentReviewController:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else if (indexPath.section == 1)
    {
        RestaurantDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierInfoCell forIndexPath:indexPath];
        
        [self createScrollViewWithCell:cell];
        
        return cell;
    } else if (indexPath.section == 2)
    {
        RestaurantDetailReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReviewCell forIndexPath:indexPath];
        return cell;
    }
    return nil;
}

- (void)presentReviewController:(UIButton *)sender
{
    UIViewController *testAlertVC = [self.storyboard instantiateViewControllerWithIdentifier:@"customAlertController"];
    
    [self addChildViewController:testAlertVC];
    [self.view addSubview:testAlertVC.view];
    [testAlertVC.view setAlpha:0.0];
    
    [UIView animateWithDuration:3 animations:^{
        [testAlertVC.view setAlpha:0.9];
    }];
    
    
}

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


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }

    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
