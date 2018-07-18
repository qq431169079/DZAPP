//
//  HPPayment.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/25.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "HPPayment.h"
#import "HPWeChatPayment.h"

static NSString * const HPWeChatPaymentKey  =   @"wx932fb18d44e00508";

@implementation HPPayment

+ (void)setUpPayment {
    //微信支付
    [WXApi registerApp:HPWeChatPaymentKey];
}

+ (BOOL)handleOpenURL:(NSURL *)url {
    return [self handleOpenURLActions:url];
}

+ (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self handleOpenURLActions:url];
}

+ (BOOL)openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    return [self handleOpenURLActions:url];
}

+ (BOOL)handleOpenURLActions:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:[HPWeChatPayment sharedInstance]];
}

+ (void)doWeChatPayWayForOrder:(id)orderId complete:(void(^)(BOOL isSuccess, NSString * info)) completion {
    [[HPWeChatPayment sharedInstance] doPayWithOrderId:orderId completion:completion];
}
@end
