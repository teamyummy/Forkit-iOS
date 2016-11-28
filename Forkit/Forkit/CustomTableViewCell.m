//
//  CustomTableViewCell.m
//  Forkit
//
//  Created by Nexus_MYT on 2016. 11. 28..
//  Copyright © 2016년 david. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

/// 스토리 보드를 쓰는 경우에만 이 메서드 사용할 것
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

/// 코드로 생성하는 경우, 이 메서드 사용할 것
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self createView];
    }
    
    return self;
}

- (void)createView {
    self.customImageView = [[UIImageView alloc] init];
    self.customImageView.frame = self.bounds;
    self.customImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.customImageView];
    
    self.customTitleLabel = [[UILabel alloc] init];
    self.customTitleLabel.frame = CGRectMake(0, 0, 100, 30);
    [self.contentView addSubview:self.customTitleLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
