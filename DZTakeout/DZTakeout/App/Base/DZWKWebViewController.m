//
//  DZWKWebViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/9.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZWKWebViewController.h"
#import "DZLoadingHoldView.h"

@interface DZWKWebViewController ()<UIWebViewDelegate>


@property (nonatomic, strong) JSContext *context;
@property (nonatomic, weak) DZLoadingHoldView *loadingHoldView;//加载的动画
@property (nonatomic,strong) NSString *curURL;

@end

@implementation DZWKWebViewController

#pragma mark - Dealloc
- (void)dealloc {
    _webView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
    UIEdgeInsets insets = [self webViewEdges];
    @weakify(self);
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.view).offset(insets.top);
        make.left.equalTo(self.view).offset(insets.left);
        make.right.equalTo(self.view).offset(insets.right);
        make.bottom.equalTo(self.view).offset(insets.bottom);
    }];
}

- (BOOL)prefersNavigationBarHidden {
    return NO;
}

#pragma mark - Initialize Methods
- (UIEdgeInsets)webViewEdges {
    return UIEdgeInsetsZero;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.context[@"android"] = self;

    [self.loadingHoldView setImageWithRequestResult:DZRequestSuccess];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.loadingHoldView setImageWithRequestResult:DZRequestLoading];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.loadingHoldView setImageWithRequestResult:DZRequestFailure];
}
#pragma mark - DZJSInteractiveExport
- (void)base:(JSValue *)destn {
    _hy_dispatch_main_async_safe(^{
        [self launch:[destn toString]];
    });
}

- (void)valLink:(JSValue *)destn final:(JSValue *)param {
    _hy_dispatch_main_async_safe(^{
        [self launch:[destn toString] withParam:[param toString]];
    });
    NSLog(@"");
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

- (void)launch:(NSString *)destn {
    if ([destn isEqualToString:@"finish"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIViewController *controler = [DZJSInteractiveRouter instanceFromDestn:destn];
        [DZJSInteractiveRouter nav:self.navigationController needsPush:controler animated:YES];
    }

}

- (void)launch:(NSString *)destn withParam:(NSString *)param {
    if ([destn isEqualToString:@"alert"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:param message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        UIViewController *controler = [DZJSInteractiveRouter instanceFromDestn:destn param:param];
        [DZJSInteractiveRouter nav:self.navigationController needsPush:controler animated:YES];
    }

}

- (void)launch:(NSString *)destn withParams:(NSArray<NSString *> *)params {
    UIViewController *controler = [DZJSInteractiveRouter instanceFromDestn:destn params:params];
    [DZJSInteractiveRouter nav:self.navigationController needsPush:controler animated:YES];
}

#pragma mark - public
- (void)loadWebViewWithURL:(NSString *)urlString {
    if (!urlString || urlString.length == 0) {return;};
    [self loadWebView:urlString params:nil];
}

- (void)loadWebView:(NSString *)urlString params:(NSDictionary *)params{
    if (params) {
        NSMutableString *paramsString = [[NSMutableString alloc] initWithString:urlString];
        [paramsString appendString:@"?"];
        for (NSString *key in params.allKeys) {
            [paramsString appendString:[NSString stringWithFormat:@"%@=%@",key,params[key]]];
            [paramsString appendString:@"&"];
        }
        if (paramsString.length > 1) {
            urlString = [paramsString substringToIndex:paramsString.length - 1];
        } else {
            urlString = paramsString.copy;
        }
    }
    self.curURL = urlString;
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [self.webView loadRequest:request];
}

#pragma mark - Getter & Setter
- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}

-(DZLoadingHoldView *)loadingHoldView{
    if (_loadingHoldView == nil) {
        DZLoadingHoldView *loadingHoldView = [[NSBundle mainBundle] loadNibNamed:@"DZLoadingHoldView" owner:nil options:nil].firstObject;
        loadingHoldView.frame = self.webView.bounds;
        DZWeakSelf(self)
        loadingHoldView.reResultBlock = ^{
            [weakSelf loadWebViewWithURL:weakSelf.curURL];
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

@end
