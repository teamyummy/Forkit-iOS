//
//  FIDataManager.h
//  Forkit
//
//  Created by david on 2016. 11. 28..
//  Copyright © 2016년 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FIDataManager : NSObject

@property NSMutableArray *shopDatas;

+ (instancetype)sharedManager;

- (NSArray *)searchName:(NSString *)name;

@end
