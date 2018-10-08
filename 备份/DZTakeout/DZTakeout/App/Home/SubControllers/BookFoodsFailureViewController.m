//
//  BookFoodsFailureViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/19.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "BookFoodsFailureViewController.h"

@interface BookFoodsFailureViewController ()

@end

@implementation BookFoodsFailureViewController
#pragma mark - Initialize Methods
- (BOOL)prefersNavigationBarHidden {
    return YES;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadWebViewWithURL:DZPredeFinedFailureURL];
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
