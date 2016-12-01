//
//  RestaurantDetailTitleCell.m
//  Forkit
//
//  Created by david on 2016. 11. 30..
//  Copyright © 2016년 david. All rights reserved.
//

#import "RestaurantDetailCell.h"

@implementation RestaurantDetailCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation RestaurantDetailTitleCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self updateScoreViewToCircleView];
}

- (void)updateScoreViewToCircleView
{
    CGFloat width = self.scoreView.frame.size.width;
    self.scoreView.layer.cornerRadius = width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



@end

@implementation RestaurantDetailInfoCell
- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

@implementation RestaurantDetailReviewCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.reviewTextLabel sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
