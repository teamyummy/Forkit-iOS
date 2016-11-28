//
//  CustomCollectionViewFlowLayout.h
//  Forkit
//
//  Created by Nexus_MYT on 2016. 11. 29..
//  Copyright © 2016년 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewFlowLayout : UICollectionViewFlowLayout

/** itemSize: collectionView 의 셀 가로,세로 사이즈, ex) CGSizeMake(200, 200)
    sectionInset: 상하좌우 여백, ex) UIEdgeInsetsMake(0,8,0,8), 좌우 여백 8씩 들어감
 */
- (instancetype)initWithItemSize:(CGSize)itemSize sectionInset:(UIEdgeInsets)sectionInset;

@end
