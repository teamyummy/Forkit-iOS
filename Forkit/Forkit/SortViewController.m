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
    OrderAvgButtonTag = 100,
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
    FoodSortStateSelectedBar        = 1 << 5,
};

//param value
static NSString *const ParamValueReviewAverageOrder = @"-review_average,-pk";
static NSString *const ParamValueReviewCountOrder = @"-review_count,-pk";
static NSString *const ParamValueFavoriteOrder= @"-total_like,-pk";
static NSString *const ParamValueNewOrder= @"-pk,-pk";

//button data key
static NSString *const ButtonDataImageNameKey = @"imageName";
static NSString *const ButtonDataTitleKey = @"title";
static NSString *const ButtonDataTagKey = @"tag";


@interface SortViewController ()

//UI component
@property (weak, nonatomic) IBOutlet UIView *sortView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sortViewTopLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIView *foodSortViewUp;
@property (weak, nonatomic) IBOutlet UIView *foodSortViewDown;

//sort request parameter
@property NSString *orderingParamValue;
@property FoodSortState foodSortOption;
@property NSMutableString *foodSortParamValue;

@end

@implementation SortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _orderingParamValue = nil;
    _foodSortOption = 0;
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
    if ([sender isSelected] == NO)
    {
        sender.selected = YES;
        
        switch (sender.tag)
        {
            case FoodSortkoreaButtonTag:
                _foodSortOption = _foodSortOption | FoodSortStateSelectedKorea;
                break;
                
            case FoodSortJapanButtonTag:
                _foodSortOption = _foodSortOption | FoodSortStateSelectedJapan;
                break;
                
            case FoodSortChinaButtonTag:
                _foodSortOption = _foodSortOption | FoodSortStateSelectedChina;
                break;
                
            case FoodSortAmericaButtonTag:
                _foodSortOption = _foodSortOption | FoodSortStateSelectedAmerica;
                break;
                
            case FoodSortCafeButtonTag:
                _foodSortOption = _foodSortOption | FoodSortStateSelectedCafe;
                break;
                
            case FoodSortBarButtonTag:
                _foodSortOption = _foodSortOption | FoodSortStateSelectedBar;
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
                _foodSortOption = _foodSortOption - FoodSortStateSelectedKorea;
                break;
                
            case FoodSortJapanButtonTag:
                _foodSortOption = _foodSortOption - FoodSortStateSelectedJapan;
                break;
                
            case FoodSortChinaButtonTag:
                _foodSortOption = _foodSortOption - FoodSortStateSelectedChina;
                break;
                
            case FoodSortAmericaButtonTag:
                _foodSortOption = _foodSortOption - FoodSortStateSelectedAmerica;
                break;
                
            case FoodSortCafeButtonTag:
                _foodSortOption = _foodSortOption - FoodSortStateSelectedCafe;
                break;
                
            case FoodSortBarButtonTag:
                _foodSortOption = _foodSortOption - FoodSortStateSelectedBar;
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
    
    if (_orderingParamValue != nil &&
        ![_orderingParamValue isEqualToString:@""])
    {
        [paramDict setObject:_orderingParamValue forKey:ParamNameReviewOrderingeKey];
    } else
    {
        [paramDict setObject:ParamValueNewOrder forKey:ParamNameReviewOrderingeKey];
    }
    
    if (_foodSortParamValue != nil &&
        ![_foodSortParamValue isEqualToString:@""])
    {
        [paramDict setObject:_foodSortParamValue forKey:ParamNameTagskey];
    }
    
    UITabBarController *tabBarVC = (UITabBarController *)self.parentViewController;
    UINavigationController *naviVC = (UINavigationController *)[tabBarVC.viewControllers objectAtIndex:0];
    HomeViewController *homeVC = [naviVC.viewControllers objectAtIndex:0];
    
    [FIRequestObject requestRestaurantList:paramDict pagingURLString:nil didReceiveUpdateDataBlock:homeVC.didReceiveUpdateDataBlock];
    
    
    [self removeSortViewController];
}


//ordering button
- (IBAction)clickOrderingButton:(UIButton *)sender
{
    if (sender.selected == NO)
    {//deSelecte
        for (NSInteger i = OrderAvgButtonTag; i < OrderReviewButtonTag + 1; i++)
        {
            UIButton *buttton = (UIButton *)[self.view viewWithTag:i];
            buttton.selected = NO;
            buttton.layer.borderWidth = 0;
        }
        sender.selected = YES;
        sender.layer.borderWidth = 1;
        sender.layer.borderColor = [FIUtilities createKeyColor].CGColor;
        [self setOrderingParamWithTag:sender.tag];
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
        case OrderAvgButtonTag:
            _orderingParamValue = ParamValueReviewAverageOrder;
            break;
            
        case OrderLikeButtonTag:
            _orderingParamValue = ParamValueFavoriteOrder;
            break;
            
        case OrderReviewButtonTag:
            _orderingParamValue = ParamValueReviewCountOrder;
            break;
            
        default:
            NSLog(@"empty ordering button tag");
            return;
            break;
    }
}

- (void)setFoodSortParam
{
    if (_foodSortOption != 0)
    {
        
        if (_foodSortOption & FoodSortStateSelectedKorea)
        {
            [_foodSortParamValue appendString:@"한식,"];
        }
        if (_foodSortOption & FoodSortStateSelectedJapan)
        {
            [_foodSortParamValue appendString:@"일식,"];;
        }
        if (_foodSortOption & FoodSortStateSelectedChina)
        {
            [_foodSortParamValue appendString:@"중식,"];;
        }
        if (_foodSortOption & FoodSortStateSelectedAmerica)
        {
            [_foodSortParamValue appendString:@"양식,"];;
        }
        if (_foodSortOption & FoodSortStateSelectedCafe)
        {
            [_foodSortParamValue appendString:@"카페,"];;
        }
        if (_foodSortOption & FoodSortStateSelectedBar)
        {
            [_foodSortParamValue appendString:@"주점,"];;
        }
        [_foodSortParamValue deleteCharactersInRange:NSMakeRange(_foodSortParamValue.length - 1, 1)];
    }
}

@end
