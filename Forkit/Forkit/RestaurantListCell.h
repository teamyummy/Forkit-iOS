//
//  CustomTableViewCell.h
//  Forkit
//
//  Created by Nexus_MYT on 2016. 11. 28..
//  Copyright © 2016년 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomUIView.h"

@interface RestaurantListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *restaurantRoundView;
@property (weak, nonatomic) IBOutlet UILabel *restaurantTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImageView;
@property (weak, nonatomic) IBOutlet UILabel *restaurantAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantReviewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantLikeCountLabel;

@end
