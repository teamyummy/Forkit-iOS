//
//  CustomCollectionViewFlowLayout.m
//  Forkit
//
//  Created by Nexus_MYT on 2016. 11. 29..
//  Copyright © 2016년 david. All rights reserved.
//

#import "CustomCollectionViewFlowLayout.h"

@implementation CustomCollectionViewFlowLayout

- (instancetype)initWithItemSize:(CGSize)itemSize sectionInset:(UIEdgeInsets)sectionInset {
    self = [super init];
    if (self) {
        self.itemSize = itemSize;
        self.sectionInset = sectionInset;
    }
    return self;
}

@end
