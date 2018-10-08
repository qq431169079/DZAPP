//
//  FoodsOrderViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/27.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "FoodsOrderViewController.h"

@interface FoodsOrderViewController ()

@end

@implementation FoodsOrderViewController
#pragma mark - Initialize Methods
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setupNavigation {
    self.title = @"点餐";
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadWebView:DZOrderFoodURL params:@{@"cid":self.companyId, @"token":[UserHelper userToken],@"orderNo":self.orderNo}];
    [UserHelper temporaryCacheObject:self.orderNo forKey:kOrderNoCacheKey];
    [UserHelper temporaryCacheObject:self.orderId forKey:kOrderIdCacheKey];
}
- (void)launch:(NSString *)destn {
    
    if ([destn isEqualToString:@"mspay"]) {
        NSArray *params = [NSArray arrayWithObjects:self.orderId, self.companyId,nil];
        [super launch:@"mspayFoodsOrder" withParams:params];

    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
