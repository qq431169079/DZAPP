//
//  MyOrdersViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/20.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "MyOrdersViewController.h"

@interface MyOrdersViewController ()

@end

@implementation MyOrdersViewController
#pragma mark - Initialize Methods
- (void)setupNavigation {
    self.title = @"订单";
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadWebViewWithURL:@"http://118.190.149.109:8081/DzClient/allOrder/all-order.html"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
