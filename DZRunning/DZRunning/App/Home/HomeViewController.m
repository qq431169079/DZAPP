//
//  HomeViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/3/26.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "HomeViewController.h"

//#import "DZFakeNavigationBar.h"
//#import "TakeawayBusinessListViewController.h"
//#import "DZSearchViewController.h"

#import "DZBMKLocationTool.h"
#import "DZLoadingView.h"
#import "DZLoadingHoldView.h"
@interface HomeViewController ()<
//DZFakeNavigationBarDelegate,
UIScrollViewDelegate,
UIWebViewDelegate,
BMKLocationAuthDelegate,
BMKLocationManagerDelegate
>

@property (nonatomic, strong) UIWebView *webView;
//@property (nonatomic, strong) DZFakeNavigationBar *navBar;
@property (nonatomic, strong) JSContext *context;
@property (nonatomic, strong) BMKLocationManager *locationManager;
@property (nonatomic, weak) DZLoadingView *loadingView;         //下拉刷新的动画
@property (nonatomic, weak) DZLoadingHoldView *loadingHoldView; //加载的动画
@property (nonatomic, assign) BOOL needReload;                  //第一次重载
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.needReload = YES;
    [self.view addSubview:self.webView];
    
    CGFloat navBarH = ASPECT_NAV_HEIGHT;
//    self.navBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, navBarH);
    self.webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - navBarH);
    self.loadingHoldView.hidden = NO;
    [self setLocationManager];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UserHelper cleanAllTemporaryObjects];

}

- (void)setupNavigation {
    self.title = @"抢单";
    self.navigationController.title = @"抢单";
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersNavigationBarHidden {
    return NO;
}
#pragma mark - 定位
-(void)setLocationManager{
    @weakify(self);
    [[DZBMKLocationTool sharedInstance] requestLocationWithReGeocode:YES withNetworkState:NO completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        if (error == nil) {
            
            [__weak_self__ loadWebViewWithLocation:location];
            [__weak_self__ getLocationName:location];
        }
    }];
}

-(void)loadWebViewWithLocation:(BMKLocation *)location{
    
    NSString *homeURL = DZCompeteOrder([DZBMKLocationTool sharedInstance].coordinateStr);
    NSURL *url = [NSURL URLWithString:homeURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self setCookieForURL:request.URL];
    NSDictionary * cookies = [NSHTTPCookie requestHeaderFieldsWithCookies:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:request.URL]];
    [request setHTTPShouldHandleCookies:YES];
    [request setAllHTTPHeaderFields:cookies];

    [self.webView loadRequest:request];
    
}
-(void)getLocationName:(BMKLocation *)location{
    BMKLocationReGeocode *locationReGeocode = location.rgcData;
    NSArray *poiList = locationReGeocode.poiList;
    if (poiList.count>0) {
//        BMKLocationPoi *locationPoi = [poiList firstObject];
//        self.title = locationPoi.name;
    }
}


//#pragma mark - DZFakeNavigationBarDelegate
//- (void)navBar:(DZFakeNavigationBar *)navBar onClickMessageButton:(UIButton *)messageBtn {
//    
//}
//
//- (void)navBar:(DZFakeNavigationBar *)navBar onClickShoppingCartButton:(UIButton *)shoppingCartBtn {
//    
//}
//-(void)navBar:(DZFakeNavigationBar *)navBar onClickSearchBar:(UIButton *)searchBar{
//    DZSearchViewController *searchVC = [[DZSearchViewController alloc] init];
//    [self presentViewController:searchVC animated:YES completion:nil];
//    
//}
#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.context[@"android"] = self;
    [self.loadingHoldView removeFromSuperview];

}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [self setCookieForURL:request.URL];
    return YES;
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
    if (([destn isEqualToString:@"songcan"]||[destn isEqualToString:@"quhuo"] )&& params.count>=2) {
        NSString *latitude = [params firstObject];
        NSString *longitude = params[1];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"选择导航地图" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        //百度地图
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
            UIAlertAction *baiduAction = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSString *baiduURL = [[NSString stringWithFormat:@"baidumap://map/direction?&origin=name:我的位置|latlng:%@&destination=%@&mode=driving",[DZBMKLocationTool sharedInstance].coordinateStr,[NSString stringWithFormat:@"%@,%@",latitude,longitude]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:baiduURL]];
            }];
            [alertController addAction:baiduAction];
        }
        //高德地图
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
            UIAlertAction *baiduAction = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSString *url = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%lf&slon=%lf&sname=我的位置&did=BGVIS2&dlat=%@&dlon=%@&dev=0&m=0&t=0",[DZBMKLocationTool sharedInstance].curLocation.location.coordinate.latitude,[DZBMKLocationTool sharedInstance].curLocation.location.coordinate.longitude, latitude,longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }];
            [alertController addAction:baiduAction];
        }
        
        //苹果地图
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com"]]) {
            UIAlertAction *baiduAction = [UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *urlString = [[NSString stringWithFormat:@"http://maps.apple.com/?daddr=%@",[NSString stringWithFormat:@"%@,%@",latitude,longitude]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
                
            }];
            [alertController addAction:baiduAction];
        }
        
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }

}

#pragma mark - UIScrollViewDelegate

#pragma mark - 其他


-(void)resetWebView{
    [self.loadingView startLoadingAnimation];
    //重新定位
    DZWeakSelf(self)
    [[DZBMKLocationTool sharedInstance] requestLocationWithReGeocode:YES withNetworkState:NO completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        [self.loadingView endLoadingAnimaton];
        if (error == nil) {
            [weakSelf loadWebViewWithLocation:location];
//            [weakSelf getLocationName:location];
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

//- (DZFakeNavigationBar *)navBar {
//    if (!_navBar) {
//        _navBar = [[DZFakeNavigationBar alloc] init];
//        _navBar.title = @"获取位置中...";
//        _navBar.delegate = self;
//        @weakify(self);
//        _navBar.adjustNavBarFrameHandler = ^(CGRect frame) {
//            @strongify(self);
//            CGRect oldFrame = self.webView.frame;
//            oldFrame.origin.y = frame.size.height;
//            oldFrame.size.height = (SCREEN_HEIGHT - frame.size.height);
//            self.webView.frame = oldFrame;
//        };
//    }
//    return _navBar;
//}




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
        [self.webView addSubview:loadingHoldView];
        _loadingHoldView = loadingHoldView;
    }
    return _loadingHoldView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
