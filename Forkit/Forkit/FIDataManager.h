//
//  FIDataManager.h
//  Forkit
//
//  Created by david on 2016. 11. 28..
//  Copyright © 2016년 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FIReviewDataManager.h"
#import "FISearchManager.h"
#import "FIMenuDataManager.h"
#import "FILoginManager.h"

@interface FIDataManager : NSObject

@property (nonatomic) NSMutableDictionary *shopDataDict;
@property (nonatomic) NSMutableArray *shopDatas;
@property (nonatomic) NSMutableDictionary *shopDetailData;

+ (instancetype)sharedManager;
- (void)setShopDataDict:(NSMutableDictionary *)shopDataDict isPaging:(BOOL)isPaging;
- (void)setShopDetailData:(NSMutableDictionary *)shopDetailData;

@end
