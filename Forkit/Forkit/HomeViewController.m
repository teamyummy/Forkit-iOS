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

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>

///data manager
@property FIDataManager *dataManager;

///table header scroll imageURL data
@property NSArray *scrollImageList;

///weak self
@property (weak) HomeViewController *weakSelf;
///paging number
@property NSInteger requestPageNumber;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatiorView;

//UI
@property (weak, nonatomic) IBOutlet UITableView *restaurantTableView;
@property (weak, nonatomic) IBOutlet UIButton *sortingButton;
@property UIPageControl *pageControl;
@property UIScrollView *imageScrollView;
///refreshControl
@property UIRefreshControl *refreshControl;
@end

@implementation HomeViewController

#pragma mark - view controller life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //KVO
    [[FIDataManager sharedManager] addObserver:self
                                    forKeyPath:@"shopDatas"
                                       options:NSKeyValueObservingOptionNew
                                       context:nil];
    //weakSelf
    _weakSelf = self;
    //set block
    _weakSelf.didReceiveUpdateDataBlock = ^{
        [_weakSelf didReceiveListUpdated];
    };
    [_activityIndicatiorView startAnimating];
    //request restaurant list
    [FIRequestObject requestRestaurantList:nil
                           pagingURLString:nil
                                  isPaging:NO
                                  isSearch:NO
                 didReceiveUpdateDataBlock:_weakSelf.didReceiveUpdateDataBlock];
    //init scroll image data
    self.dataManager = [FIDataManager sharedManager];
    self.scrollImageList = [NSMutableArray array];
    //set logo image navigation item
    [self setNavigationItemTitleView];
    [self createRefreshControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    _requestPageNumber = 5;
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    [_refreshControl endRefreshing];
    [_restaurantTableView reloadData];
}

#pragma mark - block method
//list update
- (void)didReceiveListUpdated
{
    [_activityIndicatiorView stopAnimating];
    //init tableHeaderView
    [_restaurantTableView.tableHeaderView removeFromSuperview];
    _restaurantTableView.tableHeaderView = nil;
    
    //create UI
    [self createTableHeaderScrollView];
    [self createScrollView];
    [_restaurantTableView reloadData];
}

//paging
- (void)didReceiveListUpdatedPaging
{
    //update data
    [self.restaurantTableView reloadData];
}

#pragma mark - create UI method
- (void)createRefreshControl
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = [FIUtilities createKeyColor];
    
    [_refreshControl addTarget:[FIRequestObject class]
                        action:@selector(requestRestaurantList)
              forControlEvents:UIControlEventValueChanged];
    _restaurantTableView.refreshControl = _refreshControl;
}

- (void)setNavigationItemTitleView
{
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    logoImageView.frame = CGRectMake(0, 0, 0, 20);
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = logoImageView;
}

- (void)createTableHeaderScrollView
{
    NSMutableArray *tempScrollImageList = [NSMutableArray array];
    if (4 < _dataManager.shopDatas.count)
    {//음식점 리스트의 갯수가 5개 이상
        for (NSInteger i = 0; i < 5; i++)
        {
            NSDictionary *tempRestarantData = [_dataManager.shopDatas objectAtIndex:i];
            NSArray *imageDatas = [tempRestarantData objectForKey:JSONCommonImagesKey];
            [tempScrollImageList addObject:[imageDatas[0] objectForKey:JSONCommonSmallImageURLKey]];
        }
        //음식점 리스트의 갯수가 4개 이하 1개 이상
    } else if (_dataManager.shopDatas.count != 0 &&
               _dataManager.shopDatas != nil)
    {
        for (NSDictionary *tempDict in _dataManager.shopDatas)
        {
            NSArray *imageData = [tempDict objectForKey:JSONCommonImagesKey];
            {
                [tempScrollImageList addObject:[imageData[0] objectForKey:JSONCommonSmallImageURLKey]];
            }
        }
    }
    _scrollImageList = tempScrollImageList;
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
    
    //count
    NSInteger i = 0;
    
    //coever view for page control
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, scrollViewHeight)];
    _imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollViewWidth, scrollViewHeight)];
    [_imageScrollView setContentSize:CGSizeMake(_scrollImageList.count * scrollViewWidth, scrollViewHeight)];

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
    return _dataManager.shopDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell reuse identifier
    static NSString * const ReuseIdentifierRestaurantList = @"RestaurantListCell";
    
    if ([_dataManager.shopDataDict objectForKey:JSONRestaurantNextKey] != nil &&
        [_dataManager.shopDataDict objectForKey:JSONRestaurantNextKey] !=(id)[NSNull null] &&
        indexPath.row % 10 == 5 &&
        _requestPageNumber == indexPath.row)
    {
        _requestPageNumber = indexPath.row + 10;
        
        [FIRequestObject requestRestaurantList:nil
                               pagingURLString:[_dataManager.shopDataDict objectForKey:JSONRestaurantNextKey]
                                      isPaging:YES
                                      isSearch:NO
                     didReceiveUpdateDataBlock:^{
                         [_weakSelf didReceiveListUpdatedPaging];
                     }];
    }
    
    RestaurantListCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierRestaurantList forIndexPath:indexPath];
    
    NSDictionary *restaurantDataTempDict;
    restaurantDataTempDict = [_dataManager.shopDatas objectAtIndex:indexPath.row];
    
    if (_dataManager.shopDatas != nil)
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
        NSDictionary *restaurantDatas = [_dataManager.shopDatas objectAtIndex:cellIndex.row];
        
        RestaurantDetailViewController *restaurantDetailVC = segue.destinationViewController;
        restaurantDetailVC.restaurantDatas = [restaurantDatas mutableCopy];
    } 
}

- (void)dealloc 
{
    [[FIDataManager sharedManager] removeObserver:self forKeyPath:@"shopDatas"];
}
@end
