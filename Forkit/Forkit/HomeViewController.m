//
//  ViewController.m
//  Forkit
//
//  Created by david on 2016. 11. 28..
//  Copyright © 2016년 david. All rights reserved.
//
#import "HomeViewController.h"
#import "RestaurantListCell.h"
#import "RestaurantDetailViewController.h"
#import "MapViewController.h"
#import "SortViewController.h"

//cell reuse identifier
static NSString * const ReuseIdentifierRestaurantList = @"RestaurantListCell";

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>

//Data
@property NSArray *restaurantDataList;
@property NSArray *scrollImageList;
@property NSDictionary *pagingDataDict;

@property (weak) HomeViewController *weakSelf;
@property NSInteger requestPageNumber;

//UI
@property (weak, nonatomic) IBOutlet UITableView *restaurantTableView;
@property (weak, nonatomic) IBOutlet UIButton *sortingButton;
@property UIPageControl *pageControl;
@property UIScrollView *imageScrollView;

@end

@implementation HomeViewController

#pragma mark - view controller life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    //weakSelf
    _weakSelf = self;
    
    //block property
    _weakSelf.didReceiveUpdateDataBlock = ^{
        [_weakSelf didReceiveListUpdated];
    };
    
    //request restaurant list
    [FIRequestObject requestRestaurantList:nil
                           pagingURLString:nil
                 didReceiveUpdateDataBlock:_weakSelf.didReceiveUpdateDataBlock];
    
    //alloc scroll image
    self.scrollImageList = [NSMutableArray array];
    
    //set logo image navigation item
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    logoImageView.frame = CGRectMake(0, 0, 0, 20);
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = logoImageView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - custom method
//completion request
- (void)didReceiveListUpdated
{
    [self.pageControl removeFromSuperview];
    self.pageControl = nil;
    [self.imageScrollView removeFromSuperview];
    self.imageScrollView = nil;
    
    
    _requestPageNumber = 5;
    
    _restaurantDataList = [[FIDataManager sharedManager] shopDatas];
    
    _pagingDataDict = [[FIDataManager sharedManager] shopDataDict];
    
    NSMutableArray *tempScrollImageList = [NSMutableArray array];
    
    if (4 < _restaurantDataList.count)
    {//음식점 리스트의 갯수가 5개 이상
        for (NSInteger i = 0; i < 5; i++)
        {
            NSDictionary *tempRestarantData = [_restaurantDataList objectAtIndex:i];
            NSArray *imageDatas = [tempRestarantData objectForKey:JSONCommonImagesKey];
            [tempScrollImageList addObject:[imageDatas[0] objectForKey:JSONCommonSmallImageURLKey]];
        }
        //음식점 리스트의 갯수가 4개 이하 1개 이상
    } else if (_restaurantDataList.count != 0 &&
               _restaurantDataList != nil)
    {
        for (NSDictionary *tempDict in _restaurantDataList)
        {
            NSArray *imageData = [tempDict objectForKey:JSONCommonImagesKey];
            {
                [tempScrollImageList addObject:[imageData[0] objectForKey:JSONCommonSmallImageURLKey]];
            }
        }
    }
    _scrollImageList = tempScrollImageList;
    [self createScrollView];
    [self.restaurantTableView reloadData];
}

- (void)didReceiveListUpdatedPaging
{
    __block NSMutableArray *blockRestaurantDataList = [NSMutableArray array];
    [blockRestaurantDataList addObjectsFromArray:_restaurantDataList];
    [blockRestaurantDataList addObjectsFromArray:[[FIDataManager sharedManager] shopDatas]];
    
    _restaurantDataList = blockRestaurantDataList;
    
    _pagingDataDict = [[FIDataManager sharedManager] shopDataDict];
    
    [self.restaurantTableView reloadData];
}

- (void)createPageControllWithSuperViewHeight:(CGFloat)height superView:(UIView *)superView
{
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.frame = CGRectMake(0, height - 16, 0, 0);
    _pageControl.numberOfPages = _scrollImageList.count;
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = [FIUtilities createKeyColor];
    _pageControl.defersCurrentPageDisplay = YES;
    [superView addSubview:_pageControl];
}

- (void)createScrollView
{
    //setting Height, Width
    const CGFloat scrollViewHeight = 180;
    const CGFloat scrollViewWidth = _restaurantTableView.frame.size.width;
    
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, scrollViewHeight)];
    _imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollViewWidth, scrollViewHeight)];
    
    [_imageScrollView setContentSize:CGSizeMake(_scrollImageList.count * scrollViewWidth, scrollViewHeight)];
    NSInteger i = 0;

    //create Content Image View
    for (NSString *imageURL in _scrollImageList)
    {
        UIImageView *foodScrollImageView = [[UIImageView alloc] init];

        foodScrollImageView.frame = CGRectMake(scrollViewWidth * i, 0, scrollViewWidth, scrollViewHeight);
        [foodScrollImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
        foodScrollImageView.contentMode = UIViewContentModeScaleAspectFill;
        foodScrollImageView.clipsToBounds = YES;
        [_imageScrollView addSubview:foodScrollImageView];
        i += 1;
    }
    
    _imageScrollView.pagingEnabled = YES;
    _imageScrollView.delegate = self;
    _imageScrollView.showsHorizontalScrollIndicator = NO;
    [coverView addSubview:_imageScrollView];
    [self createPageControllWithSuperViewHeight:scrollViewHeight superView:coverView];
    
    //setting Table Header View
    _restaurantTableView.tableHeaderView = coverView;
    
}
#pragma mark - click Button
- (IBAction)clickSortButton:(UIButton *)sender
{
    SortViewController *sortVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SortVC"];
    [self.tabBarController addChildViewController:sortVC];
    [self.tabBarController.view addSubview:sortVC.view];
    [sortVC didMoveToParentViewController:self];
    [sortVC setVisibleSortView];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *clearColorView = [[UIView alloc] init];
    clearColorView.backgroundColor = [UIColor clearColor];
    return clearColorView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.restaurantDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_pagingDataDict objectForKey:JSONRestaurantNextKey] != nil &&
        [_pagingDataDict objectForKey:JSONRestaurantNextKey] !=(id)[NSNull null] &&
        indexPath.row % 10 == 5 &&
        _requestPageNumber == indexPath.row)
    {
        _requestPageNumber = indexPath.row + 10;
        
        [FIRequestObject requestRestaurantList:nil
                               pagingURLString:[_pagingDataDict objectForKey:JSONRestaurantNextKey]
                     didReceiveUpdateDataBlock:^{
                         [_weakSelf didReceiveListUpdatedPaging];
                     }];
    }
    
    RestaurantListCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierRestaurantList forIndexPath:indexPath];
    
    NSDictionary *restaurantDataTempDict;
    restaurantDataTempDict = [self.restaurantDataList objectAtIndex:indexPath.row];
    
    if (self.restaurantDataList != nil)
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


#pragma mark - Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]])
    {
        return;
    }
    NSInteger currentOffset = scrollView.contentOffset.x;
    CGFloat scrollViewWidth = scrollView.frame.size.width;

    NSInteger index = currentOffset / scrollViewWidth;
    
    self.pageControl.currentPage = index;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[RestaurantDetailViewController class]])
    {
        RestaurantListCell *cell = sender;
        NSIndexPath *cellIndex = [_restaurantTableView indexPathForCell:cell];
        NSDictionary *restaurantDatas = [_restaurantDataList objectAtIndex:cellIndex.row];
        
        RestaurantDetailViewController *restaurantDetailVC = segue.destinationViewController;
        restaurantDetailVC.restaurantDatas = restaurantDatas;
    } else if ([segue.destinationViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *mapNavigationVC = segue.destinationViewController;
        MapViewController *mapVC = (MapViewController *)[mapNavigationVC visibleViewController];
        mapVC.restaurantDataList = _restaurantDataList;
    }
}


@end
