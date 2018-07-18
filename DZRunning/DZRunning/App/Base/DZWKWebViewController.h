//
//  DZWKWebViewController.h
//  DZTakeout
//
//  Created by HuangPan on 2018/6/9.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "HPViewController.h"
#import "DZJSInteractiveExport.h"

@interface DZWKWebViewController : HPViewController<DZJSInteractiveExport>

/**
 * 不带其他参数的
 * urlString
 */
- (void)loadWebViewWithURL:(NSString *)urlString;

/**
 * 带参数的
 * urlString
 * params 参数用字典的形式传入(字典的key必须是请求的参数key)
 */
- (void)loadWebView:(NSString *)urlString params:(NSDictionary *)params;

#pragma mark - Initialize Methods
/**
 webview布局

 @return 边距
 */
- (UIEdgeInsets)webViewEdges;

#pragma mark - JSInteractive Methods

/**
 调起控制器

 @param destn 目标控制器
 */
- (void)launch:(NSString *)destn;

/**
 调起控制器

 @param destn 目标控制器
 @param param 参数
 */
- (void)launch:(NSString *)destn withParam:(NSString *)param;

@end
