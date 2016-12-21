//
//  FIMyPageManager.h
//  Forkit
//
//  Created by david on 2016. 12. 14..
//  Copyright © 2016년 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FIMyPageManager : NSObject

@property (nonatomic) NSMutableArray *favorShop;
@property (nonatomic) NSMutableArray *reviewDatas;

+ (instancetype)sharedManager;
- (void)setFavorShop:(NSMutableArray *)favorShop;
- (void)setReviewDatas:(NSMutableArray *)reviewDatas;
@end
