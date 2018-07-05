//
//  DZSegmentNavBarController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/15.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZSegmentNavBarController.h"
#import "DZSegmentNavBar.h"
#import "SGPageContentScrollView.h"

@interface DZSegmentNavBarController ()<SGPageContentScrollViewDelegate>

@property (nonatomic, strong) DZSegmentNavBar *navBar;
@property (nonatomic, strong) SGPageContentScrollView *scrollView;
@end

@implementation DZSegmentNavBarController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self __setupNavBar];
    [self _segmentSwitchToIndex:0];
}

- (void)__setupNavBar {
    [self.view addSubview:self.navBar];
    [self.view addSubview:self.scrollView];
    @weakify(self);
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(ASPECT_NAV_HEIGHT);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
}

#pragma mark - Initialize Methods
- (BOOL)prefersNavigationBarHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Event Response
- (void)_handleReturnBackEvent {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)_segmentSwitchToIndex:(NSInteger)index {
    [self.scrollView setPageContentScrollViewCurrentIndex:index];
    [self segmentSwitchToIndex:index];
}

- (void)segmentSwitchToIndex:(NSInteger)index {
   //
}

- (NSArray<NSString *> *)navSegmentTitles {
    return @[];
}

- (NSArray<UIViewController *> *)switchChildControllers {
    return @[];
}

#pragma mark - SGPageContentScrollViewDelegate
- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.navBar setSelectedIndex:targetIndex];
}

#pragma mark - Getter & Setter
- (DZSegmentNavBar *)navBar {
    if (!_navBar) {
        _navBar = [[DZSegmentNavBar alloc] init];
        _navBar.backgroundColor = NAV_FGC;
        _navBar.segmentTitles = [self navSegmentTitles];
        @weakify(self);
        _navBar.returnBackHandler = ^(UIButton *sender) {
            @strongify(self);
            [self _handleReturnBackEvent];
        };
        _navBar.onSelectedIndexHandler = ^(NSInteger selectedIndex) {
            @strongify(self);
            [self _segmentSwitchToIndex:selectedIndex];
        };
    }
    return _navBar;
}

- (SGPageContentScrollView *)scrollView {
    if (!_scrollView) {
        CGRect frame = self.view.bounds;
        frame.origin.y = ASPECT_NAV_HEIGHT;
        frame.size.height -= ASPECT_NAV_HEIGHT;
        _scrollView = [[SGPageContentScrollView alloc] initWithFrame:frame parentVC:self childVCs:[self switchChildControllers]];
        _scrollView.delegatePageContentScrollView = self;
    }
    return _scrollView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
