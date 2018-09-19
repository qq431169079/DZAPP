//
//  HomeViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/3/26.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "HomeViewController.h"

#import "DZFakeNavigationBar.h"
#import "TakeawayBusinessListViewController.h"
#import "DZSearchViewController.h"

#import "DZBMKLocationTool.h"
#import "DZLoadingView.h"
#import "DZLoadingHoldView.h"
#import "DZJSActionRouter.h"
@interface HomeViewController ()<
DZFakeNavigationBarDelegate,
UIScrollViewDelegate,
UIWebViewDelegate,
BMKLocationAuthDelegate,
BMKLocationManagerDelegate,
DZJSActionRouterDelegate
>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) DZFakeNavigationBar *navBar;
@property (nonatomic, strong) JSContext *context;
@property (nonatomic, strong) BMKLocationManager *locationManager;
@property (nonatomic, weak) DZLoadingView *loadingView;         //下拉刷新的动画
@property (nonatomic, weak) DZLoadingHoldView *loadingHoldView;//加载的动画
@property (nonatomic,strong) DZJSActionRouter *actionRouter;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.navBar];
    [self.view addSubview:self.webView];
    
    CGFloat navBarH = (ASPECT_NAV_HEIGHT + 35);
    self.navBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, navBarH);
    self.webView.frame = CGRectMake(0, navBarH, SCREEN_WIDTH, SCREEN_HEIGHT - navBarH);
    self.loadingHoldView.hidden = NO;
    [self setLocationManager];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UserHelper cleanAllTemporaryObjects];

}

- (void)setupNavigation {
    self.title = @"首页";
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersNavigationBarHidden {
    return YES;
}
#pragma mark - 定位
-(void)setLocationManager{
    @weakify(self);
    [self.loadingHoldView setImageWithRequestResult:DZRequestLoading];
    [[DZBMKLocationTool sharedInstance] requestLocationWithReGeocode:YES withNetworkState:NO completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        if (error == nil) {

            [__weak_self__ loadWebViewWithLocation:location];
            [__weak_self__ getLocationName:location];
        }else{
            [__weak_self__.loadingHoldView setImageWithRequestResult:DZRequestFailure];
        }
    }];
}
-(void)loadWebViewWithLocation:(BMKLocation *)location{
    
    NSString *homeURL = [NSString stringWithFormat:@"%@?lng=%@&cid=22",DZHomeURL,[DZBMKLocationTool sharedInstance].coordinateStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:homeURL]];
    [self.webView loadRequest:request];
    
}
-(void)getLocationName:(BMKLocation *)location{
    BMKLocationReGeocode *locationReGeocode = location.rgcData;
    NSArray *poiList = locationReGeocode.poiList;
    if (poiList.count>0) {
        BMKLocationPoi *locationPoi = [poiList firstObject];
        self.navBar.title = locationPoi.name;
    }
}


#pragma mark - DZFakeNavigationBarDelegate
- (void)navBar:(DZFakeNavigationBar *)navBar onClickMessageButton:(UIButton *)messageBtn {
    
}

- (void)navBar:(DZFakeNavigationBar *)navBar onClickShoppingCartButton:(UIButton *)shoppingCartBtn {
    
}
-(void)navBar:(DZFakeNavigationBar *)navBar onClickSearchBar:(UIButton *)searchBar{
    DZSearchViewController *searchVC = [[DZSearchViewController alloc] init];
    [self presentViewController:searchVC animated:YES completion:nil];
    
}
#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.context[@"android"] = self.actionRouter;
    [self.loadingHoldView setImageWithRequestResult:DZRequestSuccess];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
//    [self.loadingHoldView setImageWithRequestResult:DZRequestLoading];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.loadingHoldView setImageWithRequestResult:DZRequestFailure];
}
#pragma mark - DZJSInteractiveExport
- (void)base:(JSValue *)destn {
    _hy_dispatch_main_async_safe(^{
        UIViewController *controler = [DZJSInteractiveRouter instanceFromDestn:[destn toString]];
        [DZJSInteractiveRouter nav:self.navigationController needsPush:controler animated:YES];
    });
}

- (void)valLink:(JSValue *)destn final:(JSValue *)param {
    _hy_dispatch_main_async_safe(^{
        UIViewController *controler = [DZJSInteractiveRouter instanceFromDestn:[destn toString] param:[param toString]];
        [DZJSInteractiveRouter nav:self.navigationController needsPush:controler animated:YES];
    });
}


- (void)moreLink:(JSValue *)destn first:(JSValue *)firstArg second:(JSValue *)secondArg {
    _hy_dispatch_main_async_safe(^{
        NSMutableArray<NSString *> *args = [NSMutableArray array];
        [args addArg:firstArg];
        [args addArg:secondArg];
        [self launch:[destn toString] withParams:args.copy];
    });
}

- (void)orderCheck:(JSValue *)destn first:(JSValue *)firstArg second:(JSValue *)secondArg third:(JSValue *)thirdArg {
    _hy_dispatch_main_async_safe(^{
        NSMutableArray<NSString *> *args = [NSMutableArray array];
        [args addArg:firstArg];
        [args addArg:secondArg];
        [args addArg:thirdArg];
        [self launch:[destn toString] withParams:args.copy];
    });
}

- (void)launch:(NSString *)destn withParams:(NSArray<NSString *> *)params {
    UIViewController *controler = [DZJSInteractiveRouter instanceFromDestn:destn params:params];
    [DZJSInteractiveRouter nav:self.navigationController needsPush:controler animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.navBar gradation_scrollViewDidScroll:scrollView];
    CGFloat offset = scrollView.contentOffset.y;
    if (offset<0) {
        [self reloadWebViewWithOffset:offset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.navBar gradation_scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    CGFloat offset = scrollView.contentOffset.y;
    if (offset<-50) {
        [self resetWebView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.navBar gradation_scrollViewDidEndDecelerating:scrollView];
}
#pragma mark - 其他
-(void)reloadWebViewWithOffset:(CGFloat)offset{
    if (self.loadingView.isloading) {
        return;
    }
    CGFloat scale = ABS(offset)/50.0;
    if (scale>1) {
        scale =1;

        
    }
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
    transform = CGAffineTransformRotate(transform, M_PI * ABS(offset)/50.0 *4);
    self.loadingView.transform = transform;
}
-(void)resetWebView{
    [self.loadingView startLoadingAnimation];
    //重新定位
    DZWeakSelf(self)
    [[DZBMKLocationTool sharedInstance] requestLocationWithReGeocode:YES withNetworkState:NO completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        [self.loadingView endLoadingAnimaton];
        if (error == nil) {
            [weakSelf loadWebViewWithLocation:location];
            [weakSelf getLocationName:location];
        }
    }];
}
#pragma mark - Getter & Setter
- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _webView.scrollView.delegate = self;
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}

- (DZFakeNavigationBar *)navBar {
    if (!_navBar) {
        _navBar = [[DZFakeNavigationBar alloc] init];
        _navBar.title = @"获取位置中...";
        _navBar.delegate = self;
        @weakify(self);
        _navBar.adjustNavBarFrameHandler = ^(CGRect frame) {
            @strongify(self);
            CGRect oldFrame = self.webView.frame;
            oldFrame.origin.y = frame.size.height;
            oldFrame.size.height = (SCREEN_HEIGHT - frame.size.height);
            self.webView.frame = oldFrame;
        };
    }
    return _navBar;
}

-(DZLoadingView *)loadingView{
    if (_loadingView == nil) {
        DZLoadingView *loadingView = [DZLoadingView DZLoadingViewWithType:DZLoadingViewMiniType];
        [self.webView addSubview:loadingView];
        loadingView.center = CGPointMake(SCREEN_WIDTH*0.5, 25);
        _loadingView = loadingView;
    }
    return _loadingView;
}

-(DZLoadingHoldView *)loadingHoldView{
    if (_loadingHoldView == nil) {
        DZLoadingHoldView *loadingHoldView = [[NSBundle mainBundle] loadNibNamed:@"DZLoadingHoldView" owner:nil options:nil].firstObject;
        loadingHoldView.frame = self.webView.bounds;
        DZWeakSelf(self)
        loadingHoldView.reResultBlock = ^{
            [weakSelf setLocationManager];
        };
        [self.webView addSubview:loadingHoldView];
        _loadingHoldView = loadingHoldView;
    }
    return _loadingHoldView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(DZJSActionRouter *)actionRouter{
    if (_actionRouter == nil) {
        _actionRouter = [[DZJSActionRouter alloc] init];
        _actionRouter.delegate = self;
    }
    return _actionRouter;
}
@end
