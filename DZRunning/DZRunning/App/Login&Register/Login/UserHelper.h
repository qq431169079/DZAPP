//
//  UserHelper.h
//  DiceGame
//
//  Created by HuangPan on 2017/10/22.
//  Copyright © 2017年 HuangPan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

extern NSString *const kUserLoginSuccessNotification;

@interface UserHelper : NSObject

/**
 *  当前用户是否已经登陆
 */
+ (BOOL)isUserLogin;

/**
 *  用户对象获取
 */
+ (UserModel *)userItem;

/**
 *  当前用户登录令牌｜如果未登录将返回nil
 */
+ (NSString *)userToken;

/**
 *  用户登出操作请调用此方法
 */
+ (void)logout;

/**
 初始化数据
 
 @param record 初始化用户
 */
+ (void)setUpWithRecord:(NSDictionary *)record;

/**
 暂时存储变量

 @param object 变量
 @param key key
 */
+ (void)temporaryCacheObject:(id)object forKey:(NSString *)key;

/**
 暂时存储变量
 
 @param key key
 */
+ (id)temporaryObjectForKey:(NSString *)key;

/**
 获取暂时存储变量，之后会被移除
 
 @param key key
 */
+ (id)removeTemporaryObjectForKey:(NSString *)key;

/**
 持久化数据

 @param key key
 */
+ (BOOL)persistentObjectForKey:(NSString *)key;

/**
 清楚所有的零食变量
 */
+ (void)cleanAllTemporaryObjects;
@end
