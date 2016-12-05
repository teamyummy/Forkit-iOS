//
//  ReviewViewController.m
//  Forkit
//
//  Created by david on 2016. 12. 1..
//  Copyright © 2016년 david. All rights reserved.
//

#import "ReviewViewController.h"
#import <QBImagePickerController.h>

typedef NS_ENUM(NSInteger, ScoreButtonTag)
{
    OneScoreButton = 101,
    TwoScoreButton,
    ThreeScoreButton,
    FourScoreButton,
    FiveScoreButton
};


@interface ReviewViewController () <QBImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *selectedImageScrollView;
@property (weak, nonatomic) IBOutlet UITextView *reviewTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollConstraint;
@property NSMutableArray *testImageList;
@end

@implementation ReviewViewController

#pragma mark - App Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardDidShowNotification object:nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _scrollConstraint.constant = - 88;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_reviewTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Show Selected Image View
- (void)showSelectedImage
{
    if(self.testImageList != nil)
    {
        NSInteger i = 0;
        CGFloat pickerImageButtonWidth = 60;
        CGFloat superViewLeading = 12;
        CGFloat imageViewMargin = 8;
        CGFloat removeButtonSize = 24;
        
        CGFloat firstOffset = pickerImageButtonWidth + superViewLeading + imageViewMargin;
        CGFloat imageViewOffset = pickerImageButtonWidth + imageViewMargin;
        
        //set content size
        self.selectedImageScrollView.contentSize = CGSizeMake((self.testImageList.count * imageViewOffset) + firstOffset,
                                                              pickerImageButtonWidth);
        
        //show selected image
        for (UIImage *image in self.testImageList)
        {
            //selected image view
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i * imageViewOffset) + firstOffset,
                                                                                   0,
                                                                                   pickerImageButtonWidth,
                                                                                   pickerImageButtonWidth)];
            imageView.image = image;
            
            //removew button
            UIButton *selectedImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            selectedImageButton.frame = CGRectMake(imageView.frame.size.width - removeButtonSize,
                                                   0,
                                                   removeButtonSize,
                                                   removeButtonSize);
            
            [selectedImageButton setBackgroundImage:[UIImage imageNamed:@"dummyImage"]
                                           forState:UIControlStateNormal];
            
            [selectedImageButton addTarget:self
                                    action:@selector(clickRemoveSelectedImageButton:)
                          forControlEvents:UIControlEventTouchUpInside];
            selectedImageButton.tag = i;
            
            [imageView addSubview:selectedImageButton];
            i += 1;
            imageView.userInteractionEnabled = YES;
            [self.selectedImageScrollView addSubview:imageView];
        }
    }else
    {
        for (UIView *view in self.selectedImageScrollView.subviews)
        {
            if([view isKindOfClass:[UIImageView class]])
            {
                [view removeFromSuperview];
            }
        }
        return;
    }
}

#pragma mark - keyboard Notification Method
-(void)keyboardOnScreen:(NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    NSValue *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _scrollConstraint.constant = keyboardFrame.size.height - 12;
        
    }];
}

#pragma mark - Button Method

//show image picker view
- (IBAction)clickShowImagePickerButton:(UIButton *)sender
{
    self.testImageList = nil;
    
    QBImagePickerController *imagePickerController = [QBImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.maximumNumberOfSelection = 6;
    
    [self presentViewController:imagePickerController animated:YES completion:^{
        
    }];
}

//dissmiss self
- (IBAction)clickRemoveFromParentViewController:(id)sender
{
    self.parentViewController.tabBarController.tabBar.hidden = NO;
    [_reviewTextView endEditing:YES];
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.view.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self removeFromParentViewController];
                     }];
}

- (IBAction)clickScoreButton:(UIButton *)sender
{
    if ([sender isSelected] == YES && sender.tag < FiveScoreButton)
    {//selected
        for (NSInteger i = sender.tag + 1; i < FiveScoreButton + 1; i++)
        {
            UIButton *previousButton = (UIButton *)[self.view viewWithTag:i];
            if ([previousButton isSelected] == YES)
            {
                previousButton.selected = NO;
            } else
            {
                return;
            }
        }
        return;
    } else
    {//deSelected
        for (NSInteger i = OneScoreButton; i <= sender.tag; i++)
        {
            UIButton *checkedButton = (UIButton *)[self.view viewWithTag:i];
            
            if ([checkedButton isSelected] == NO)
            {
                checkedButton.selected = YES;
            }
        } return;
    }
}

#pragma mark - QBImagePicker Delegate
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    [self showSelectedImage];
}

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets
{
    PHImageManager *manager = [PHImageManager defaultManager];
    self.testImageList = [NSMutableArray arrayWithCapacity:[assets count]];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode =  PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    
    // assets contains PHAsset objects.
    __weak ReviewViewController *weakSelf = self;
    __block UIImage *blockImage;
    
    for (PHAsset *asset in assets)
    {
        [manager requestImageForAsset:asset
                           targetSize:CGSizeMake(300, 200)
                          contentMode:PHImageContentModeDefault
                              options:options
                        resultHandler:^void(UIImage *image, NSDictionary *info) {
                            
                            blockImage = image;
                            
                            [weakSelf.testImageList addObject:blockImage];
                        }];
    }
    
    
    [imagePickerController dismissViewControllerAnimated:YES completion:^{
        
        [self showSelectedImage];
        NSLog(@"%@",weakSelf.testImageList);
        
    }];
}

- (void)clickRemoveSelectedImageButton:(UIButton *)sender
{
    if ([sender isKindOfClass:[UIButton class]])
    {
        NSInteger removeIndex = sender.tag;

        [self.testImageList removeObjectAtIndex:removeIndex];
        
        for (UIView *view in self.selectedImageScrollView.subviews)
        {
            if([view isKindOfClass:[UIImageView class]])
            {
                [view removeFromSuperview];
            }
        }
        [self showSelectedImage];
    }
    return;
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