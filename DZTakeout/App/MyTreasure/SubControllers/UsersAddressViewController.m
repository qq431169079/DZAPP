//
//  UsersAddressViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/19.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "UsersAddressViewController.h"

@interface UsersAddressViewController ()

@end

@implementation UsersAddressViewController
#pragma mark - Initialize Methods
- (BOOL)prefersNavigationBarHidden {
    return NO;
}

- (void)setupNavigation {
    self.title = @"选择收货地址";
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadWebViewWithURL:DZUserAddr([UserHelper userToken])];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
