//
//  FIRequestObject.h
//  Forkit
//
//  Created by david on 2016. 11. 28..
//  Copyright © 2016년 david. All rights reserved.
//

#import <Foundation/Foundation.h>
//PrimaryKey
typedef NSString PrimaryKey;
typedef void(^DidReceiveUpdateDataBlock)(void);

@interface FIRequestObject : NSObject

/**
 음식점 리스트(GET)
 @param paramDict 검색 or 정렬
 @param didReceiveUpdateDataBlock 다운로드 완료시 실행할 블럭
 */
+ (void)requestRestaurantList:(NSDictionary *)paramDict didReceiveUpdateDataBlock:(DidReceiveUpdateDataBlock)didReceiveUpdateDataBlock;

/**
 특정 음식점에 따른 리뷰 리스트(GET)
 @param restaurantPk 리스트 요청하고 싶은 특정 음식점 primary key
 @param didReceiveUpdateDataBlock 다운로드 완료시 실행할 블럭
 */
+ (void)requestReviewListWithRestaurantPk:(PrimaryKey *)restaurantPk didReceiveUpdateDataBlock:(DidReceiveUpdateDataBlock)didReceiveUpdateDataBlock;

/**
 특정 음식점에 따른 메뉴 리스트(GET)
 @param restaurantPk 리스트 요청하고 싶은 특정 음식점 primary key
 @param didReceiveUpdateDataBlock 다운로드 완료시 실행할 블럭
 */
+ (void)requestMenuListWithRestaurantPk:(PrimaryKey *)restaurantPk didReceiveUpdateDataBlock:(DidReceiveUpdateDataBlock)didReceiveUpdateDataBlock;

/**
 특정 리뷰를 삭제(DELETE)
 @param restaurantPk 음식점 primary key
 @param reviewPk 삭제하고자 하는 리뷰 primary key
 */
+ (void)requestDeleteReviewWithRestaurantPk:(PrimaryKey *)restaurantPk reviewPk:(PrimaryKey *)reviewPk;

/**
 리뷰 업로드(UPLOAD)
 @param restaurantPk 음식점 primary key
 @param image 리뷰 이미지
 @param contents 리뷰 내용
 @param score 음식점 점수
 */
+ (void)requestUploadReviewListWithRestaurantPk:(PrimaryKey *)restaurantPk image:(UIImage *)image contents:(NSString *)contents score:(NSInteger)score;

/**
 로그인(POST)
 @param userId 아이디
 @param userPw 비밀번호
 */
+ (void)requestLoginTokenWithUserId:(NSString *)userId userPw:(NSString *)userPw;

@end
