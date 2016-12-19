//
//  FISearchManager.h
//  Forkit
//
//  Created by david on 2016. 12. 19..
//  Copyright © 2016년 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FISearchManager : NSObject

@property (nonatomic,readonly) NSMutableArray *searchShopDatas;

+ (instancetype)sharedManager;

- (void)setSearchShopDatas:(NSMutableArray *)searchShopDatas;

@end
