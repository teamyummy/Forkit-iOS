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

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property NSMutableArray *dataList;
@property (weak, nonatomic) IBOutlet UITableView *restaurantTableView;
@property NSArray *scrollTestImageList;

@end

@implementation HomeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataList = [NSMutableArray array];
    NSArray *testArr = @[@"맛집 이름", @"맛집 이름", @"맛집 이름", @"맛집 이름", @"맛집 이름", @"맛집 이름", @"맛집 이름"];
    [_dataList addObjectsFromArray:testArr];
    
    [self createScrollView];
    
}
- (void)createScrollView
{
    //setting Height, Width
    const CGFloat scrollViewHeight = 160;
    const CGFloat scrollViewWidth = _restaurantTableView.frame.size.width;
    
    //setting TestImageList
    self.scrollTestImageList = @[@"dummyFoodImage",@"dummyFoodImage",@"dummyFoodImage"];
    
    UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 0, scrollViewHeight)];
    
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
    
    //setting Table Header View
    _restaurantTableView.tableHeaderView = imageScrollView;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RestaurantListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    cell.RestaurantTitleLabel.text = [NSString stringWithFormat:@"%@", self.dataList[indexPath.section]];
    return cell;
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
