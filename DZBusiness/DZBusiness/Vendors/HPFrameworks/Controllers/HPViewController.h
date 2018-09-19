//
//  HPViewController.h
//  DZTakeout
//
//  Created by HuangPan on 2018/3/26.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "HPBaseViewController.h"

@interface HPViewController : HPBaseViewController

/**
 *  是否已经在最前
 */
@property (nonatomic, readonly, assign, getter=isVisiable) BOOL visiable;

/**
 是否显示导航栏
 
 @return YES: 隐藏； NO：显示
 */
- (BOOL)prefersNavigationBarHidden;

/**
 是否显示工具栏

 @return YES: 隐藏； NO：显示
 */
- (BOOL)prefersToolBarHidden;

/**
 更新状态栏颜色
 */
- (void)setUpdateStatusBarAppearance:(UIStatusBarStyle)statusBarStyle;

@end
