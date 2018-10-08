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
    [self loadWebViewWithURL:DZUserAddr([UserHelper userToken])];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.webView reload];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)launch:(NSString *)destn withParam:(NSString *)param {
    if ([destn isEqualToString:@"alert"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:param message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if ([param isEqualToString:@"修改信息成功"]) {
                [self.webView reload];
            }
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        [super launch:destn withParam:param];
    }
}
@end
