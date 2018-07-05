//
//  EditUserAddressViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/19.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "EditUserAddressViewController.h"

@interface EditUserAddressViewController ()

@end

@implementation EditUserAddressViewController
#pragma mark - Initialize Methods
- (void)setupNavigation {
    self.title = @"选择收货地址";
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadWebViewWithURL:@"http://118.190.149.109:8081/DzClient/userAddr/update-addr.html"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
