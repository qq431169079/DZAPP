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
    self.title = @"修改收货地址";
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self loadWebViewWithURL:@"http://118.190.149.109:8081/DzClient/userAddr/update-addr.html"];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setValue:self.addressID forKey:@"id"];
//    [params setValue:[UserHelper userToken] forKey:@"token"];
    NSString *newURL = DZUserAddrUpdateURL([UserHelper userToken],self.addressID);
    [self loadWebViewWithURL:newURL];
//    [self loadWebView:@"http://39.108.6.102:8080/DzClient/userAddr/update-addr.html" params:params];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
