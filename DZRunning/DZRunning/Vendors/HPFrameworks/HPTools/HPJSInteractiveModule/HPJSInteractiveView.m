//
//  HPJSInteractiveView.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/11.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "HPJSInteractiveView.h"

@interface HPJSInteractiveView ()<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *wkWebView;

@end

@implementation HPJSInteractiveView

#pragma mark - Initialize
- (instancetype)initWithFrame:(CGRect)frame config:(nonnull WKWebViewConfiguration *)config {
    if (!config) { return nil; }
    self = [super initWithFrame:frame];
    if (self) {
        _config = config;
        [self setupSubviews];
    }
    return self;
}

+ (instancetype)viewWithFrame:(CGRect)frame config:(WKWebViewConfiguration *)config {
    return [[self alloc] initWithFrame:frame config:config];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.wkWebView.frame = self.bounds;
}

- (void)setupSubviews {
    [self addSubview:self.wkWebView];
    /*
     WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
     configuration.preferences.javaScriptEnabled = YES;
     configuration.preferences.javaScriptCanOpenWindowsAutomatically = YES;
     configuration.preferences.minimumFontSize = 10;
     configuration.selectionGranularity = WKSelectionGranularityCharacter;
     configuration.userContentController = self.userContentController;
     */
}

#pragma mark - WKNavigationDelegate
#pragma mark - WKUIDelegate
#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
}
#pragma mark - Public
- (nullable WKNavigation *)loadRequest:(NSURLRequest *)request; {
    return [self.wkWebView loadRequest:request];
}

- (nullable WKNavigation *)reload {
    return [self.wkWebView reload];
}

#pragma mark - Getter & Setter
- (void)setScrollDelegate:(id<UIScrollViewDelegate>)scrollDelegate {
    _scrollDelegate = scrollDelegate;
    _wkWebView.scrollView.delegate = _scrollDelegate;
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc]initWithFrame:self.bounds configuration:self.config];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
    }
    return _wkWebView;
}

@end
