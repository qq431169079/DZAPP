//
//  SellerCommentsViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/19.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "SellerCommentsViewController.h"

@interface SellerCommentsViewController ()

@end

@implementation SellerCommentsViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadWebView:DZGoodsListURL params:@{@"cid":self.companyId}];
}

- (void)dealloc {
    NSLog(@"SellerCommentsViewController ------ ");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
