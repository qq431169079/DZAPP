//
//  UITabBarController+HPUtil.h
//  DZTakeout
//
//  Created by HuangPan on 2018/3/26.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (HPUtil)

/**
 设置UITabBar的背景颜色
 
 @param color 背景颜色
 @param clean 是否清除顶部黑线
 */
- (void)setTabBarBackgroundColor:(UIColor *)color andCleanShadow:(BOOL)clean;

/**
 设置UITabBar的背景和分割线颜色
 
 @param color 背景颜色
 @param shadowColor 顶部分割线颜色，原生为黑色
 */
- (void)setTabBarBackgroundColor:(UIColor *)color shadowColor:(UIColor *)shadowColor;

/**
 *  设置Tabbar通用标题属性
 *
 *  @param font         字体
 *  @param color        颜色
 *  @param shadowColor  阴影
 *  @param shadowOffset 阴影偏移或者NANSIZE
 *  @param controlState 状态
 */
+ (void)setAppearanceTitleFont:(UIFont *)font color:(UIColor *)color shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset forState:(UIControlState)controlState;

+ (void)setTitlePositionAdjustment:(UIOffset)offset;

/**
 *  设置自身某个index下tabbarItem的标题和图片
 *
 *  @param title         标题
 *  @param normalImage   正常图片
 *  @param selectedImage 选中图片
 */
- (void)setTabBarItemAtIndex:(NSInteger)index title:(NSString *)title normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage;


/**
 *  设置自身某个index下tabbarItem的的图片
 *
 *  @param normalImage   正常图片
 *  @param selectedImage 选中时图片
 */
- (void)setTabBarItemAtIndex:(NSInteger)index nromalImage:(UIImage *) normalImage selectedImage:(UIImage *)selectedImage;

/**
 *  设置自身某个index下tabbarItem的标题属性
 *
 *  @param font         标题字体
 *  @param color        颜色
 *  @param shadowColor  阴影
 *  @param shadowOffset 阴影偏移或者NANSIZE
 *  @param controlState 状态
 */
- (void)setTabBarItemAtIndex:(NSInteger)index font:(UIFont *)font color:(UIColor *)color shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize) shadowOffset forState:(UIControlState)controlState;

@end
