//
//  FoodsBusinessViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/15.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "FoodsBusinessViewController.h"
#import "DZSearchNavigationBar.h"
#import "UIButton+HPUtil.h"
#import "DZBMKLocationTool.h"
#import "DZSearchViewController.h"
@interface FoodsBusinessViewController ()<UISearchBarDelegate> {
    @package
    NSString *_searchKey;
}
@property (nonatomic, strong) DZSearchNavigationBar *navBar;

@end

@implementation FoodsBusinessViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self __setupNavBar];
    [self loadFooderSearchView:nil];
    
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
#pragma mark web
-(void)loadFooderSearchView:(BMKLocation *)location{
    if (location) {
        NSString *newLocationName;
        BMKLocationReGeocode *locationReGeocode = location.rgcData;
        NSArray *poiList = locationReGeocode.poiList;
        if (poiList.count>0) {
            BMKLocationPoi *locationPoi = [poiList firstObject];
            newLocationName = locationPoi.name;
        }else{
            newLocationName = locationReGeocode.street;
        }
        occasionalHint(newLocationName);
    }
    [self loadWebView:DZFooderSearchURL params:@{@"lng":[DZBMKLocationTool sharedInstance].coordinateStr}];
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
    DZSearchViewController *searchVC = [[DZSearchViewController alloc] init];
    [self presentViewController:searchVC animated:YES completion:nil];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    _searchKey = searchBar.text;
}

#pragma mark - Event Response
- (void)_startLocationIfNeeded {
    DZWeakSelf(self)
//    occasionalHint(@"重新定位中...");
    [[DZBMKLocationTool sharedInstance] requestLocationWithReGeocode:YES withNetworkState:NO completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        if (error == nil) {
            [weakSelf loadFooderSearchView:location];
        }else{
        }
    }];}

- (void)_handleReturnBackEvent {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)_handleSearchBarEvent {
    DZSearchViewController *searchVC = [[DZSearchViewController alloc] init];
    [self presentViewController:searchVC animated:YES completion:nil];
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
            [self _handleReturnBackEvent];
        };
        _navBar.onClickSearchBarHandler = ^{
            @strongify(self);
            [self _handleSearchBarEvent];
        };
    }
    return _navBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
