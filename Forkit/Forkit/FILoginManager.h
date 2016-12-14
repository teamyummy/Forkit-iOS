//
//  FILoginManager.h
//  Forkit
//
//  Created by david on 2016. 11. 28..
//  Copyright © 2016년 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FILoginManager : NSObject

///로그인 토큰(키체인 사용)
@property (nonatomic) NSString *loginToken;

///사용자 아이디(키체인 사용)
@property (nonatomic) NSString *userId;

///singleton method
+ (instancetype)sharedManager;

///로그인 상태 저장 (자동로그인)
+ (void)setLoginState;

///로그인 상태 여부
+ (BOOL)isOnLogin;

///로그인 상태 제거
+ (void)removeLoginState;

///로그인 토큰 제거
- (void)removeLoginToken;

///사용자 아이디 제거
- (void)removeUserId;

@end
