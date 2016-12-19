//
//  ReviewDetatilViewController.m
//  Forkit
//
//  Created by david on 2016. 12. 2..
//  Copyright © 2016년 david. All rights reserved.
//

#import "ReviewDetatilViewController.h"
#import "RestaurantDetailViewController.h"

@interface ReviewDetatilViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *containerScrollView;
@property (weak, nonatomic) IBOutlet UILabel *idTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIView *containerTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *reviewDeleteButton;

@end

@implementation ReviewDetatilViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([[[FILoginManager sharedManager] userId] isEqualToString:[_deatilReviewData objectForKey:JSONReviewAuthorKey]])
    {
        self.reviewDeleteButton.enabled = YES;
    } else
    {
        self.reviewDeleteButton.enabled = NO;
    }
    [self updateDetailReview];
}

- (void)updateDetailReview
{
    //id
    self.idTextLabel.text = [_deatilReviewData objectForKey:JSONReviewAuthorKey];
    
    //date
    self.dateLabel.text = [_deatilReviewData objectForKey:JSONCommonCreatedDateKey];
    
    //content
    self.contentTextView.text = [_deatilReviewData objectForKey:JSONReviewContentKey];
    [self.contentTextView sizeToFit];
    
    //detail image
    if ([_deatilReviewData objectForKey:JSONCommonImagesKey] != nil &&
        [[_deatilReviewData objectForKey:JSONCommonImagesKey] count] != 0)
    {
        NSArray *imageDatas = [_deatilReviewData objectForKey:JSONCommonImagesKey];
        [self createScrollViewWithImageArr:imageDatas];
    }
    
    //like score
    NSNumber *reviewScore = [_deatilReviewData objectForKey:JSONReviewScoreKey];
    
    for (NSInteger i = 1; i <= reviewScore.integerValue; i++)
    {
        UIButton *likeButton = (UIButton *)[self.view viewWithTag:i];
        likeButton.selected = YES;
    }
}


- (void)createScrollViewWithImageArr:(NSArray *)imageArr
{
    NSInteger countNumber = imageArr.count;
    
    NSInteger scrollViewHeight = _containerScrollView.frame.size.height;
    NSInteger superViewHeight = _contentTextView.contentSize.height;
    NSInteger superViewWidth = _containerTextView.frame.size.width;
    NSInteger basicHeight = 100;
    NSInteger imageViewHeight = 200;
    NSInteger margin = 8;
    
    if ((basicHeight + superViewHeight) + ((imageViewHeight + margin) * countNumber) > scrollViewHeight)
    {
        self.contentViewBottomConstraint.constant = (basicHeight + superViewHeight) + ((imageViewHeight + margin) * countNumber) - scrollViewHeight;
    }
    
    for (NSInteger i = 0; i < countNumber; i++)
    {
        NSDictionary *tempDict = imageArr[i];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0,
                                     (superViewHeight + margin) + ((imageViewHeight + margin) * i),
                                     superViewWidth,
                                     imageViewHeight);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [imageView sd_setImageWithURL:[tempDict objectForKey:JSONCommonBigImageURLKey]];
        imageView.userInteractionEnabled = YES;
        [_containerTextView addSubview:imageView];
    }
}

- (IBAction)clickPopButton:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickRemoveReviewButton:(UIBarButtonItem *)sender
{
    [self showAlert];
}

#pragma mark - Alert
- (void)showAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"리뷰 삭제"
                                                                   message:@"정말로 삭제 하시겠습니까?"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"삭제"
                                                       style:UIAlertActionStyleDestructive
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                         
                                                             [FIRequestObject requestDeleteReviewWithRestaurantPk:[_deatilReviewData objectForKey:JSONReviewRestaurantPrimaryKey] reviewPk:[_deatilReviewData objectForKey:JSONCommonPrimaryKey] didReceiveUpdateDataBlock:^{
                                                                 
                                                                 
                                                                 
                                                             }];
                                                         
                                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                                         [self.navigationController popViewControllerAnimated:NO];
                                                     }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
