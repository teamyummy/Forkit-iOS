//
//  RestaurantListCollectionViewCell.h
//  Forkit
//
//  Created by david on 2016. 12. 11..
//  Copyright © 2016년 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantListCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *restaurantRoundView;
@property (weak, nonatomic) IBOutlet UILabel *restaurantTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImageView;
@property (weak, nonatomic) IBOutlet UILabel *restaurantAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantReviewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantLikeCountLabel;

@end
