//
//  HPIMManager.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/25.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "HPIMManager.h"
#import <libkern/OSAtomic.h>

/// 登录IM服务器重试次数
static int32_t ConnectIMRetryNumberKey = 0;

@implementation HPIMManager
+ (void)initWithAppKey:(NSString *)key {
    [[RCIM sharedRCIM] initWithAppKey:key];
}

+ (void)connectWithToken:(NSString *)token success:(void (^)(NSString *))successBlock error:(void (^)(RCConnectErrorCode))errorBlock tokenIncorrect:(void (^)(void))tokenIncorrectBlock {
    [[RCIM sharedRCIM] connectWithToken:token     success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        if (successBlock) { successBlock(userId); }
    } error:^(RCConnectErrorCode status) {
        
        switch (status) {
            case RC_CONN_PACKAGE_NAME_INVALID: {
                // BundleID不正确
            }
                break;
            case RC_CONN_APP_BLOCKED_OR_DELETED: {
                // App Key 被封禁或已删除,请检查您使用的 App Key 是否正确。
            }
                break;
            case RC_CONN_USER_BLOCKED: {
                // 请检查您使用的 Token 是否正确，以及对应的 UserId 是否被封禁。。
            }
                break;
            case RC_DISCONN_KICK: {
                // 当前用户在其他设备上登录，此设备被踢下线
            }
                break;
            case RC_CLIENT_NOT_INIT: {
                // SDK 没有初始化
            }
                break;
            case RC_INVALID_PARAMETER: {
                // 开发者接口调用时传入的参数错误
            }
                break;
            case RC_INVALID_ARGUMENT: {
                // 开发者接口调用时传入的参数错误
            }
                break;
            default: {
                if (ConnectIMRetryNumberKey < 3) {
                    OSAtomicIncrement32(&ConnectIMRetryNumberKey);
                    [self connectWithToken:token success:successBlock error:errorBlock tokenIncorrect:tokenIncorrectBlock];
                    return;
                }
            }
                break;
        }
        
        if (errorBlock) { errorBlock(status); }
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        if (tokenIncorrectBlock) { tokenIncorrectBlock(); }
    }];
}

@end
