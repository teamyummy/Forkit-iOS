//
//  FIUtilities.m
//  Forkit
//
//  Created by david on 2016. 11. 28..
//  Copyright © 2016년 david. All rights reserved.
//

#import "FIUtilities.h"

@implementation FIUtilities

#pragma mark - Format Exchanger

+ (NSString *)changeCurrencyFormatFromNumber:(NSInteger)price {
    return [FIUtilities changeCurrencyFormatFromNumber:price];
}

+ (NSString *)changeCurrencyFormatFromNumber:(NSInteger)price withCurrencyCode:(NSString *)currencyCode {
    NSString *priceNotFormatted = [NSString stringWithFormat:@"%ld", price];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    
    // 통화 코드가 nil 이면 한국 통화코드를 초기값으로 설정
    if (currencyCode == nil) currencyCode = @"KRW";
    numberFormatter.currencyCode = currencyCode;
    NSString *priceFormatted = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[priceNotFormatted floatValue]]];
    
    return priceFormatted;
}

+ (UIColor *)createKeyColor
{
    UIColor *keyColor = UIColorFromRGB(0xEF534F);
    return keyColor;
}

+ (UIColor *)createGrayColor
{
    UIColor *grayColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.54];
    return grayColor;
}
@end
