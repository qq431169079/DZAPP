//
//  NewlyAddAddressViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/19.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "NewlyAddAddressViewController.h"

@interface NewlyAddAddressViewController ()

@end

@implementation NewlyAddAddressViewController
#pragma mark - Initialize Methods
- (void)setupNavigation {
    self.title = @"新增收货地址";
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadWebViewWithURL:DZAddNewAddr([UserHelper userToken])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
