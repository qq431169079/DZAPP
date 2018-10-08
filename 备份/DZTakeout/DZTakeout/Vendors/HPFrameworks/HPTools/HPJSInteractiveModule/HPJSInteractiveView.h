//
//  HPJSInteractiveView.h
//  DZTakeout
//
//  Created by HuangPan on 2018/6/11.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPJSInteractiveView : UIView

@property (nonatomic, weak) id<UIScrollViewDelegate> scrollDelegate;
@property (nonatomic, strong, readonly) WKWebViewConfiguration *config;

#pragma mark - Initialize
- (instancetype)initWithFrame:(CGRect)frame config:(WKWebViewConfiguration *)config;
+ (instancetype)viewWithFrame:(CGRect)frame config:(WKWebViewConfiguration *)config;

#pragma mark - Public
- (nullable WKNavigation *)reload;
- (nullable WKNavigation *)loadRequest:(NSURLRequest *)request;
@end

NS_ASSUME_NONNULL_END
