//
//  HPWeChatPayment.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/25.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "HPWeChatPayment.h"
#import "DZRequests.h"
#import "NSString+HPUtil.h"

static NSString *HPWeChatPaymentPartnerId = @"1507027841";
static NSString *HPWeChatSignKey = @"guangdongshengshenzhengshidongzi";

@interface HPWeChatPayment ()

@property (nonatomic, strong) void(^payCompletionBlock)(BOOL success, NSString * info);

@end

@implementation HPWeChatPayment

+ (instancetype)sharedInstance {
    static HPWeChatPayment * instance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[HPWeChatPayment alloc] init];
    });
    return instance;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if (self = [super init]) {
        [self _setUp];
    }
    return self;
}

- (void)_setUp {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)applicationBecomeActive:(NSNotificationCenter *) notification {
    if (self.payCompletionBlock) {
        self.payCompletionBlock(NO, @"如果已确定支付，请去个人中心查看订单状态");
        self.payCompletionBlock = nil;
    }
}

/**
 *  执行微信支付（适配“动致外卖”需求）
 *
 *  @param orderId    订单ID
 *  @param completion 完成回调
 */
- (void)doPayWithOrderId:(id)orderId completion:(void (^)(BOOL success, NSString *info))completion {
    if (!orderId) { return; }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"out_trade_no"] = orderId;
    params[@"body"] = [NSString stringWithFormat:@"订单:%@",orderId];
    params[@"wxpay"] = @"";
    params[@"attach"] = [NSString stringWithFormat:@"wx%@", orderId];
    [DZRequests post:@"API_POST_WECHAT_PAY"
          parameters:params.copy
             success:^(NSDictionary *record) {
                 if (record && [record count] > 0) {
                     NSString *stamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
                     //
                     PayReq* req             = [[PayReq alloc] init];
                     req.openID              = @"wx932fb18d44e00508";
                     req.partnerId           = HPWeChatPaymentPartnerId;
                     req.prepayId            = [record objectForKey:@"prepay_id"];
                     req.nonceStr            = [record objectForKey:@"nonce_str"];
                     req.timeStamp           = stamp.intValue;
                     req.package             = @"Sign=WXPay";
                     
                     req.sign                = [self signWithPayReq:req];
                     //
                     BOOL result = [WXApi sendReq:req];
                     if (!result && completion) {
                         completion(NO, @"无法访问微信!");
                     } else if (completion) {
                         self.payCompletionBlock = ^(BOOL success, NSString * info) {
                             dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
                                 sleep(1);
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     completion(success, info);
                                 });
                             });
                         };
                     }
                 } else if (completion) {
                     completion(NO, @"接口数据返回错误，请联系开发人员");
                 }
             } failure:^(HPRequestsError type, NSError *error) {
                 NSLog(@">>ERROR : 调用微信支付接口失败！%@", error);
                 if (completion) {
                     completion(NO,type == HPRequestsErrorServerError ? error.localizedDescription : @"接口调用失败");
                 }
             }];
}

- (NSString *)signWithPayReq:(PayReq *)req {
    NSMutableString *sign = [NSMutableString string];
    [sign appendString:@"appid=wx932fb18d44e00508&"];
    [sign appendString:[NSString stringWithFormat:@"noncestr=%@&",req.nonceStr]];
    [sign appendString:@"package=Sign=WXPay&"];
    [sign appendString:@"partnerid=1507027841&"];
    [sign appendString:[NSString stringWithFormat:@"prepayid=%@&",req.prepayId]];
    [sign appendString:[NSString stringWithFormat:@"timestamp=%zd&",req.timeStamp]];
    [sign appendString:@"key=guangdongshengshenzhengshidongzi"];
    return [sign.copy md5].uppercaseString;
}

/**
 *  执行微信支付(标准实现)
 *
 *  @param orderId    订单ID
 *  @param completion 完成回调
- (void)doPayWithOrderId:(id)orderId completion:(void (^)(BOOL success, NSString *info))completion {
    [HPRequests post:@"API_POST_WECHAT_PAY"
          parameters:@{@"orderId":orderId, @"token":[UserHelper userToken]}
             success:^(NSDictionary *record) {
                 if (record && [record count] > 0) {
                     NSMutableString * stamp  = [record objectForKey:@"timestamp"];
                     //
                     PayReq* req             = [[PayReq alloc] init];
                     req.openID              = [record objectForKey:@"appid"];
                     req.partnerId           = [record objectForKey:@"partnerid"];
                     req.prepayId            = [record objectForKey:@"prepayid"];
                     req.nonceStr            = [record objectForKey:@"noncestr"];
                     req.timeStamp           = stamp.intValue;
                     req.package             = [record objectForKey:@"package"];
                     req.sign                = [record objectForKey:@"sign"];
                     //
                     BOOL result = [WXApi sendReq:req];
                     if (!result && completion) {
                         completion(NO, @"无法访问微信!");
                     } else if (completion) {
                         self.payCompletionBlock = ^(BOOL success, NSString * info) {
                             dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
                                 sleep(1);
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     completion(success, info);
                                 });
                             });
                         };
                     }
                 } else if (completion) {
                     completion(NO, @"接口数据返回错误，请联系开发人员");
                 }
             } failure:^(HPRequestsError type, NSError *error) {
                 NSLog(@">>ERROR : 调用微信支付接口失败！%@", error);
                 if (completion) {
                     completion(NO,type == HPRequestsErrorServerError ? error.localizedDescription : @"接口调用失败");
                 }
             }];
}
*/

#pragma mark - WXApiDelegate
/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void)onReq:(BaseReq*)req {
    
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp 具体的回应内容，是自动释放的
 */
- (void)onResp:(BaseResp*)resp {
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp * response = (PayResp *)resp;
        switch(response.errCode){
            case WXSuccess: {
                //服务器端查询支付通知或查询API返回的结果再提示成功
                if (self.payCompletionBlock) {
                    self.payCompletionBlock(YES, nil);
                }
                [self postPaySuccessNoti];
            }
                break;
            case WXErrCodeUserCancel: {
                //服务器端查询支付通知或查询API返回的结果再提示成功
                if (self.payCompletionBlock) {
                    self.payCompletionBlock(YES, @"支付已取消");
                }
                [self postPayCancelNoti];
            }
                break;
            default:
                if (self.payCompletionBlock) {
                    self.payCompletionBlock(NO, [NSString stringWithFormat:@"错误码:%@",resp.errStr]);
                }
                [self postPayFailureNoti];
                NSLog(@">>支付失败，retcode=%d",resp.errCode);
                break;
        }
        self.payCompletionBlock = nil;
    }
}

- (void)postPaySuccessNoti {
    [[NSNotificationCenter defaultCenter] postNotificationName:kPaySuccessNotificationKey object:nil];
}

- (void)postPayFailureNoti {
    [[NSNotificationCenter defaultCenter] postNotificationName:kPayFailureNotificationKey object:nil];
}

- (void)postPayCancelNoti {
    [[NSNotificationCenter defaultCenter] postNotificationName:kPayCancelNotificationKey object:nil];
}

@end
