//
//  DiningBoxViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/27.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DiningBoxViewController.h"

@interface DiningBoxViewController ()

@end

@implementation DiningBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDictionary *param = @{@"cid":self.companyId,@"token":[UserHelper userToken]};
    [self loadWebView:@"http://39.108.6.102:8080/DzClient/selectSeat/select-bx.html" params:param];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
