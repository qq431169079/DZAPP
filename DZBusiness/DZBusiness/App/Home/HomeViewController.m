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
    CGFloat navBarH = ASPECT_STATUS_BAR_H;
    CGFloat iphoneX = ASPECT_HOME_INDICATOR_H;
    self.webView.frame = CGRectMake(0, navBarH, SCREEN_WIDTH, SCREEN_HEIGHT - navBarH-iphoneX);
    self.loadingHoldView.hidden = NO;
    [self loadWebView];
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
//-(void)setLocationManager{
//    @weakify(self);
//    [[DZBMKLocationTool sharedInstance] requestLocationWithReGeocode:YES withNetworkState:NO completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
//        if (error == nil) {
//
//            [__weak_self__ loadWebViewWithLocation:location];
//            [__weak_self__ getLocationName:location];
//        }
//    }];
//}

-(void)loadWebView{
    
    NSString *homeURL = DZDingDan;
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
    NSLog(@"___");

}

#pragma mark - UIScrollViewDelegate

#pragma mark - 其他


//-(void)resetWebView{
//    [self.loadingView startLoadingAnimation];
//    //重新定位
//    DZWeakSelf(self)
//    [[DZBMKLocationTool sharedInstance] requestLocationWithReGeocode:YES withNetworkState:NO completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
//        [self.loadingView endLoadingAnimaton];
//        if (error == nil) {
//            [weakSelf loadWebViewWithLocation:location];
////            [weakSelf getLocationName:location];
//        }
//    }];
//}


-(void)setCookieForURL:(NSURL *)url{
    if ([UserHelper userToken].length >1 && [UserHelper userItem].companyId.length >0) {
        NSMutableArray *cookies = [NSMutableArray array];
        for (int i=0; i<2; i++) {
            
            NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
            
            if (i==0) {
                
                [cookieProperties setObject:@"token" forKey:NSHTTPCookieName];
                
                [cookieProperties setObject:[UserHelper userToken] forKey:NSHTTPCookieValue];
                
            }
            
            if (i==1) {
                
                [cookieProperties setObject:@"cid" forKey:NSHTTPCookieName];
                
                [cookieProperties setObject:[UserHelper userItem].companyId forKey:NSHTTPCookieValue];
                
            }

            
            [cookieProperties setObject:@"dzBusiness" forKey:NSHTTPCookieDomain];
            
            [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
            
            [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
            [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
            NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
            
            [cookies addObject:cookie];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
        
        for (NSHTTPCookie *cookie in cookies){
            // cookiesWithResponseHeaderFields方法，需要为URL设置一个cookie为NSDictionary类型的header，注意NSDictionary里面的forKey需要是@"Set-Cookie"
            NSString *str = [[NSString alloc] initWithFormat:@"%@=%@",[cookie name],[cookie value]];
            NSDictionary *dic = [NSDictionary dictionaryWithObject:str forKey:@"Set-Cookie"];
            NSArray *headeringCookie = [NSHTTPCookie cookiesWithResponseHeaderFields:dic forURL:url];
            // 设置Cookie，只要访问URL为HOST的网页时，会自动附带上设置的header
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:headeringCookie
                                                               forURL:url
                                                      mainDocumentURL:nil];
        }
        
    }
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
