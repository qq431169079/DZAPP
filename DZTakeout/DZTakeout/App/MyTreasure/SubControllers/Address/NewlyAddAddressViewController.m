//
//  NewlyAddAddressViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/19.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "NewlyAddAddressViewController.h"
#import "DZMapViewController.h"
@interface NewlyAddAddressViewController ()<DZMapDelegate>

@end

@implementation NewlyAddAddressViewController
#pragma mark - Initialize Methods
- (void)setupNavigation {
    self.title = @"新增收货地址";
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWebViewWithURL:DZAddNewAddr([UserHelper userToken])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)launch:(NSString *)destn{
    if ([destn isEqualToString:@"map"]) {
        DZMapViewController *mapVC = [DZMapViewController controller];
        mapVC.delegate = self;
        [self.navigationController pushViewController:mapVC animated:YES];
    }else if ([destn isEqualToString:@"finish"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        [super launch:destn];
    }

}

-(void)checkMapAddress:(NSArray *)Address{
    if (Address.count == 3) {
        NSString *addr = Address.firstObject;
        NSString *lng = Address[1];
        NSString *lat = Address.lastObject;
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.set(\"%@\",\"%@\",\"%@\")",addr,lng,lat]];
    }

}
@end
