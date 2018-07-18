//
//  DZJSInteractiveRouter.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/13.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZJSInteractiveRouter.h"
#import "TakeawayBusinessListViewController.h"
#import "FoodsBusinessDetailsViewController.h"
#import "FoodsBusinessViewController.h"
#import "NewlyAddAddressViewController.h"
#import "UsersAddressViewController.h"
#import "MyOrdersViewController.h"
#import "MyCollectsViewController.h"
#import "MyCommentsViewController.h"
#import "SellerBusinessViewController.h"
#import "PaymentViewController.h"
#import "HPPayment.h"

/// 美食模块
#import "SelectSeatViewController.h"
#import "FoodsPaymentViewController.h"
#import "FoodsOrderViewController.h"

@implementation DZJSInteractiveRouter

+ (__kindof UIViewController *)instanceFromDestn:(NSString *)destn {
    return [self instanceFromDestn:destn param:nil];
}

+ (__kindof UIViewController *)instanceFromDestn:(NSString *)destn param:(NSString *)param {
    return [self instanceFromDestn:destn params:param?@[param]:nil];
}

+ (__kindof UIViewController *)instanceFromDestn:(NSString *)destn params:(NSArray<NSString *> *)params {
    if ([destn isEqualToString:@"takeOut"]) {
        // 外卖
        return [TakeawayBusinessListViewController controller];
    }
    else if ([destn isEqualToString:@"food"]) {
        // 美食
        return [FoodsBusinessViewController controller];
    }
    else if ([destn isEqualToString:@"search"]) {
        if (params.count == 1 && [self validArgs:params]) {
            SellerBusinessViewController *vc = [SellerBusinessViewController controller];
            vc.companyId = params.firstObject;
            return vc;
        }
    }
    else if ([destn isEqualToString:@"userAddr"]) {
        // 地址管理
        return [UsersAddressViewController controller];
    }
    else if ([destn isEqualToString:@"newAddr"]) {
        // 新增地址
        return [NewlyAddAddressViewController controller];
    }
    else if ([destn isEqualToString:@"allOrder"]) {
        // 全部订单
        return [MyOrdersViewController controller];
    }
    else if ([destn isEqualToString:@"foodDetail"]) {
        // 全部订单
        if (params.count == 1 && [self validArgs:params]) {
            FoodsBusinessDetailsViewController *vc =  [FoodsBusinessDetailsViewController controller];
            vc.companyId = params.firstObject;
            return vc;
        }
    }
    else if ([destn isEqualToString:@"taskOutpay"]) {
        // 外卖提交
        if (params.count == 1 && [self validArgs:params]) {
            PaymentViewController *vc = [PaymentViewController controller];
            vc.orderId = params.firstObject;
            return vc;
        }
    }
    else if ([destn isEqualToString:@"comment"]) {
        // 我的评论
        return [MyCommentsViewController controller];
    }
    else if ([destn isEqualToString:@"favorite"]) {
        // 我的收藏
        return [MyCollectsViewController controller];
    }
    else if ([destn isEqualToString:@"realPay"]) {
        // 外卖支付
        NSString *orderNo = [UserHelper temporaryObjectForKey:kOrderNoCacheKey];
        if (orderNo.length > 0) {
            [HPPayment doWeChatPayWayForOrder:orderNo complete:nil];
        }
    }
    else if ([destn isEqualToString:@"fix"]) {
        // 预定选座
        if (params.count == 1 && [self validArgs:params]) {
            SelectSeatViewController *controller = [SelectSeatViewController controller];
            controller.companyId = params.firstObject;
            return controller;
        }
        return nil;
    }
    else if ([destn isEqualToString:@"orderCheck"]) {
        // 预定选座
        if (params.count == 3 && [self validArgs:params]) {
            FoodsOrderViewController *controller = [FoodsOrderViewController controller];
            controller.companyId = params[0];
            controller.orderId = params[1];
            controller.orderNo = params[2];
            return controller;
        }
        return nil;
    }
    else if ([destn isEqualToString:@"mspay"]) {
        if (params) {
            // 美食支付
            NSString *orderNo = [UserHelper temporaryObjectForKey:kOrderNoCacheKey];
            if (orderNo.length == 0) {
                orderNo = [self validOrderNo:params] ? params.firstObject : @"";
            }
            if (orderNo.length > 0) {
                [HPPayment doWeChatPayWayForOrder:orderNo complete:nil];
            }
        }else{
            // 美食支付
            NSString *orderId = [UserHelper temporaryObjectForKey:kOrderIdCacheKey];
            if (orderId.length == 0) {
                orderId = [self validOrderNo:params] ? params.firstObject : @"";
            }
            if (orderId.length > 0) {
                FoodsPaymentViewController *controller = [FoodsPaymentViewController controller];
                controller.orderId = orderId;
                return controller;
            }
        }

    }
    else if ([destn isEqualToString:@"pay"]) {
        // 支付押金
        if (params.count == 2 && [self validArgs:params]) {
            FoodsPaymentViewController *controller = [FoodsPaymentViewController controller];
            controller.orderId = params.firstObject;
//            controller.cateId = params.lastObject;
            return controller;
        }
    }

    return nil;
}

+ (BOOL)nav:(UINavigationController *)nav needsPush:(UIViewController *)destn animated:(BOOL)animated;{
    if (nav && destn) {
        [nav pushViewController:destn animated:animated];
        return YES;
    }
    return NO;
}

+ (BOOL)validOrderNo:(NSArray<NSString *> *)args {
    if ([self validArgs:args]) {
        NSString *no = args.firstObject;
        return [no containsString:@"WM"] ||
               [no containsString:@"MS"];
    }
    return NO;
}

+ (BOOL)validArgs:(NSArray<NSString *> *)args {
    __block BOOL valid = YES;
    [args enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:@""] ||
            [obj isEqualToString:@"undefined"]) {
            valid = NO;
            *stop = YES;
        }
    }];
    return valid;
}

@end



@implementation NSMutableArray (JSRouter)
- (void)addArg:(JSValue *)arg {
    if ([arg toString]) {
        [self addObject:[arg toString]];
    } else {
        [self addObject:@""];
    }
}

- (void)addArgs:(NSArray<JSValue *>*)args {
    [args enumerateObjectsUsingBlock:^(JSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addArg:obj];
    }];
}
@end

