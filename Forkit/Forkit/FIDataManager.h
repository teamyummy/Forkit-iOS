//
//  FIDataManager.h
//  Forkit
//
//  Created by david on 2016. 11. 28..
//  Copyright © 2016년 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FIReviewDataManager.h"
#import "FIMenuDataManager.h"
#import "FILoginManager.h"

@interface FIDataManager : NSObject

@property (nonatomic) NSMutableArray *shopDatas;

+ (instancetype)sharedManager;

@end
