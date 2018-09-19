//
//  FoodsBusinessDetailsViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/15.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "FoodsBusinessDetailsViewController.h"
#import "UIButton+HPUtil.h"

@interface FoodsBusinessDetailsViewController ()

@property (nonatomic, strong) UIButton *backButton;

@end

@implementation FoodsBusinessDetailsViewController
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

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(250, 126, 0);
    // Do any additional setup after loading the view.
    [self _setupSubviews];
//    [self loadWebView:@"http://39.108.6.102:8080/DzClient/foodDetail/shop.html" params:@{@"cid":self.companyId, @"location":@"22.6733000000,114.0651500000"}];
    
    __weak typeof(self) wself = self;
    [UserHelper temporaryCacheObject:wself forKey:kOrderDetailsCacheKey];
}

- (void)onReturnBackComplete:(void (^)(void))complete {
    [UserHelper removeTemporaryObjectForKey:kOrderDetailsCacheKey];
    [super onReturnBackComplete:complete];
}

#pragma mark - Event Response
- (void)popBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
