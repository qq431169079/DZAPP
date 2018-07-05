//
//  MyCommentsViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/20.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "MyCommentsViewController.h"

@interface MyCommentsViewController ()

@end

@implementation MyCommentsViewController
#pragma mark - Initialize Methods
- (void)setupNavigation {
    self.title = @"我的评论";
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadWebViewWithURL:@"http://118.190.149.109:8081/DzClient/comment/comment.html"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
