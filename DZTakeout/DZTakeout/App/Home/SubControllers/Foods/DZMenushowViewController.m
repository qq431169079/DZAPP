//
//  DZMenushowViewController.m
//  DZTakeout
//
//  Created by 林鸿键 on 2018/8/31.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZMenushowViewController.h"

@interface DZMenushowViewController ()

@end

@implementation DZMenushowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"菜品预览";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.cid forKey:@"cid"];
    [self loadWebView:DZGoodsShowURL params:params];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
