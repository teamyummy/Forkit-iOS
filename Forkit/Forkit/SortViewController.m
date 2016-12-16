//
//  SortViewController.m
//  Forkit
//
//  Created by david on 2016. 12. 16..
//  Copyright © 2016년 david. All rights reserved.
//

#import "SortViewController.h"
typedef NS_ENUM(NSInteger, sortButton)
{
    OrderAvgButton = 100,
    OrderLikeButton,
    OrderReviewButton,
    FoodSortkoreaButton,
    FoodSortJapanButton,
    FoodsortChinaBUtton,
    FoodAmericaButton,
    FoodCafeButton,
    FoodBarButton
};

static NSString *const ButtonDataKeyImageName = @"imageName";
static NSString *const ButtonDataKeyTitle = @"title";

@interface SortViewController ()
@property (weak, nonatomic) IBOutlet UIView *sortView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sortViewTopLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIView *foodSortViewUp;
@property (weak, nonatomic) IBOutlet UIView *foodSortViewDown;

@end

@implementation SortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *sortButtonData = @[@{ButtonDataKeyImageName : @"dummyImage",
                                  ButtonDataKeyTitle : @"한식"}
                                ,@{ButtonDataKeyImageName : @"dummyImage",
                                   ButtonDataKeyTitle : @"일식"}
                                ,@{ButtonDataKeyImageName : @"dummyImage",
                                   ButtonDataKeyTitle : @"중식"}];
    
    [self createButtonWithDatas:sortButtonData
                      superView:_foodSortViewUp];
    
    sortButtonData = @[@{ButtonDataKeyImageName : @"dummyImage",
                         ButtonDataKeyTitle : @"양식"}
                       ,@{ButtonDataKeyImageName : @"dummyImage",
                          ButtonDataKeyTitle : @"카페"}
                       ,@{ButtonDataKeyImageName : @"dummyImage",
                          ButtonDataKeyTitle : @"주점"}];
    
    [self createButtonWithDatas:sortButtonData
                      superView:_foodSortViewDown];
    // Do any additional setup after loading the view.
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

- (void)createButtonWithDatas:(NSArray *)datas superView:(UIView *)superView
{
    NSString *imageName;
    NSString *title;
    NSInteger count = 0;
    for (NSDictionary *buttonDataDict in datas)
    {
        imageName = buttonDataDict[ButtonDataKeyImageName];
        title = buttonDataDict[ButtonDataKeyTitle];
        [self createButton:imageName
                     title:title
                   spacing:6.0f
                 superView:superView
             howManyNumber:count];
        count += 1;
    }
}

- (void)createButton:(NSString *)imageName title:(NSString *)title spacing:(CGFloat)spacing superView:(UIView *)superView howManyNumber:(NSInteger)number
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
    [button setBackgroundImage:[UIImage imageNamed:@"dummyFoodImage"] forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(clickFoodSortButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [superView addSubview:button];
}

- (void)clickFoodSortButton:(UIButton *)sender
{
    NSLog(@"button clicked");
    
    if ([sender isSelected] == NO)
    {
        sender.selected = YES;
    } else
    {
        sender.selected = NO;
    }
    
}

#pragma mark - Make Custom button
- (void)createCustomButtom:(UIButton *)button title:(NSString *)title imageName:(UIImage *)imageName{
    /*
    [button setImage:imageName forState:UIControlStateNormal];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    
    CGFloat spacing = 4.0;
    CGSize imageSize = button.imageView.image.size;
    
    //CGFloat top, CGFloat left, CGFloat bottom, CGFloat right
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
    
    button.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height), 0.0, 0.0, - titleSize.width);
    
    CGFloat edgeOffset = fabs(titleSize.height - imageSize.height) / 2.0;
    button.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0.0, edgeOffset, 0.0);
     */
    
}

- (IBAction)clickSortDetailButton:(UIButton *)sender
{
    if (sender.selected == NO)
    {//deSelecte
        for (NSInteger i = 100; i < 103; i++)
        {
            UIButton *buttton = (UIButton *)[self.view viewWithTag:i];
            buttton.selected = NO;
            buttton.layer.borderWidth = 0;
        }
        sender.selected = YES;
        sender.layer.borderWidth = 1;
        sender.layer.borderColor = [FIUtilities createKeyColor].CGColor;
    }
    return;
}
- (IBAction)clickDismissButton:(UIButton *)sender
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
