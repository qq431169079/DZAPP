//
//  PaymentSuccessfulViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/19.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "PaymentSuccessfulViewController.h"
#import "UIButton+HPUtil.h"

@interface PaymentSuccessfulViewController ()

@property (nonatomic, strong) UIButton *backButton;

@end

@implementation PaymentSuccessfulViewController
#pragma mark - Initialize Methods
- (BOOL)prefersNavigationBarHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIEdgeInsets)webViewEdges {
    return UIEdgeInsetsZero;
}


- (void)_setupSubviews {
    [self.view addSubview:self.backButton];
    @weakify(self);
    CGFloat centerY = ASPECT_STATUS_BAR_H + (ASPECT_NAV_HEIGHT - ASPECT_STATUS_BAR_H) * 0.5f;
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.view).offset(10);
        make.centerY.equalTo(self.view.mas_top).offset(centerY);
        make.size.mas_equalTo(CGSizeMake(26, 26));;
    }];
}


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _setupSubviews];
    if ([UserHelper userToken].length > 0) {
        [self loadWebView:@"http://118.190.149.109:8081/DzClient/paySuccess/pay-success.html" params:@{@"orderId":self.orderId, @"token":[UserHelper userToken]}];
    }
}

#pragma mark - Event Response
- (void)popBack:(UIButton *)sender {
    UIViewController *controller = [UserHelper removeTemporaryObjectForKey:kOrderDetailsCacheKey];
    if (controller) {
        [self.navigationController popToViewController:controller animated:YES];
    }
}

#pragma mark - Getter & Setter
- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.adjustsImageWhenHighlighted = NO;
        _backButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
        _backButton.imageOfNormal = [UIImage imageNamed:@"nav_nav_icon_back_normal"];
        [_backButton addTarget:self action:@selector(popBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
