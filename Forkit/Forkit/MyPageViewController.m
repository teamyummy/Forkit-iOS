//
//  MyPageViewController.m
//  Forkit
//
//  Created by david on 2016. 11. 28..
//  Copyright © 2016년 david. All rights reserved.
//

#import "MyPageViewController.h"
#import "ReviewDetatilViewController.h"
#import "MyPageTableViewCell.h"
#import "RestaurantListCell.h"
#import "RestaurantDetailCell.h"
#import "RestaurantDetailViewController.h"

//cell reuse Identifier
static NSString * const ReuseIdentifierProfileCell = @"MyPageProfileCell";
static NSString * const ReuseIdentifierButtonCell = @"MyPageButtonCell";
static NSString * const ReuseIdentifierReviewListCell = @"RestaurantDetailReviewCell";
static NSString * const ReuseIdentifierRestaurantListCell = @"RestaurantListCell";

static NSString * const ReuseIdentifierNotLoginCell = @"NotLoginCell";
static NSString * const ReuseIdentifierLoginButtonCell = @"LoginButtonCell";

//cell height
static const CGFloat ProfileCellHeight = 200.f;
static const CGFloat ButtonCellHeight = 44.f;
static const CGFloat ReviewListCellHeight = 80.f;

//cell margin
static const CGFloat CellMargin = 8.f;

//section number
NS_ENUM(NSInteger)
{
    SectionNumberProfile = 0,
    SectionNumberButton,
    SectionNumberReviewList
};
    
//list state
NS_ENUM(NSInteger)
{
    ListStateReview = 0,
    ListStateLikeRestaurant
};
    
//button tag
typedef NS_ENUM(NSInteger, ButtonTag)
{
    ButtonTagMyReview = 100,
    ButtonTagLikeList
};
    
@interface MyPageViewController () <UITableViewDelegate, UITableViewDataSource>

///data model
@property FIMyPageManager *myPageDataManager;

///cell list state
@property BOOL checkListState;

@property (weak, nonatomic) IBOutlet UITableView *myPageTableView;

@end

@implementation MyPageViewController

#pragma mark - ViewController Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.checkListState = ListStateReview;
    
    self.myPageDataManager = [FIMyPageManager sharedManager];
    [[FIMyPageManager sharedManager] addObserver:self
                                      forKeyPath:@"favorShop"
                                         options:NSKeyValueObservingOptionNew
                                         context:nil];
    
    [[FIMyPageManager sharedManager] addObserver:self
                                      forKeyPath:@"reviewDatas"
                                         options:NSKeyValueObservingOptionNew
                                         context:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    if ([FILoginManager isOnLogin] &&
        _myPageDataManager.reviewDatas.count == 0 &&
        _myPageDataManager.favorShop.count == 0)
    {
        [FIRequestObject requestMyFavorRestaurantList];
        [FIRequestObject requestMyRegisterReview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    [_myPageTableView reloadData];
}

#pragma mark - Table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([FILoginManager isOnLogin])
    {//login
        return 3;
    }
    return 2;
}

#pragma mark - Table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowNumber = 1;
    if (section == SectionNumberReviewList)
    {
        if (self.checkListState == ListStateReview) {
            rowNumber = _myPageDataManager.reviewDatas.count;
        } else
        {
            rowNumber = _myPageDataManager.favorShop.count;
        }
    }
    return rowNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SectionNumberProfile)
    {//profile
        if ([FILoginManager isOnLogin])
        {
            ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierProfileCell
                                                                forIndexPath:indexPath];
            
            cell.idLabel.text = [[FILoginManager sharedManager] userId];
            return cell;
        } else
        {//Not Login
            NotLoginCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierNotLoginCell
                                                                forIndexPath:indexPath];
            return cell;
        }
        
    } else if (indexPath.section == SectionNumberButton)
    {//button
        if ([FILoginManager isOnLogin])
        {
            ButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierButtonCell
                                                               forIndexPath:indexPath];
            return cell;
        } else
        {//Login Button
            LoginButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierLoginButtonCell
                                                                 forIndexPath:indexPath];
            return cell;
        }

    } else if (indexPath.section == SectionNumberReviewList)
    {//list
        if (self.checkListState == ListStateReview)
        {//review list
            RestaurantDetailReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierReviewListCell
                                                                               forIndexPath:indexPath];
            
            NSDictionary *reviewDict = [_myPageDataManager.reviewDatas objectAtIndex:indexPath.row];
            
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
                
                /*
                NSArray *images = [reviewDict objectForKey:JSONCommonImagesKey];
                
                if (images != nil && images.count != 0)
                {
                    [cell.reviewFoodImageView sd_setImageWithURL:[[images objectAtIndex:0] objectForKey:JSONCommonThumbnailImageURLKey]];
                }
                 */
            }
            return cell;
        } else if (self.checkListState == ListStateLikeRestaurant)
        {//like list
            RestaurantListCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierRestaurantListCell
                                                                               forIndexPath:indexPath];
            
            NSDictionary *restaurantDataTempDict;
            restaurantDataTempDict = [_myPageDataManager.favorShop objectAtIndex:indexPath.row];
            
            if (_myPageDataManager.favorShop != nil)
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
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0;
    
    switch (indexPath.section)
    {
        case SectionNumberProfile:
            rowHeight = ProfileCellHeight;
            break;
            
        case SectionNumberButton:
            rowHeight = ButtonCellHeight;
            if (![FILoginManager isOnLogin])
            {
                rowHeight = self.view.frame.size.height - ProfileCellHeight;
            }
            break;
            
        case SectionNumberReviewList:
            rowHeight = ReviewListCellHeight;
            break;
    }
    
    return rowHeight;
}

//header Height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == SectionNumberProfile ||
        ![FILoginManager isOnLogin])
    {
        return 0;
    }
    return CellMargin;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == SectionNumberProfile)
    {
        return nil;
    }
    UIView *clearView = [UIView new];
    clearView.backgroundColor = [UIColor clearColor];
    return clearView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - Custom Method
- (void)notSelectButton:(ButtonTag)buttonTag
{
    UIButton *button = (UIButton *)[self.view viewWithTag:buttonTag];
    if (button.selected == YES)
    {
        button.selected = NO;
    }
}

#pragma mark - Button method
- (IBAction)clickChangeListButton:(UIButton *)sender
{
    UITableViewRowAnimation rowAnimation;
    
    if ([sender isSelected] == NO)
    {//off
        if (sender.tag == ButtonTagMyReview)
        {//review
            [self notSelectButton:ButtonTagLikeList];
            self.checkListState = ListStateReview;
            rowAnimation = UITableViewRowAnimationRight;
            
        } else if (sender.tag == ButtonTagLikeList)
        {//like
            [self notSelectButton:ButtonTagMyReview];
            self.checkListState = ListStateLikeRestaurant;
            rowAnimation = UITableViewRowAnimationLeft;
        }
        sender.selected = YES;
        [self.myPageTableView reloadSections:[NSIndexSet indexSetWithIndex:SectionNumberReviewList] withRowAnimation:rowAnimation];
        
    }
}

- (IBAction)clickLogoutButton:(UIButton *)sender
{
    self.checkListState = ListStateReview;
    [FILoginManager removeLoginState];
    [[FILoginManager sharedManager] removeLoginToken];
    [[FILoginManager sharedManager] removeUserId];
    [self.myPageDataManager.reviewDatas removeAllObjects];
    [self.myPageDataManager.favorShop removeAllObjects];
    [self.myPageTableView reloadData];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[RestaurantDetailViewController class]])
    {
        RestaurantListCell *cell = sender;
        NSIndexPath *cellIndex = [_myPageTableView indexPathForCell:cell];
        NSDictionary *restaurantDatas = [_myPageDataManager.favorShop objectAtIndex:cellIndex.row];
        
        RestaurantDetailViewController *restaurantDetailVC = segue.destinationViewController;
        restaurantDetailVC.restaurantDatas = [restaurantDatas mutableCopy];
        
    } else if ([segue.destinationViewController isKindOfClass:[ReviewDetatilViewController class]])
    {
        RestaurantDetailReviewCell *cell = (RestaurantDetailReviewCell *)sender;
        NSIndexPath *cellIndex = [_myPageTableView indexPathForCell:cell];
        
        ReviewDetatilViewController *reviewDetatilVC = segue.destinationViewController;
        reviewDetatilVC.deatilReviewData = [_myPageDataManager.reviewDatas objectAtIndex:cellIndex.row];
    }
}

- (void)dealloc
{
    [[FIMyPageManager sharedManager] removeObserver:self forKeyPath:@"favorShop"];
    [[FIMyPageManager sharedManager] removeObserver:self forKeyPath:@"reviewDatas"];
}

@end
