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
typedef void(^DidReceiveSuccessLoginBlock)(void);
typedef void(^DidReceiveFailedLoginBlock)(void);

static NSString *const UpdateAllDatasNotification = @"updateAllDatasNotification";

@interface FIRequestObject : NSObject
/**
 음식점 리스트 간소화(GET)
 */
+ (void)requestRestaurantList;

/**
 음식점 리스트(GET)
 @param paramDict 검색 or 정렬
 @param pagingURLString page URL
 @param isPaging paging BOOL 값
 @param isSearch search BOOL 값
 @param didReceiveUpdateDataBlock 다운로드 완료시 실행할 블럭
 */
+ (void)requestRestaurantList:(NSDictionary *)paramDict pagingURLString:(NSString *)pagingURLString isPaging:(BOOL)isPaging isSearch:(BOOL)isSearch didReceiveUpdateDataBlock:(DidReceiveUpdateDataBlock)didReceiveUpdateDataBlock;

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
+ (void)requestDeleteReviewWithRestaurantPk:(PrimaryKey *)restaurantPk reviewPk:(PrimaryKey *)reviewPk isMypageVC:(BOOL)isMypageVC didReceiveUpdateDataBlock:(DidReceiveUpdateDataBlock)didReceiveUpdateDataBlock;

/**
 리뷰 업로드(UPLOAD)
 @param restaurantPk 음식점 primary key
 @param images 리뷰 이미지
 @param contents 리뷰 내용
 @param score 음식점 점수
 */
+ (void)requestUploadReviewListWithRestaurantPk:(PrimaryKey *)restaurantPk images:(NSArray *)images contents:(NSString *)contents score:(NSInteger)score didReceiveUpdateDataBlock:(DidReceiveUpdateDataBlock)didReceiveUpdateDataBlock;

/**
 로그인(POST)
 @param userId 아이디
 @param userPw 비밀번호
 @param success 성공 할 경우 블럭
 @param failed 실패 경우 블럭
 */
+ (void)requestLoginTokenWithUserId:(NSString *)userId userPw:(NSString *)userPw success:(DidReceiveSuccessLoginBlock)success failed:(DidReceiveFailedLoginBlock)failed;

/**
 나의 즐겨찾기 목록(GET)
 */
+ (void)requestMyFavorRestaurantList;

/**
 나의 리뷰 목록(GET)
 */
+ (void)requestMyRegisterReview;

/**
 즐겨찾기 등록, 삭제(POST)
 @param restaurantPk 음식점 pk
 @param likePk 즐겨찾기 pk
 */
+ (void)requestFavorRestaurantWithRestaurantPk:(PrimaryKey *)restaurantPk likePk:(PrimaryKey *)likePk;

/**
 특정 음식점 정보(GET)
 @param pk 음식점 pk
 @param didReceiveUpdateDataBlock 성공 할 경우 블럭
 */
+ (void)requestRestaurantDetailDataWithRestaurantPk:(PrimaryKey *)pk didReceiveUpdateDataBlock:(DidReceiveUpdateDataBlock)didReceiveUpdateDataBlock;
@end
