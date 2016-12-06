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

//user info key
static NSString * const UserInfoKeyLoginState = @"UserInfoKeyLoginState";

//user info value
static NSString * const UserInfoValueLogin = @"1";
static NSString * const UserInfoValueNotLogin = @"0";

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

@property NSArray *testArr;
@property BOOL checkListState;
@property (weak, nonatomic) IBOutlet UITableView *myPageTableView;

@end

@implementation MyPageViewController

#pragma mark - ViewController Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //test data setting
    self.testArr = @[@"1", @"1", @"1", @"1", @"1", @"1", @"1", @"1", @"1"];
    self.checkListState = ListStateReview;
    [[NSUserDefaults standardUserDefaults] setObject:UserInfoValueNotLogin forKey:UserInfoKeyLoginState];
    /*
    [FIRequestObject requestRestaurantList];
    [FIRequestObject requestReviewListWithRestaurantPk:@"1"];
    [FIRequestObject requestDeleteReviewWithRestaurantPk:@"1" reviewPk:@"3"];
    [FIRequestObject requestUploadReviewListWithRestaurantPk:@"1"
                                                       image:[UIImage imageNamed:@"dummyImage"]
                                                    contents:@"되라되라되라"
                                                       score:3];
     */
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKeyLoginState] isEqualToString:UserInfoValueLogin])
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
        rowNumber = self.testArr.count;
    }
    return rowNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SectionNumberProfile)
    {//profile
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKeyLoginState] isEqualToString:UserInfoValueLogin])
        {
            ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierProfileCell
                                                                forIndexPath:indexPath];
            return cell;
        } else
        {//Not Login
            NotLoginCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierNotLoginCell
                                                                forIndexPath:indexPath];
            return cell;
        }
        
    } else if (indexPath.section == SectionNumberButton)
    {//button
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKeyLoginState] isEqualToString:UserInfoValueLogin])
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
            return cell;
        } else if (self.checkListState == ListStateLikeRestaurant)
        {//like list
            RestaurantListCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierRestaurantListCell
                                                                               forIndexPath:indexPath];
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
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKeyLoginState] isEqualToString:UserInfoValueNotLogin]||
                [[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKeyLoginState] == nil)
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
        [[[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKeyLoginState] isEqualToString:UserInfoValueNotLogin]||
        [[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKeyLoginState] == nil)
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
- (void)notSelectButton:(ButtonTag)buttonTag ButtonCell:(ButtonCell *)buttonCell
{
    UIButton *button = (UIButton *)[self.view viewWithTag:buttonTag];
    if (button.selected == YES)
    {
        button.selected = NO;
        if (buttonTag == ButtonTagLikeList)
        {
            buttonCell.likeButtonLabel.textColor = [UIColor blackColor];
            buttonCell.likeButtonImageView.image = [UIImage imageNamed:@"dummyFoodImage"];
        } else if (buttonTag == ButtonTagMyReview)
        {
            buttonCell.reviewButtonLabel.textColor = [UIColor blackColor];
            buttonCell.reviewButtonImageView.image = [UIImage imageNamed:@"dummyFoodImage"];
        }
    }
}

#pragma mark - Button method
- (IBAction)clickChangeListButton:(UIButton *)sender
{
    UITableViewRowAnimation rowAnimation;
    ButtonCell *cell = [self.myPageTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:SectionNumberButton]];
    if ([sender isSelected] == NO)
    {//off
        if (sender.tag == ButtonTagMyReview)
        {//review
            [self notSelectButton:ButtonTagLikeList ButtonCell:cell];
            cell.reviewButtonLabel.textColor = [FIUtilities createKeyColor];
            cell.reviewButtonImageView.image = [UIImage imageNamed:@"dummyImage"];
            self.checkListState = ListStateReview;
            rowAnimation = UITableViewRowAnimationLeft;
            
        } else if (sender.tag == ButtonTagLikeList)
        {//like
            [self notSelectButton:ButtonTagMyReview ButtonCell:cell];
            cell.likeButtonLabel.textColor = [FIUtilities createKeyColor];
            cell.likeButtonImageView.image = [UIImage imageNamed:@"dummyImage"];
            self.checkListState = ListStateLikeRestaurant;
            rowAnimation = UITableViewRowAnimationRight;
        }
        sender.selected = YES;
        [self.myPageTableView reloadSections:[NSIndexSet indexSetWithIndex:SectionNumberReviewList] withRowAnimation:rowAnimation];
    }
}
- (IBAction)clickLoginButton:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:UserInfoValueLogin forKey:UserInfoKeyLoginState];
    [self.myPageTableView reloadData];
}

- (IBAction)clickLogoutButton:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserInfoKeyLoginState];
    [self.myPageTableView reloadData];
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
