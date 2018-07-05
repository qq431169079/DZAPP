//
//  Takeout_OrderDetailsViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/28.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "Takeout_OrderDetailsViewController.h"

@interface Takeout_OrderDetailsViewController ()

@end

@implementation Takeout_OrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadWebView:@"http://118.190.149.109:8081/DzClient/orderDetail/orderindex.html" params:@{@"orderId":self.orderId, @"orderNo":self.orderNo}];
}

- (void)onReturnBackComplete:(void (^)(void))complete {
    UIViewController *controller = [UserHelper removeTemporaryObjectForKey:kOrderDetailsCacheKey];
    if (controller) {
        [self.navigationController popToViewController:controller animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
