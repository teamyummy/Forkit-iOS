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

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UIView *scoreView;

@end

@interface RestaurantDetailInfoCell : RestaurantDetailCell

@property (weak, nonatomic) IBOutlet UIScrollView *reviewPhotoScrollView;

@end

@interface RestaurantDetailReviewTitleCell : RestaurantDetailCell

@property (weak, nonatomic) IBOutlet UILabel *reviewCountLabel;

@end

@interface RestaurantDetailReviewCell : RestaurantDetailCell

@property (weak, nonatomic) IBOutlet UIImageView *reviewProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *reviewIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewTextLabel;

@end

@interface MenuCell : RestaurantDetailCell

@property (weak, nonatomic) IBOutlet UIImageView *menuImageView;
@property (weak, nonatomic) IBOutlet UILabel *menuNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *menuCostLabel;

@end
