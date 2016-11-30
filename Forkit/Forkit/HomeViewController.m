//
//  ViewController.m
//  Forkit
//
//  Created by david on 2016. 11. 28..
//  Copyright © 2016년 david. All rights reserved.
//

#import "HomeViewController.h"
#import "RestaurantListCell.h"

static NSString * const reuseIdentifier = @"RestaurantListCell";

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource ,UIScrollViewDelegate>

///dummy Data
@property NSMutableArray *dataList;
@property NSArray *scrollTestImageList;

@property (weak, nonatomic) IBOutlet UITableView *restaurantTableView;

@property UIPageControl *pageControl;

@end

@implementation HomeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    //setting Dummy Data
    self.dataList = [NSMutableArray array];
    NSArray *testArr = @[@"맛집 이름", @"맛집 이름", @"맛집 이름", @"맛집 이름", @"맛집 이름", @"맛집 이름", @"맛집 이름"];
    [_dataList addObjectsFromArray:testArr];
    self.scrollTestImageList = @[@"dummyFoodImage",@"dummyFoodImage",@"dummyFoodImage"];
    
    _restaurantTableView.showsVerticalScrollIndicator = NO;
    
    [self createScrollView];
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dummyLogo"]];
    logoImageView.frame = CGRectMake(0, 0, 0, 20);
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
     
    self.navigationItem.titleView = logoImageView;
}
- (void)createPageControllWithSuperViewHeight:(CGFloat)height superView:(UIView *)superView
{
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.frame = CGRectMake(0, height - 16, 0, 0);
    _pageControl.numberOfPages = _scrollTestImageList.count;
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = [FIUtilities createKeyColor];
    [superView addSubview:_pageControl];
}

- (void)createScrollView
{
    //setting Height, Width
    const CGFloat scrollViewHeight = 180;
    const CGFloat scrollViewWidth = _restaurantTableView.frame.size.width;
    
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, scrollViewHeight)];
    UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollViewWidth, scrollViewHeight)];
    
    [imageScrollView setContentSize:CGSizeMake(_scrollTestImageList.count * scrollViewWidth, scrollViewHeight)];
    
    //create Content Image View
    for (NSString *imageName in _scrollTestImageList)
    {
        static NSInteger i = 0;
        
        UIImageView *foodScrollImageView = [[UIImageView alloc] init];

        foodScrollImageView.frame = CGRectMake(scrollViewWidth * i, 0, scrollViewWidth, scrollViewHeight);
        foodScrollImageView.image = [UIImage imageNamed:imageName];
        foodScrollImageView.contentMode = UIViewContentModeScaleAspectFill;
        foodScrollImageView.clipsToBounds = YES;
        [imageScrollView addSubview:foodScrollImageView];
        i += 1;
    }
    
    imageScrollView.pagingEnabled = YES;
    imageScrollView.delegate = self;
    imageScrollView.showsHorizontalScrollIndicator = NO;
    [coverView addSubview:imageScrollView];
    [self createPageControllWithSuperViewHeight:scrollViewHeight superView:coverView];
    
    //setting Table Header View
    _restaurantTableView.tableHeaderView = coverView;
    
}
#pragma mark - click Button
- (IBAction)clickSortButton:(UIButton *)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"필터" message:@"처리해 주세요" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    /*
    if (section == 0)
    {
        return 0;
    }
     */
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RestaurantListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    cell.RestaurantTitleLabel.text = [NSString stringWithFormat:@"%@", self.dataList[indexPath.section]];
    return cell;
}

#pragma mark - Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger currentOffset = scrollView.contentOffset.x;
    CGFloat scrollViewWidth = scrollView.frame.size.width;

    NSInteger index = currentOffset / scrollViewWidth;
    
    self.pageControl.currentPage = index;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
