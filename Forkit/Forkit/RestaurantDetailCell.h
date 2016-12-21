//
//  RestaurantDetailTitleCell.h
//  Forkit
//
//  Created by david on 2016. 11. 30..
//  Copyright © 2016년 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantDetailCell : UITableViewCell

@end

@interface RestaurantDetailTitleCell : RestaurantDetailCell

@property (weak, nonatomic) IBOutlet UILabel *restaurantTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UIView *scoreView;
@property (weak, nonatomic) IBOutlet UILabel *scoreAvgLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@end

@interface RestaurantDetailInfoCell : RestaurantDetailCell

@property (weak, nonatomic) IBOutlet UIScrollView *reviewPhotoScrollView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *operationHourLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkingInfoLabel;

@end

@interface RestaurantDetailReviewTitleCell : RestaurantDetailCell

@property (weak, nonatomic) IBOutlet UILabel *reviewCountLabel;

@end

@interface RestaurantDetailReviewCell : RestaurantDetailCell

@property (weak, nonatomic) IBOutlet UILabel *reviewIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewTextLabel;

@end

@interface MenuCell : RestaurantDetailCell

@property (weak, nonatomic) IBOutlet UIImageView *menuImageView;
@property (weak, nonatomic) IBOutlet UILabel *menuNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *menuCostLabel;

@end
