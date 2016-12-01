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
@property (weak, nonatomic) IBOutlet UIButton *clickPresentReviewButton;

@end

@interface RestaurantDetailInfoCell : RestaurantDetailCell

@property (weak, nonatomic) IBOutlet UIScrollView *reviewPhotoScrollView;

@end

@interface RestaurantDetailReviewCell : RestaurantDetailCell

@property (weak, nonatomic) IBOutlet UIImageView *reviewProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *reviewIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewTextLabel;

@end
