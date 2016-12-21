//
//  SortViewController.m
//  Forkit
//
//  Created by david on 2016. 12. 16..
//  Copyright © 2016년 david. All rights reserved.
//

#import "SortViewController.h"
#import "UIButton+ImageTintColor.h"
#import "HomeViewController.h"

//sort button tag
typedef NS_ENUM(NSInteger, SortButtonTag)
{
    OrderNewButtonTag = 100,
    OrderAvgButtonTag,
    OrderLikeButtonTag,
    OrderReviewButtonTag,
    FoodSortkoreaButtonTag,
    FoodSortJapanButtonTag,
    FoodSortChinaButtonTag,
    FoodSortAmericaButtonTag,
    FoodSortCafeButtonTag,
    FoodSortBarButtonTag
};

//food sort state
typedef NS_OPTIONS(NSUInteger, FoodSortState) {
    FoodSortStateSelectedKorea      = 1 << 0,
    FoodSortStateSelectedJapan      = 1 << 1,
    FoodSortStateSelectedChina      = 1 << 2,
    FoodSortStateSelectedAmerica    = 1 << 3,
    FoodSortStateSelectedCafe       = 1 << 4,
    FoodSortStateSelectedBar        = 1 << 5
};

//sort button state
static FoodSortState FoodSortButtonState = 0;

//order button state tag
static SortButtonTag OrderButtonTag = OrderNewButtonTag;

//param value
static NSString *const ParamValueReviewAverageOrder = @"-review_average,-pk";
static NSString *const ParamValueReviewCountOrder = @"-review_count,-pk";
static NSString *const ParamValueFavoriteOrder= @"-total_like,-pk";
static NSString *const ParamValueNewOrder = @"-pk,-pk";

//button data key
static NSString *const ButtonDataImageNameKey = @"imageName";
static NSString *const ButtonDataTitleKey = @"title";
static NSString *const ButtonDataTagKey = @"tag";

//order param
static NSString *OrderingParamValue = @"-pk,-pk";

@interface SortViewController ()

//UI component
@property (weak, nonatomic) IBOutlet UIView *sortView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sortViewTopLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIView *foodSortViewUp;
@property (weak, nonatomic) IBOutlet UIView *foodSortViewDown;

//sort request parameter
@property NSString *orderingParamValueTemp;

//user click sort button
@property BOOL isSelectedSortButton;

@property NSMutableString *foodSortParamValue;
@property FoodSortState foodSortButtonStateTemp;

@end

@implementation SortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isSelectedSortButton = NO;
    //ordering param
    _orderingParamValueTemp = nil;
    
    //init food sort button
    _foodSortButtonStateTemp = 0;
    
    //set button state
    [self setOrderButtonState];
    if (FoodSortButtonState != 0)
    {
        _foodSortButtonStateTemp = FoodSortButtonState;
    }
    
    _foodSortParamValue = [NSMutableString string];
    
    NSArray *sortButtonData = @[@{ButtonDataImageNameKey : @"foodSortKorea",
                                  ButtonDataTitleKey : @"한식",
                                  ButtonDataTagKey : [NSNumber numberWithInteger:FoodSortkoreaButtonTag]}
                                ,@{ButtonDataImageNameKey : @"foodSortJapan",
                                   ButtonDataTitleKey : @"일식",
                                   ButtonDataTagKey : [NSNumber numberWithInteger:FoodSortJapanButtonTag]}
                                ,@{ButtonDataImageNameKey : @"foodSortChina",
                                   ButtonDataTitleKey : @"중식",
                                   ButtonDataTagKey : [NSNumber numberWithInteger:FoodSortChinaButtonTag]}];
    
    [self createButtonWithDatas:sortButtonData
                      superView:_foodSortViewUp];
    
    sortButtonData = @[@{ButtonDataImageNameKey : @"foodSortAmerica",
                         ButtonDataTitleKey : @"양식",
                         ButtonDataTagKey : [NSNumber numberWithInteger:FoodSortAmericaButtonTag]}
                       ,@{ButtonDataImageNameKey : @"foodSortCafe",
                          ButtonDataTitleKey : @"카페",
                          ButtonDataTagKey : [NSNumber numberWithInteger:FoodSortCafeButtonTag]}
                       ,@{ButtonDataImageNameKey : @"foodSortBar",
                          ButtonDataTitleKey : @"주점",
                          ButtonDataTagKey : [NSNumber numberWithInteger:FoodSortBarButtonTag]}];
    
    [self createButtonWithDatas:sortButtonData
                      superView:_foodSortViewDown];
    
    [self setFoodSortButtonState];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setVisibleSortView
{
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _sortViewTopLayoutConstraint.constant = (-1.f * _sortView.frame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.70];
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - set button state
- (void)setOrderButtonState
{
    UIButton *selectedButton = (UIButton *)[self.view viewWithTag:OrderButtonTag];
    selectedButton.selected = YES;
    selectedButton.layer.borderWidth = 1;
    selectedButton.layer.borderColor = [FIUtilities createKeyColor].CGColor;
}

- (void)setFoodSortButtonState
{
    for (NSInteger i = FoodSortkoreaButtonTag; i <= FoodSortBarButtonTag; i++)
    {
        UIButton *foodSortButton = (UIButton *)[self.view viewWithTag:i];
        if (FoodSortButtonState != 0)
        {
            switch (i) {
                case FoodSortkoreaButtonTag:
                    if (FoodSortButtonState & FoodSortStateSelectedKorea)
                    {
                        foodSortButton.selected = YES;
                    }
                    break;
                    
                case FoodSortJapanButtonTag:
                    if (FoodSortButtonState & FoodSortStateSelectedJapan)
                    {
                        foodSortButton.selected = YES;
                    }
                    break;
                    
                case FoodSortChinaButtonTag:
                    if (FoodSortButtonState & FoodSortStateSelectedChina)
                    {
                        foodSortButton.selected = YES;
                    }
                    break;
                    
                case FoodSortAmericaButtonTag:
                    if (FoodSortButtonState & FoodSortStateSelectedAmerica)
                    {
                        foodSortButton.selected = YES;
                    }
                    break;
                    
                case FoodSortCafeButtonTag:
                    if (FoodSortButtonState & FoodSortStateSelectedCafe)
                    {
                        foodSortButton.selected = YES;
                    }
                    break;
                case FoodSortBarButtonTag:
                    if (FoodSortButtonState & FoodSortStateSelectedBar)
                    {
                        foodSortButton.selected = YES;
                    }
                    break;
                    
                default:
                    break;
            }
        }
    }
}

#pragma mark - create custom button
- (void)createButtonWithDatas:(NSArray *)datas superView:(UIView *)superView
{
    NSString *imageName;
    NSString *title;
    NSInteger buttonTag;
    NSInteger count = 0;
    for (NSDictionary *buttonDataDict in datas)
    {
        imageName = buttonDataDict[ButtonDataImageNameKey];
        title = buttonDataDict[ButtonDataTitleKey];
        buttonTag = [buttonDataDict[ButtonDataTagKey] integerValue];
        [self createButton:imageName
                     title:title
                   spacing:6.0f
                 superView:superView
             howManyNumber:count
                 buttonTag:buttonTag
         ];
        count += 1;
    }
}

- (void)createButton:(NSString *)imageName title:(NSString *)title spacing:(CGFloat)spacing superView:(UIView *)superView howManyNumber:(NSInteger)number buttonTag:(SortButtonTag)buttonTag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleColor:[FIUtilities createKeyColor] forState:UIControlStateSelected];
    
    CGSize titleLabelSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
    
    CGFloat superViewWidth = superView.frame.size.width;
    CGFloat superViewHeight = superView.frame.size.height;
    
    CGFloat buttonBgImageSideLength = superViewHeight - titleLabelSize.height - spacing;
    CGFloat buttonOffestX = (superViewWidth / 2.0f) - (buttonBgImageSideLength / 2.0f);
    
    button.frame = CGRectMake(number * buttonOffestX, 0, buttonBgImageSideLength, buttonBgImageSideLength);
    
    
    CGFloat buttonTitleTopInset = buttonBgImageSideLength + spacing;
    CGFloat buttonTitleLeftInset = (buttonBgImageSideLength / 2.0f) - (titleLabelSize.width / 2.0f);
    
    [button setTitleEdgeInsets:UIEdgeInsetsMake(buttonTitleTopInset, buttonTitleLeftInset, 0.0f, 0.0f)];
    
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateSelected];
    
    [button setBackgroundTintColor:[FIUtilities createGrayColor] forState:UIControlStateNormal];
    [button setBackgroundTintColor:[FIUtilities createKeyColor] forState:UIControlStateSelected];
    
    button.tag = buttonTag;
    
    [button addTarget:self action:@selector(clickFoodSortButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [superView addSubview:button];
}



#pragma mark - click button method
//sorting button
- (void)clickFoodSortButton:(UIButton *)sender
{
    _isSelectedSortButton = YES;
    if ([sender isSelected] == NO)
    {
        sender.selected = YES;
        
        switch (sender.tag)
        {
            case FoodSortkoreaButtonTag:
                _foodSortButtonStateTemp = _foodSortButtonStateTemp | FoodSortStateSelectedKorea;
                break;
                
            case FoodSortJapanButtonTag:
                _foodSortButtonStateTemp = _foodSortButtonStateTemp | FoodSortStateSelectedJapan;
                break;
                
            case FoodSortChinaButtonTag:
                _foodSortButtonStateTemp = _foodSortButtonStateTemp | FoodSortStateSelectedChina;
                break;
                
            case FoodSortAmericaButtonTag:
                _foodSortButtonStateTemp = _foodSortButtonStateTemp | FoodSortStateSelectedAmerica;
                break;
                
            case FoodSortCafeButtonTag:
                _foodSortButtonStateTemp = _foodSortButtonStateTemp | FoodSortStateSelectedCafe;
                break;
                
            case FoodSortBarButtonTag:
                _foodSortButtonStateTemp = _foodSortButtonStateTemp | FoodSortStateSelectedBar;
                break;
                
            default:
                break;
        }
    } else
    {
        sender.selected = NO;
        
        switch (sender.tag)
        {
            case FoodSortkoreaButtonTag:
                _foodSortButtonStateTemp = _foodSortButtonStateTemp - FoodSortStateSelectedKorea;
                break;
                
            case FoodSortJapanButtonTag:
                _foodSortButtonStateTemp = _foodSortButtonStateTemp - FoodSortStateSelectedJapan;
                break;
                
            case FoodSortChinaButtonTag:
                _foodSortButtonStateTemp = _foodSortButtonStateTemp - FoodSortStateSelectedChina;
                break;
                
            case FoodSortAmericaButtonTag:
                _foodSortButtonStateTemp = _foodSortButtonStateTemp - FoodSortStateSelectedAmerica;
                break;
                
            case FoodSortCafeButtonTag:
                _foodSortButtonStateTemp = _foodSortButtonStateTemp - FoodSortStateSelectedCafe;
                break;
                
            case FoodSortBarButtonTag:
                _foodSortButtonStateTemp = _foodSortButtonStateTemp - FoodSortStateSelectedBar;
                break;
                
            default:
                break;
        }
    }
}

//request button
- (IBAction)clickSortRequestButton:(UIButton *)sender
{
    [self setFoodSortParam];
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:OrderingParamValue forKey:ParamNameReviewOrderingeKey];
    
    if (_foodSortParamValue != nil &&
        ![_foodSortParamValue isEqualToString:@""])
    {
        [paramDict setObject:_foodSortParamValue forKey:ParamNameTagskey];
    }
    
    [[FIDataManager sharedManager] setRestaurantSortingParamDict:paramDict];
    
    UITabBarController *tabBarVC = (UITabBarController *)self.parentViewController;
    UINavigationController *naviVC = (UINavigationController *)[tabBarVC.viewControllers objectAtIndex:0];
    HomeViewController *homeVC = [naviVC.viewControllers objectAtIndex:0];
    
    [FIRequestObject requestRestaurantList:paramDict
                           pagingURLString:nil
                                  isPaging:NO
                                  isSearch:NO
                 didReceiveUpdateDataBlock:homeVC.didReceiveUpdateDataBlock];
    
    
    [self removeSortViewController];
}


//ordering button
- (IBAction)clickOrderingButton:(UIButton *)sender
{
    if (sender.selected == NO)
    {//deSelecte
        for (NSInteger i = OrderNewButtonTag; i < OrderReviewButtonTag + 1; i++)
        {
            UIButton *buttton = (UIButton *)[self.view viewWithTag:i];
            buttton.selected = NO;
            buttton.layer.borderWidth = 0;
        }
        sender.selected = YES;
        sender.layer.borderWidth = 1;
        sender.layer.borderColor = [FIUtilities createKeyColor].CGColor;
        OrderButtonTag = sender.tag;
        [self setOrderingParamWithTag:OrderButtonTag];
    }
    return;
}
//dismiss
- (IBAction)clickDismissButton:(UIButton *)sender
{
    [self removeSortViewController];
}
- (void)removeSortViewController
{
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.70];
    _sortViewTopLayoutConstraint.constant = 0;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.view.backgroundColor = [UIColor clearColor];
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         [self removeFromParentViewController];
                         [self willMoveToParentViewController:nil];
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                     }];
}

#pragma mark - custom method
- (void)setOrderingParamWithTag:(NSInteger)tag
{
    switch (tag)
    {
        case OrderNewButtonTag:
            OrderingParamValue = ParamValueNewOrder;
            break;
            
        case OrderAvgButtonTag:
            OrderingParamValue = ParamValueReviewAverageOrder;
            break;
            
        case OrderLikeButtonTag:
            OrderingParamValue = ParamValueFavoriteOrder;
            break;
            
        case OrderReviewButtonTag:
            OrderingParamValue = ParamValueReviewCountOrder;
            break;
            
        default:
            NSLog(@"empty ordering button tag");
            return;
            break;
    }
}

- (void)setFoodSortParam
{
    
    if (_isSelectedSortButton == YES)
    {//변화 o
        FoodSortButtonState = _foodSortButtonStateTemp;
    }
    
    if (FoodSortButtonState != 0)
    {//변화 x 기존 o
        if (FoodSortButtonState & FoodSortStateSelectedKorea)
        {
            [_foodSortParamValue appendString:@"한식,"];
        }
        if (FoodSortButtonState & FoodSortStateSelectedJapan)
        {
            [_foodSortParamValue appendString:@"일식,"];
        }
        if (FoodSortButtonState & FoodSortStateSelectedChina)
        {
            [_foodSortParamValue appendString:@"중식,"];
        }
        if (FoodSortButtonState & FoodSortStateSelectedAmerica)
        {
            [_foodSortParamValue appendString:@"양식,"];
        }
        if (FoodSortButtonState & FoodSortStateSelectedCafe)
        {
            [_foodSortParamValue appendString:@"카페,"];
        }
        if (FoodSortButtonState & FoodSortStateSelectedBar)
        {
            [_foodSortParamValue appendString:@"주점,"];
        }
        [_foodSortParamValue deleteCharactersInRange:NSMakeRange(_foodSortParamValue.length - 1, 1)];
    }
}

@end
