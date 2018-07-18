//
//  HPWeChatPayment.h
//  DZTakeout
//
//  Created by HuangPan on 2018/6/25.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface HPWeChatPayment : NSObject<WXApiDelegate>

+ (instancetype)sharedInstance;

/**
 *  执行微信支付
 *
 *  @param orderId    订单ID
 *  @param completion 完成回调
 */
- (void)doPayWithOrderId:(id)orderId completion:(void(^)(BOOL success, NSString * info))completion;

@end
