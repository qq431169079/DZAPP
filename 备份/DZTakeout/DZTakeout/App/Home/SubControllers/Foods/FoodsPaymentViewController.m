//
//  FoodsPaymentViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/27.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "FoodsPaymentViewController.h"
#import "PaymentSuccessfulViewController.h"
#import "FoodsPayFailureViewController.h"

@interface FoodsPaymentViewController ()

@end

@implementation FoodsPaymentViewController
#pragma mark - Initialize Methods
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupNavigation {
    self.title = @"支付订单";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.orderId forKey:@"orderId"];
    [params setObject:[UserHelper userToken] forKey:@"token"];
    [self loadWebView:DZClientPayURL params:params];
    [self setupNotifications];
}

- (void)setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePaySuccessNoti:) name:kPaySuccessNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePayFailureNoti:) name:kPayFailureNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePayCancelNoti:) name:kPayCancelNotificationKey object:nil];
}

#pragma mark - Notifications
- (void)receivePaySuccessNoti:(NSNotification *)noti {
    PaymentSuccessfulViewController *vc = [PaymentSuccessfulViewController controller];
    vc.orderId = self.orderId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)receivePayCancelNoti:(NSNotification *)noti {
    occasionalHint(@"支付取消");
    [self receivePayFailureNoti:nil];
}

- (void)receivePayFailureNoti:(NSNotification *)noti {
    if (noti) {
        occasionalHint(@"支付失败");
    }
    UIViewController *controller = [UserHelper removeTemporaryObjectForKey:kOrderDetailsCacheKey];
    if (controller) {
        [self.navigationController popToViewController:controller animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
