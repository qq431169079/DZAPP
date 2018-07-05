//
//  MyTreasureViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/3/26.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "MyTreasureViewController.h"
#import "MyTreasureHeaderView.h"

@interface MyTreasureViewController ()<MyTreasureHeaderViewDelegate>

@property (nonatomic, strong) MyTreasureHeaderView *headerView;

@end

@implementation MyTreasureViewController
#pragma mark - Initialize Methods

- (UIEdgeInsets)webViewEdges {
    return UIEdgeInsetsMake(MyTreasureHeaderViewHeight(), 0, 0, 0);
}

- (BOOL)prefersNavigationBarHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadWebViewWithURL:@"http://118.190.149.109:8081/DzClient/treasure/treasure.html"];
}

- (void)setupSubviews {
    [self.view addSubview:self.headerView];
    @weakify(self);
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(MyTreasureHeaderViewHeight());
    }];
}

#pragma mark - MyTreasureHeaderViewDelegate
- (void)headerView:(MyTreasureHeaderView *)headerView touchUpInsideQRButton:(UIButton *)sender {
    
}

- (void)headerView:(MyTreasureHeaderView *)headerView touchUpInsideExitButton:(UIButton *)sender {
    
}

- (void)headerView:(MyTreasureHeaderView *)headerView touchUpInsideSettingButton:(UIButton *)sender {
    
}

#pragma mark - Getter & Setter
- (MyTreasureHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [MyTreasureHeaderView new];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
