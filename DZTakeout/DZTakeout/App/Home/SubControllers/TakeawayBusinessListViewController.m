//
//  TakeawayBusinessListViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/9.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "TakeawayBusinessListViewController.h"
#import "DZSearchNavigationBar.h"
#import "UIButton+HPUtil.h"
#import "DZBMKLocationTool.h"
@interface TakeawayBusinessListViewController ()<UISearchBarDelegate> {
    @package
    NSString *_searchKey;
}
@property (nonatomic, strong) DZSearchNavigationBar *navBar;
@end

@implementation TakeawayBusinessListViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self __setupNavBar];
    [self loadWebView:DZClientSearchURL params:@{@"lng":[DZBMKLocationTool sharedInstance].coordinateStr}];
}

- (void)__setupNavBar {
    [self.view addSubview:self.navBar];
    @weakify(self);
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(ASPECT_NAV_HEIGHT);
    }];
}

#pragma mark - Initialize Methods
- (BOOL)prefersNavigationBarHidden {
    return YES;
}

- (UIEdgeInsets)webViewEdges {
    return UIEdgeInsetsMake(ASPECT_NAV_HEIGHT, 0, 0, 0);
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    _searchKey = searchBar.text;
}

#pragma mark - Event Response
- (void)_startLocationIfNeeded {
    
}

- (void)_handleComeBackEvent {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Getter & Setter
- (DZSearchNavigationBar *)navBar {
    if (!_navBar) {
        _navBar = [[DZSearchNavigationBar alloc] init];
        _navBar.delegate = self;
        _navBar.backgroundColor = NAV_FGC;
        
        UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        locationBtn.adjustsImageWhenHighlighted = NO;
        locationBtn.imageOfNormal = [UIImage imageNamed:@"icon_location"];
        locationBtn.frame = CGRectMake(0, 0, 30, 26);
        [locationBtn addTarget:self action:@selector(_startLocationIfNeeded) forControlEvents:UIControlEventTouchUpInside];
        _navBar.rightView = locationBtn;
        @weakify(self);
        _navBar.returnBackHandler = ^(UIButton *sender) {
            @strongify(self);
            [self _handleComeBackEvent];
        };
    }
    return _navBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
