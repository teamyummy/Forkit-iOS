//
//  CustomTableViewCell.m
//  Forkit
//
//  Created by Nexus_MYT on 2016. 11. 28..
//  Copyright © 2016년 david. All rights reserved.
//

#import "RestaurantListCell.h"

@implementation RestaurantListCell

/// 스토리 보드를 쓰는 경우에만 이 메서드 사용할 것
- (void)awakeFromNib
{
    self.layer.cornerRadius = 2.5;
    [super awakeFromNib];
}

/*
/// 코드로 생성하는 경우, 이 메서드 사용할 것
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self createView];
    }
    
    return self;
}

- (void)createView {
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = self.bounds;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.imageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(0, 0, 100, 30);
    [self.contentView addSubview:self.titleLabel];
}
*/
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
