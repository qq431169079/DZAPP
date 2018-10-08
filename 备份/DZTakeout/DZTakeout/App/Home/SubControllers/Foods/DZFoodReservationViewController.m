//
//  DZFoodReservationViewController.m
//  DZTakeout
//
//  Created by 林鸿键 on 2018/8/31.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZFoodReservationViewController.h"

@interface DZFoodReservationViewController ()

@end

@implementation DZFoodReservationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"结算清单";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.cid forKey:@"cid"];
    [params setValue:[UserHelper userToken] forKey:@"token"];
    [params setValue:self.orderId forKey:@"orderId"];
    [self loadWebView:DZFoodReservationURL params:params];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
