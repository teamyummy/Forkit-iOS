//
//  CustomTableViewCell.h
//  Forkit
//
//  Created by Nexus_MYT on 2016. 11. 28..
//  Copyright © 2016년 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantListCell : UITableViewCell

/*
@property UIImageView *RestaurantImageView;
/// CustomTitleLabel 을 상속받아 사용 가능
@property UILabel *RestaurantTitleLabel;
*/
@property (weak, nonatomic) IBOutlet UILabel *RestaurantTitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *RestaurantImageView;
@property (weak, nonatomic) IBOutlet UILabel *RestaurantAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *RestaurantScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *RestaurantReviewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *RestaurantLikeCountLabel;

@end
