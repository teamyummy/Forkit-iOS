//
//  RestaurantDetailTitleCell.m
//  Forkit
//
//  Created by david on 2016. 11. 30..
//  Copyright © 2016년 david. All rights reserved.
//

#import "RestaurantDetailCell.h"
#import "RestaurantDetailViewController.h"
#import "CustomUIView.h"

#pragma mark - Detail Cell Class
@implementation RestaurantDetailCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

#pragma mark - Title Cell Class
@interface RestaurantDetailTitleCell()
@property (weak, nonatomic) IBOutlet RoundView *likeRoundView;
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@end

@implementation RestaurantDetailTitleCell

#pragma mark - Life Cycle
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self updateScoreViewToCircleView];
}

#pragma mark - Click Button Method
- (IBAction)clickLikeButton:(UIButton *)sender
{
    if ([sender isSelected] == NO)
    {
        sender.selected = YES;
        _likeRoundView.layer.borderColor = [FIUtilities createKeyColor].CGColor;
        _likeImageView.image = [UIImage imageNamed:@"dummyFoodImage"];
        _likeLabel.textColor = [FIUtilities createKeyColor];
        
    } else
    {
        sender.selected = NO;
        _likeRoundView.layer.borderColor = [FIUtilities createGrayColor].CGColor;
        _likeImageView.image = [UIImage imageNamed:@"dummyImage"];
        _likeLabel.textColor = [UIColor blackColor];
    }
}

#pragma mark - Update View
- (void)updateScoreViewToCircleView
{
    CGFloat width = self.scoreView.frame.size.width;
    self.scoreView.layer.cornerRadius = width/2;
}

#pragma mark - Selected
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end

#pragma mark - Info Cell Class
@implementation RestaurantDetailInfoCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

#pragma mark - Deatail Title Cell Class
@implementation RestaurantDetailReviewTitleCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end

#pragma mark - Deatail Cell Class
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

#pragma mark - Menu Cell Class
@implementation MenuCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
