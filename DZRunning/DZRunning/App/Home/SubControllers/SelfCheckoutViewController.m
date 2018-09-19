//
//  SelfCheckoutViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/25.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "SelfCheckoutViewController.h"

@interface SelfCheckoutViewController ()

@end

@implementation SelfCheckoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadingIfNeeded];
}

- (void)loadingIfNeeded {
    if (self.orderId.length == 0 ||
        self.orderNo.length == 0) {
        return;
    }
//    [self loadWebView:@"http://39.108.6.102:8080/DzClient/check/check.html" params:@{@"orderId":self.orderId, @"orderNo":self.orderNo, @"token":[UserHelper userToken]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
