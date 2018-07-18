//
//  UIBarButtonItem+HPUtil.h
//  DZTakeout
//
//  Created by HuangPan on 2018/3/26.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (HPUtil)

/**
 返回图片样式的NavigationItem
 
 @brief 该方法会初始化一个UIButton作为CustomView
 
 @param imageName 图片名称，只支持本地
 @param target 事件响应者
 @param selector 事件
 */
+ (instancetype)itemWithImage:(NSString *)imageName target:(id)target selector:(SEL)selector;

/**
 返回图片样式的NavigationItem
 */
+ (instancetype)itemWithImage:(NSString *)imageName shouldOriginal:(BOOL)original target:(id)target selector:(SEL)selector;

/**
 返回文字样式的NavigationItem，字体大小与颜色固定（导航样式统一），有需要请修改方法实现
 */
+ (instancetype)itemWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
                    titleFont:(UIFont *)titleFont
                       target:(id)target
                     selector:(SEL)selector;

@end
