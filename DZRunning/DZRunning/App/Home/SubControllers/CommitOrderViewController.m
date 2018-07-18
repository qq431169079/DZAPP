//
//  CommitOrderViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/19.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "CommitOrderViewController.h"
#import "CheckoutViewController.h"
#import "SelfCheckoutViewController.h"

@interface CommitOrderViewController ()

@end

@implementation CommitOrderViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UserHelper temporaryCacheObject:self.orderNo forKey:kOrderNoCacheKey];
    [UserHelper temporaryCacheObject:self.orderId forKey:kOrderIdCacheKey];
}

#pragma mark - Override Functions
- (NSArray<NSString *> *)navSegmentTitles {
    return @[@"外卖配送", @"到店自取"];
}

- (NSArray<UIViewController *> *)switchChildControllers {
    CheckoutViewController *checkVc= [CheckoutViewController controller];
    SelfCheckoutViewController *selfCheckVc= [SelfCheckoutViewController controller];
    checkVc.orderId = self.orderId;
    checkVc.orderNo = self.orderNo;
    selfCheckVc.orderId = self.orderId;
    selfCheckVc.orderNo = self.orderNo;
    return @[checkVc, selfCheckVc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
