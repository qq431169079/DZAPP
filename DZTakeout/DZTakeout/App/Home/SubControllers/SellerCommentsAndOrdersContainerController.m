//
//  SellerCommentsAndOrdersContainerController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/20.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "SellerCommentsAndOrdersContainerController.h"
#import "SellerCommentsViewController.h"
#import "PleaseOrderViewController.h"
#import "SGPagingView.h"
 
static CGSize SGPagingTitleSize = {180.0f, 50.0f};

@interface SellerCommentsAndOrdersContainerController ()<UIScrollViewDelegate, SGPageTitleViewDelegate> {
    NSArray<UIViewController *> *_myChildControllers;
    CGFloat _startOffsetX;
}

@property (nonatomic, weak) UIViewController *previousVc;
@property (nonatomic, strong) SellerCommentsViewController *commentsVc;
@property (nonatomic, strong) PleaseOrderViewController *pleaseOrdersVc;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) SGPageTitleView *pageTitleView;

@end

@implementation SellerCommentsAndOrdersContainerController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadChildControlles];
}

- (void)dealloc {
    NSLog(@"SellerCommentsAndOrdersContainerController ---- ");
}

- (void)loadChildControlles {
    NSArray<UIViewController *> *childControllers = @[self.pleaseOrdersVc, self.commentsVc];
    _myChildControllers = childControllers;
    self.previousVc = self.pleaseOrdersVc;
    
    __weak typeof(self) wself = self;
    [childControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [wself addChildViewController:obj];
        [obj didMoveToParentViewController:wself];
        [wself.scrollView addSubview:obj.view];
    }];
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageTitleView];

    @weakify(self);
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.view).offset(SGPagingTitleSize.height);
        make.bottom.equalTo(self.view);
        make.left.right.equalTo(self.view);
    }];
    [self.pageTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.size.mas_equalTo(SGPagingTitleSize);
        make.left.top.equalTo(self.view);
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.scrollView.contentSize = CGSizeMake(_myChildControllers.count * SCREEN_WIDTH, CGRectGetHeight(self.scrollView.bounds)) ;
    [_myChildControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.view.frame = CGRectMake(idx * SCREEN_WIDTH, 0, SCREEN_WIDTH, CGRectGetHeight(self.scrollView.bounds));
    }];
}

#pragma mark - SGPageTitleViewDelegate
- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.scrollView setContentOffset:CGPointMake(selectedIndex * SCREEN_WIDTH, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _startOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 1、定义获取需要的数据
    CGFloat progress = 0;
    NSInteger originalIndex = 0;
    NSInteger targetIndex = 0;
    // 2、判断是左滑还是右滑
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.bounds.size.width;
    if (currentOffsetX > _startOffsetX) { // 左滑
        // 1、计算 progress
        progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW);
        // 2、计算 originalIndex
        originalIndex = currentOffsetX / scrollViewW;
        // 3、计算 targetIndex
        targetIndex = originalIndex + 1;
        if (targetIndex >= self.childViewControllers.count) {
            progress = 1;
            targetIndex = self.childViewControllers.count - 1;
        }
        // 4、如果完全划过去
        if (currentOffsetX - _startOffsetX == scrollViewW) {
            progress = 1;
            targetIndex = originalIndex;
        }
    } else { // 右滑
        // 1、计算 progress
        progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW));
        // 2、计算 targetIndex
        targetIndex = currentOffsetX / scrollViewW;
        // 3、计算 originalIndex
        originalIndex = targetIndex + 1;
        if (originalIndex >= self.childViewControllers.count) {
            originalIndex = self.childViewControllers.count - 1;
        }
    }
    // 3、pageContentScrollViewDelegate; 将 progress／sourceIndex／targetIndex 传递给 SGPageTitleView
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 1、根据标题下标计算 pageContent 偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    // 2、切换子控制器的时候，执行上个子控制器的 viewWillDisappear 方法
    if (_startOffsetX != offsetX) {
        [self.previousVc beginAppearanceTransition:NO animated:NO];
    }
    // 3、获取当前显示子控制器的下标
    NSInteger index = offsetX / scrollView.frame.size.width;
    // 4、添加子控制器及子控制器的 view 到父控制器以及父控制器 view 中
    UIViewController *childVC = self.childViewControllers[index];
    [childVC beginAppearanceTransition:YES animated:NO];
    // 2.1、切换子控制器的时候，执行上个子控制器的 viewDidDisappear 方法
    if (_startOffsetX != offsetX) {
        [self.previousVc endAppearanceTransition];
    }
    [childVC endAppearanceTransition];
    // 4.1、记录上个展示的子控制器、记录当前子控制器偏移量
    self.previousVc = childVC;
}

#pragma mark - Getter & Setter
- (void)setLogisticsPrice:(CGFloat)logisticsPrice {
    _logisticsPrice = logisticsPrice;
    self.pleaseOrdersVc.logisticsPrice = _logisticsPrice;
}
-(void)setMinPrice:(NSString *)minPrice{
    _minPrice = minPrice;
    self.pleaseOrdersVc.minPrice = minPrice;
}
- (SellerCommentsViewController *)commentsVc {
    if (!_commentsVc) {
        _commentsVc = [SellerCommentsViewController controller];
        _commentsVc.companyId = self.companyId;
    }
    return _commentsVc;
}

- (void)setIsBusiness:(BOOL)isBusiness{
    _isBusiness = isBusiness;
    self.pleaseOrdersVc.isBusiness = isBusiness;
}

- (PleaseOrderViewController *)pleaseOrdersVc {
    if (!_pleaseOrdersVc) {
        _pleaseOrdersVc = [PleaseOrderViewController controller];
        _pleaseOrdersVc.companyId = self.companyId;
    }
    return _pleaseOrdersVc;
}

- (SGPageTitleView *)pageTitleView {
    if (!_pageTitleView) {
        SGPageTitleViewConfigure *config = [[SGPageTitleViewConfigure alloc] init];
        config.titleSelectedColor = NAV_FGC;
        config.indicatorColor = NAV_FGC;
        config.needBounces = NO;
        config.titleGradientEffect = NO;
        config.showBottomSeparator = NO;
        config.showIndicator = YES;
        _pageTitleView = [[SGPageTitleView alloc] initWithFrame:CGRectMake(0, 0, SGPagingTitleSize.width, SGPagingTitleSize.height) delegate:self titleNames:@[@"点餐", @"评价"] configure:config];
    }
    return _pageTitleView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = self.view.bounds;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.alwaysBounceHorizontal = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
