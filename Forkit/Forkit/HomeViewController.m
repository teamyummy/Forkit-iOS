/*
 Copyright (c) 2011, Tim Cinel (see AUTHORS)
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of the <organization> nor the
 names of its contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "HomeViewController.h"
#import "RestaurantListCell.h"
#import "ActionSheetPicker.h"

static NSString * const reuseIdentifier = @"RestaurantListCell";

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource ,UIScrollViewDelegate>

///dummy Data
@property NSMutableArray *dataList;
@property NSArray *scrollTestImageList;

@property (weak, nonatomic) IBOutlet UITableView *restaurantTableView;
@property (weak, nonatomic) IBOutlet UIButton *sortingButton;

@property UIPageControl *pageControl;

@end

@implementation HomeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // 검색필터 이름 초기값을 '최신순'으로 설정
    FIDataManager *sortingManager = [FIDataManager sharedManager];
    [sortingManager setCurrentSearchFilterName:@"최신순"];
    [self.sortingButton setTitle:sortingManager.currentSearchFilterName forState:UIControlStateNormal];
    
    // 일단 지금은 FIDataManager 에 저장된 가게정보 전체를 다 가져옴
    self.dataList = sortingManager.shopDatas;
    
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
    
    HomeViewController __weak *wself = self;

    FIDataManager *sortingManager = [FIDataManager sharedManager];
    
    NSArray *searchFilter = @[@"최신순", @"평점순", @"리뷰순"];
    
    [ActionSheetStringPicker showPickerWithTitle:@"검색필터"
                                            rows:searchFilter
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           NSLog(@"Picker: %@, Index: %ld, value: %@",
                                                 picker, selectedIndex, selectedValue);
                                           
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               [sortingManager setCurrentSearchFilterName:(NSString *) selectedValue];
                                               [wself.sortingButton setTitle:(NSString *)selectedValue forState:UIControlStateNormal]; // 새로 선택된 필터이름을 버튼에 세팅
                                               
                                               // 태그 결과를 FIDataManager 에게 반영
                                               // 태그 결과가 반영된 검색 기능 추가해야 함
                                               // [wself.tableView reloadData];
                                           });
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:sender];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.dataList.count;
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataList.count;
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
    
    RestaurantListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.RestaurantTitleLabel.text = self.dataList[indexPath.section][@"name"];
    //! 지금은 내부 이미지를 사용하기 때문에 imageNamed 를 사용하였음
    cell.RestaurantImageView.image = [UIImage imageNamed:self.dataList[indexPath.section][@"image"]];
    cell.RestaurantScoreLabel.text = self.dataList[indexPath.section][@"score"];
    cell.RestaurantAddressLabel.text = self.dataList[indexPath.section][@"address"];
    cell.RestaurantReviewCountLabel.text = self.dataList[indexPath.section][@"review_count"];
    cell.RestaurantLikeCountLabel.text = self.dataList[indexPath.section][@"favorite_count"];
    
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
