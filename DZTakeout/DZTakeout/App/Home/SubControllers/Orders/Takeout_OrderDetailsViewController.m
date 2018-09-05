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
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.orderId forKey:@"orderId"];
    if (self.orderNo) {
        [params setValue:self.orderNo forKey:@"orderNo"];
    }
    [params setValue:[UserHelper userToken] forKey:@"token"];
    [self loadWebView:DZOrderDetailURL params:params];
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
