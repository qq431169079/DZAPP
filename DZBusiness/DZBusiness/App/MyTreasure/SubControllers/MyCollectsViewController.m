//
//  MyCollectsViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/20.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "MyCollectsViewController.h"

@interface MyCollectsViewController ()

@end

@implementation MyCollectsViewController
#pragma mark - Initialize Methods
- (void)setupNavigation {
    self.title = @"收藏";
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadWebViewWithURL:DZUserFavorite([UserHelper userToken])];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
