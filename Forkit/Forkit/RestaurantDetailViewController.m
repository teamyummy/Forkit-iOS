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
#import "MenuTableViewController.h"
#import "ReviewDetatilViewController.h"

static NSString * const reuseIdentifierTitleCell = @"RestaurantDetailTitleCell";
static NSString * const reuseIdentifierInfoCell = @"RestaurantDetailInfoCell";
static NSString * const reuseIdentifierReviewTitleCell = @"RestaurantDetailReviewTitleCell";
static NSString * const reuseIdentifierReviewCell = @"RestaurantDetailReviewCell";

@interface RestaurantDetailViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *customNavigationBar;
@property (weak, nonatomic) IBOutlet UITableView *restaurantDetailTableView;
@property (weak, nonatomic) IBOutlet UILabel *customNavigationTitle;

@property NSArray *scrollImageList;
@property NSArray *reviewList;

@end

@implementation RestaurantDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self preferredStatusBarStyle];
    
    RestaurantDetailViewController * __weak weakSelf = self;
    
    _didReceiveUpdateDataBlock = ^{
        [FIRequestObject requestReviewListWithRestaurantPk:[weakSelf.restaurantDatas objectForKey:JSONCommonPrimaryKey] didReceiveUpdateDataBlock:^{
            [weakSelf didReceiveReviewDataUpdated];
        }];
    };
    
    [FIRequestObject requestReviewListWithRestaurantPk:[_restaurantDatas objectForKey:JSONCommonPrimaryKey] didReceiveUpdateDataBlock:^{
        [weakSelf didReceiveReviewDataUpdated];
    }];
    
    self.scrollImageList = [NSMutableArray array];
    self.customNavigationTitle.text = [_restaurantDatas objectForKey:JSONRestaurnatNameKey];
    
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

- (void)didReceiveReviewDataUpdated
{
    self.reviewList = [[FIReviewDataManager sharedManager] reviewDatas];
    NSMutableArray *tempImageList = [NSMutableArray array];
    for (NSDictionary *tempDict in _reviewList)
    {
        NSArray *imageData = [tempDict objectForKey:JSONCommonImagesKey];
        if (imageData.count != 0 &&
            imageData != nil)
        {
            for (NSInteger i = 0; i < imageData.count; i++)
            {
                [tempImageList addObject:[imageData[i] objectForKey:JSONCommonThumbnailImageURLKey]];
            }
        }
    }
    _scrollImageList = tempImageList;
    [self.restaurantDetailTableView reloadData];
}

- (void)didReceiveUpdateReview
{
    
}

- (void)didReceiveReviewLikeDataUpdated
{
    [self setUpdateRestaurantDatas];
    [self.restaurantDetailTableView reloadData];
}

- (void)setUpdateRestaurantDatas
{
    NSDictionary *tempDict = [[FIDataManager sharedManager] shopDetailData];
    [self.restaurantDatas setValue:[tempDict objectForKey:JSONRestaurnatTotalReviewCountKey] forKey:JSONRestaurnatTotalReviewCountKey];
    [self.restaurantDatas setValue:[tempDict objectForKey:JSONRestaurnatAvgReviewScoreKey] forKey:JSONRestaurnatAvgReviewScoreKey];
    [self.restaurantDatas setValue:[tempDict objectForKey:JSONRestaurnatTotalLikeKey] forKey:JSONRestaurnatTotalLikeKey];
    [self.restaurantDatas setValue:[tempDict objectForKey:JSONRestaurnatMyLikeKey] forKey:JSONRestaurnatMyLikeKey];
    [self.restaurantDatas setValue:[tempDict objectForKey:JSONRestaurnatMyLikePrimaryKey] forKey:JSONRestaurnatMyLikePrimaryKey];
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
        return self.reviewList.count;
    }
    return 1;
}

- (void)checkMyLikeRestaurantState:(RestaurantDetailTitleCell *)cell
{
    if ([FILoginManager isOnLogin])
    {
        BOOL isOnMyLikeState = [[_restaurantDatas objectForKey:JSONRestaurnatMyLikeKey] boolValue];
        if (isOnMyLikeState)
        {
            cell.likeButton.selected = YES;
            cell.likeButtonLabel.textColor = [FIUtilities createKeyColor];
            cell.likeButtonRoundView.layer.borderColor = [FIUtilities createKeyColor].CGColor;
            cell.likeButtonImageView.image = [UIImage imageNamed:@"favorSelected"];
        }
    }
}
//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        RestaurantDetailTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTitleCell forIndexPath:indexPath];
        
        [self checkMyLikeRestaurantState:cell];
        cell.restaurantTitleLabel.text = [_restaurantDatas objectForKey:JSONRestaurnatNameKey];
        
        cell.scoreAvgLabel.text = [_restaurantDatas objectForKey:JSONRestaurnatAvgReviewScoreKey];
        
        cell.reviewCountLabel.text = [_restaurantDatas objectForKey:JSONRestaurnatTotalReviewCountKey];
        
        cell.likeCountLabel.text = [_restaurantDatas objectForKey:JSONRestaurnatTotalLikeKey];
        
        if ([_restaurantDatas objectForKey:JSONRestaurnatTagsKey] != nil && [[_restaurantDatas objectForKey:JSONRestaurnatTagsKey] count] != 0)
        {
            NSDictionary *tagDict = [[_restaurantDatas objectForKey:JSONRestaurnatTagsKey] objectAtIndex:0];
            
            cell.tagLabel.text = [tagDict objectForKey:JSONRestaurnatTagNameKey];
        }
        
        NSArray *images = [_restaurantDatas objectForKey:JSONCommonImagesKey];
        
        if (images != nil && [images count] != 0)
        {
            [cell.titleImageView sd_setImageWithURL:[[images objectAtIndex:0] objectForKey:JSONCommonBigImageURLKey]];
        }
        
        return cell;
    } else if (indexPath.section == 1)
    {
        RestaurantDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierInfoCell forIndexPath:indexPath];
        
        [self createScrollViewWithCell:cell];
        
        cell.addressLabel.text = [_restaurantDatas objectForKey:JSONRestaurnatAddressKey];
        
        cell.phoneNumberLabel.text = [_restaurantDatas objectForKey:JSONRestaurnatPhoneNumberKey];
        
        cell.operationHourLabel.text = [_restaurantDatas objectForKey:JSONRestaurnatOperationHourKey];
        
        cell.deliveryInfoLabel.text = [_restaurantDatas objectForKey:JSONRestaurnatDeliveryDescriptionKey];
        
        cell.parkingInfoLabel.text = [_restaurantDatas objectForKey:JSONRestaurnatParkingDescriptionKey];
        
        return cell;
    } else if (indexPath.section == 2)
    {
        RestaurantDetailReviewTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReviewTitleCell forIndexPath:indexPath];
        cell.reviewCountLabel.text = [NSString stringWithFormat:@"%ld",[_reviewList count]];
        return cell;
    } else if (indexPath.section == 3)
    {
        RestaurantDetailReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReviewCell forIndexPath:indexPath];
        
        NSDictionary *reviewDict = [_reviewList objectAtIndex:indexPath.row];
        
        if (reviewDict != nil && reviewDict.count != 0)
        {
            cell.reviewIdLabel.text = [reviewDict objectForKey:JSONReviewAuthorKey];
            cell.reviewTextLabel.text = [reviewDict objectForKey:JSONReviewContentKey];
            
            NSNumber *reviewScore = [reviewDict objectForKey:JSONReviewScoreKey];
            
            for (NSInteger i = 1; i <= reviewScore.integerValue; i++)
            {
                UIButton *likeButton = (UIButton *)[self.view viewWithTag:i];
                likeButton.selected = YES;
            }
        }
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

 

#pragma mark - Click Button Method
- (IBAction)presentReviewController:(UIButton *)sender
{
    if (![FILoginManager isOnLogin])
    {
        [self showAlert];
    } else
    {
        self.tabBarController.tabBar.hidden = YES;
        ReviewViewController *reviewAlertVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ReviewVC"];
        
        reviewAlertVC.restaurantPk = [_restaurantDatas objectForKey:JSONCommonPrimaryKey];
        [self addChildViewController:reviewAlertVC];
        [self.view addSubview:reviewAlertVC.view];
        reviewAlertVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        [UIView animateWithDuration:0.2 animations:^{
            reviewAlertVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.70];
        }];
        [reviewAlertVC didMoveToParentViewController:self];
    }
}

- (IBAction)clickLikeButton:(UIButton *)sender
{
    RestaurantDetailViewController * __weak weakSelf = self;
    if (![FILoginManager isOnLogin])
    {
        [self showAlert];
    } else
    {
        if ([sender isSelected] == NO)
        {
            sender.selected = YES;
            [FIRequestObject requestFavorRestaurantWithRestaurantPk:[_restaurantDatas objectForKey:JSONCommonPrimaryKey] likePk:nil didReceiveUpdateDataBlock:^{
                [weakSelf didReceiveReviewLikeDataUpdated];
            }];
        } else
        {
            sender.selected = NO;
            [FIRequestObject requestFavorRestaurantWithRestaurantPk:[_restaurantDatas objectForKey:JSONCommonPrimaryKey] likePk:[_restaurantDatas objectForKey:JSONRestaurnatMyLikePrimaryKey] didReceiveUpdateDataBlock:^{
                [weakSelf didReceiveReviewLikeDataUpdated];
            }];
        }
    }
}

- (IBAction)clickPopButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Scroll View Method
- (void)createScrollViewWithCell:(RestaurantDetailInfoCell *)cell
{
    CGFloat scrollViewWidth = cell.reviewPhotoScrollView.frame.size.width;
    CGFloat scrollViewHeight = cell.reviewPhotoScrollView.frame.size.height;
    CGFloat scrollViewLeading = 20;
    CGFloat contentImageViewWidth = scrollViewWidth - (scrollViewLeading * 2);
    cell.reviewPhotoScrollView.contentSize = CGSizeMake((scrollViewWidth /3) * _scrollImageList.count - scrollViewLeading, scrollViewHeight);
    NSInteger i = 0;
    
    for (NSString *imageURLString in _scrollImageList)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i * contentImageViewWidth/3) + scrollViewLeading, 0, contentImageViewWidth/3, scrollViewHeight)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageURLString]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
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
#pragma mark - Alert
- (void)showAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"로그인"
                                                                   message:@"로그인이 필요한 서비스 입니다."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"확인"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.destinationViewController isKindOfClass:[MenuTableViewController class]])
    {
        MenuTableViewController *menuTableVC = segue.destinationViewController;
        menuTableVC.restaurnatPk = [_restaurantDatas objectForKey:JSONCommonPrimaryKey];
    } else if ([segue.destinationViewController isKindOfClass:[ReviewDetatilViewController class]])
    {
        RestaurantDetailReviewCell *cell = (RestaurantDetailReviewCell *)sender;
        NSIndexPath *cellIndex = [_restaurantDetailTableView indexPathForCell:cell];
        
        ReviewDetatilViewController *reviewDetatilVC = segue.destinationViewController;
        reviewDetatilVC.deatilReviewData = [_reviewList objectAtIndex:cellIndex.row];
        reviewDetatilVC.restaurantPk = [_restaurantDatas objectForKey:JSONCommonPrimaryKey];
    }
}


@end
