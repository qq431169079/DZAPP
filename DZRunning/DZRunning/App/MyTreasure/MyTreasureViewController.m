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

//- (UIEdgeInsets)webViewEdges {
//    return UIEdgeInsetsMake(MyTreasureHeaderViewHeight(), 0, 0, 0);
//}

- (BOOL)prefersNavigationBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadWebViewWithURL:@"http://118.190.149.109:8081/DzClient/user/user.html"];
    self.title = @"我的";
    [self setupNavigation];
}

-(void)setupNavigation{
    [self setRightBarButtonItem:[self barButtonItemWithTitle:@"退出" normalColor:[UIColor whiteColor] highlightColor:nil normalImage:nil highlightImage:nil target:self action:@selector(logout)]];
    [self setLeftBarButtonItem:[self barButtonItemWithTitle:nil normalColor:nil highlightColor:nil normalImage:[UIImage imageNamed:@"icon_setting"] highlightImage:nil target:self action:@selector(resetPWD)]];
}

-(void)logout{
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
-(void)resetPWD{
    DZResetPWDViewController *resetVC = [DZResetPWDViewController controller];
    resetVC.resetPWD = YES;
    HPNavigationController *nav = [[HPNavigationController alloc] initWithRootViewController:resetVC];
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark - Getter & Setter

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
