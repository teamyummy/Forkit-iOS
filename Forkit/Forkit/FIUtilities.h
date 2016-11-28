//
//  FIUtilities.h
//  Forkit
//
//  Created by david on 2016. 11. 28..
//  Copyright © 2016년 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FIUtilities : NSObject

/// 입력된 금액을 통화 스타일의 문자열로 변환해주는 메서드
+ (NSString *)changeCurrencyFormatFromNumber:(NSInteger)price;
+ (NSString *)changeCurrencyFormatFromNumber:(NSInteger)price withCurrencyCode:(NSString *)currencyCode;

@end
