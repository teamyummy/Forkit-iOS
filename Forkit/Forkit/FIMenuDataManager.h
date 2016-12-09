//
//  FIMenuDataManager.h
//  Forkit
//
//  Created by david on 2016. 12. 7..
//  Copyright © 2016년 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FIMenuDataManager : NSObject

@property (nonatomic) NSMutableArray *menuDatas;

+ (instancetype)sharedManager;

@end
