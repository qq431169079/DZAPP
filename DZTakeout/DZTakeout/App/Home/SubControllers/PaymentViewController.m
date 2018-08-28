//
//  PaymentViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/19.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "PaymentViewController.h"
#import "PaymentSuccessfulViewController.h"
#import "Takeout_OrderDetailsViewController.h"

@interface PaymentViewController () {
    NSString *_orderNo;
}
@end

@implementation PaymentViewController
#pragma mark - Initialize Methods
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupNavigation {
    self.title = @"支付订单";
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDictionary *params = @{@"orderId":self.orderId, @"token":[UserHelper userToken]};
    [self loadWebView:@"http://39.108.6.102:8080/DzClient/taskpay/pay.html" params:params];
    _orderNo = [UserHelper temporaryObjectForKey:kOrderNoCacheKey];
    [self setupNotifications];
}

- (void)setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePaySuccessNoti:) name:kPaySuccessNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePayFailureNoti:) name:kPayFailureNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePayCancelNoti:) name:kPayCancelNotificationKey object:nil];
}

#pragma mark - Notifications
- (void)receivePaySuccessNoti:(NSNotification *)noti {
    Takeout_OrderDetailsViewController *vc = [Takeout_OrderDetailsViewController controller];
    vc.orderId = self.orderId;
    vc.orderNo = _orderNo;
    [self.navigationController pushViewController:vc animated:YES];
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

- (void)receivePayCancelNoti:(NSNotification *)noti {
    occasionalHint(@"支付取消");
    [self receivePayFailureNoti:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
