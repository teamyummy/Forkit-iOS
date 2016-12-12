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

//cell reuse identifier
static NSString * const ReuseIdentifierRestaurantList = @"RestaurantListCell";

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource ,UIScrollViewDelegate ,UIPickerViewDelegate, UIPickerViewDataSource>

//Data
@property NSArray *restaurantDataList;
@property NSMutableArray *scrollImageList;

//UI
@property (weak, nonatomic) IBOutlet UITableView *restaurantTableView;
@property (weak, nonatomic) IBOutlet UIButton *sortingButton;
@property UIPageControl *pageControl;

@end

@implementation HomeViewController

#pragma mark - view controller life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //weakSelf
    HomeViewController * __weak weakSelf = self;
    
    //request restaurant list
    [FIRequestObject requestRestaurantList:nil
                 didReceiveUpdateDataBlock:^{
                     [weakSelf didReceiveListUpdated];
                 }];
    
    //alloc scroll image
    self.scrollImageList = [NSMutableArray array];
    
    //set logo image navigation item
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dummyLogo"]];
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
    self.restaurantDataList = [[FIDataManager sharedManager] shopDatas];
    
    if (4 < _restaurantDataList.count)
    {//음식점 리스트의 갯수가 5개 이상
        for (NSInteger i = 0; i < 5; i++)
        {
            NSDictionary *tempRestarantData = [_restaurantDataList objectAtIndex:i];
            NSArray *imageDatas = [tempRestarantData objectForKey:JSONCommonImagesKey];
            [self.scrollImageList addObject:[imageDatas[0] objectForKey:JSONCommonSmallImageURLKey]];
        }
        //음식점 리스트의 갯수가 4개 이하 1개 이상
    } else if (_restaurantDataList.count != 0 &&
               _restaurantDataList != nil)
    {
        for (NSDictionary *tempDict in _restaurantDataList)
        {
            NSArray *imageData = [tempDict objectForKey:JSONCommonImagesKey];
            {
                [self.scrollImageList addObject:[imageData[0] objectForKey:JSONCommonSmallImageURLKey]];
            }
        }
    }
    [self createScrollView];
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
    [superView addSubview:_pageControl];
}

- (void)createScrollView
{
    //setting Height, Width
    const CGFloat scrollViewHeight = 180;
    const CGFloat scrollViewWidth = _restaurantTableView.frame.size.width;
    
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, scrollViewHeight)];
    UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollViewWidth, scrollViewHeight)];
    
    [imageScrollView setContentSize:CGSizeMake(_scrollImageList.count * scrollViewWidth, scrollViewHeight)];
    
    //create Content Image View
    for (NSString *imageURL in _scrollImageList)
    {
        static NSInteger i = 0;
        
        UIImageView *foodScrollImageView = [[UIImageView alloc] init];

        foodScrollImageView.frame = CGRectMake(scrollViewWidth * i, 0, scrollViewWidth, scrollViewHeight);
        [foodScrollImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(8, 8, alert.view.frame.size.width - 8 * 4.5, 160)];
    containerView.backgroundColor = [UIColor clearColor];
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height)];
    pickerView.showsSelectionIndicator = YES;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    
    UIToolbar *tools=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0,containerView.frame.size.width,40)];
    tools.barStyle = UIBarStyleBlackOpaque;

    
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithTitle:@"Done"
                                                                style:UIBarButtonItemStyleDone
                                                               target:self
                                                               action:@selector(btnActinDoneClicked)];
    
    doneButton.imageInsets=UIEdgeInsetsMake(200, 6, 50, 25);
    UIBarButtonItem *flexSpace= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil];
    
    NSArray *array = [[NSArray alloc]initWithObjects:flexSpace,doneButton,nil];
    
    [tools setItems:array];
    
    [containerView addSubview:tools];
    
    [containerView addSubview:pickerView];
    
    [alert.view addSubview:containerView];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)btnActinDoneClicked
{
    
}

#pragma mark - Picker view delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *sortTitleArr = @[@"최신순", @"평점순", @"리뷰순"];
    return sortTitleArr[row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
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
