//
//  MyTreasureViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/3/26.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "MyTreasureViewController.h"
#import "MyTreasureHeaderView.h"
#import "HPNavigationController.h"
#import "LoginViewController.h"
#import "DZJrmfWalletSDK.h"
#import "UIViewController+HPUtil.h"
#import "DZResetPWDViewController.h"
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
    [self loadWebViewWithURL:@"http://39.108.6.102:8080/DzClient/treasure/treasure.html"];
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
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认退出当前用户?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [UserHelper cleanAllTemporaryObjects];
        [UserHelper logout];
        
        HPNavigationController *rootController = [[HPNavigationController alloc] initWithRootViewController:[LoginViewController controller]];
        [[UIApplication sharedApplication].keyWindow setRootViewController:rootController];
        [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:addAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)headerView:(MyTreasureHeaderView *)headerView touchUpInsideSettingButton:(UIButton *)sender {
    
    DZResetPWDViewController *resetVC = [DZResetPWDViewController controller];
    resetVC.resetPWD = YES;
    HPNavigationController *nav = [[HPNavigationController alloc] initWithRootViewController:resetVC];
    [self presentViewController:nav animated:YES completion:nil];
    
}
-(void)headerView:(MyTreasureHeaderView *)headerView touchUpInsideredPacketsButton:(UIButton *)sender{
    [DZJrmfWalletSDK shareInstace].themePageColor = RGB(255, 126, 0);
    [DZJrmfWalletSDK shareInstace].pageBtnColor = RGB(254, 151, 17);
    [DZJrmfWalletSDK shareInstace].themeNavColor = RGB(255, 126, 0);
    [DZJrmfWalletSDK shareInstace].themeBtnColor = RGB(255, 126, 0);
    [DZJrmfWalletSDK openWallet];
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
