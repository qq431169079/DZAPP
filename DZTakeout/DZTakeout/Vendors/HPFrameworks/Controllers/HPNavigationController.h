//
//  HPNavigationController.h
//  DZTakeout
//
//  Created by HuangPan on 2018/3/26.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPNavigationController : UINavigationController

/**
 *  绘制导航栏阴影，重新配置将替换原有颜色
 */
- (void)drawNavigationBarShadowWithOffset:(CGSize)offset radius:(CGFloat)radius color:(UIColor *)color opacity:(CGFloat)opacity;
/**
 *  显示导航栏阴影
 */
- (void)hideNavigationBarShadow;
/**
 *  隐藏导航栏阴影
 */
- (void)showNavigationBarShadow;

@end
