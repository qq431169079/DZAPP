//
//  DiningHallViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/27.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DiningHallViewController.h"

@interface DiningHallViewController ()
@end

@implementation DiningHallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDictionary *param = @{@"cid":self.companyId,@"token":[UserHelper userToken]};
    [self loadWebView:DZSelectSeatURL params:param];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
