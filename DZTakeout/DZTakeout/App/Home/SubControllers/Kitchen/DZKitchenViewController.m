//
//  DZKitchenViewController.m
//  DZTakeout
//
//  Created by 林鸿键 on 2018/9/19.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZKitchenViewController.h"

@interface DZKitchenViewController ()

@end

@implementation DZKitchenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWebView:DZActivityURL params:nil];
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
