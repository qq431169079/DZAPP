//
//  DZStaticVariables.h
//  DZTakeout
//
//  Created by HuangPan on 2018/6/27.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 支付成功通知
extern NSString *kPaySuccessNotificationKey;

/// 支付取消通知
extern NSString *kPayCancelNotificationKey;

/// 支付失败通知
extern NSString *kPayFailureNotificationKey;

/// 订单号缓存key
extern NSString *kOrderNoCacheKey;

/// 订单id缓存key
extern NSString *kOrderIdCacheKey;

/// 外卖商家详情缓存key
extern NSString *kOrderDetailsCacheKey;

@interface DZStaticVariables : NSObject

@end
