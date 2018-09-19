//
//  HPPayment.h
//  DZTakeout
//
//  Created by HuangPan on 2018/6/25.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  支付快捷入口
 *
 *  1.请预先导入UPPayPlugin|Alipay|WechatSDK三种对应的sdk包并且申请帐号ID
 *  2.微信的初始化动作需要在setUpPayment中设置，请在.m文件中修改绑定的appId
 *  3.所有后台流程都是生成订单ID，通过ID获取对应渠道的支付订单
 */
@interface HPPayment : NSObject

/**
 *  在应用程序启动的时候需要调用本方法进行初始化动作
 */
+ (void)setUpPayment;

/**
 *  支付回调，请在appdelegate中对应位置加入
 */
+ (BOOL)handleOpenURL:(NSURL *)url;
/**
 *  支付回调，请在appdelegate中对应位置加入
 */
+ (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

/**
 *  支付回调，请在appdelegate中对应位置加入
 */
+ (BOOL)openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options;

/**
 *  进行微信支付
 */
+ (void)doWeChatPayWayForOrder:(id)orderId complete:(void(^)(BOOL isSuccess, NSString * info))completion;
@end
