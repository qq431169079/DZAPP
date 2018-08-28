//
//  ShoppingCartDetailsViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/19.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "ShoppingCartDetailsViewController.h"

@interface ShoppingCartDetailsViewController ()

@end

@implementation ShoppingCartDetailsViewController
#pragma mark - Initialize Methods
- (void)setupNavigation {
    self.title = @"购物车订单详情";
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadWebViewWithURL:@"http://39.108.6.102:8080/DzClient/checkout/cart-order-detail.html"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
