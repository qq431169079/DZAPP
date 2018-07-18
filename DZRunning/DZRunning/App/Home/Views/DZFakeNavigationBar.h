//
//  DZFakeNavigationBar.h
//  DZTakeout
//
//  Created by HuangPan on 2018/3/30.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DZFakeNavigationBar;

@protocol DZFakeNavigationBarDelegate<NSObject>
@optional

- (void)navBar:(DZFakeNavigationBar *)navBar onClickMessageButton:(UIButton *)messageBtn;

- (void)navBar:(DZFakeNavigationBar *)navBar onClickShoppingCartButton:(UIButton *)shoppingCartBtn;

- (void)navBar:(DZFakeNavigationBar *)navBar onClickSearchBar:(UIButton *)searchBar;

- (void)navBar:(DZFakeNavigationBar *)navBar onClickTitleButton:(UIButton *)titleButton;

@end

@interface DZFakeNavigationBar : UIView

@property (nonatomic, weak) id<DZFakeNavigationBarDelegate> delegate;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) BOOL showShadow;

/**
 set backgroundImageView alpha, alpha must " 0 <= alpha <= 1 " .
 */
@property (nonatomic, assign) CGFloat backgroundAlpha;

@property (nonatomic, strong) UIImage *backgroundImage;

@property (nonatomic, strong) UIColor *titleColor;


/**
 监听滑动事件
 */

@property (nonatomic, copy) void (^adjustNavBarFrameHandler)(CGRect frame);

- (void)gradation_scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)gradation_scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

- (void)gradation_scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
@end


