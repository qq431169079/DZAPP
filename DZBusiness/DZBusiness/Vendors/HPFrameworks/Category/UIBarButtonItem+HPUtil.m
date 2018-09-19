//
//  UIBarButtonItem+HPUtil.m
//  DZTakeout
//
//  Created by HuangPan on 2018/3/26.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "UIBarButtonItem+HPUtil.h"
#import "UIButton+HPUtil.h"

@implementation UIBarButtonItem (HPUtil)

/**
 返回图片样式的NavigationItem
 
 @brief 该方法会初始化一个UIButton作为CustomView
 
 @param imageName 图片名称，只支持本地
 @param target 事件响应者
 @param selector 事件
 */
+ (instancetype)itemWithImage:(NSString *)imageName target:(id)target selector:(SEL)selector {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.imageOfNormal = [UIImage imageNamed:imageName];
    [btn sizeToFit];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

/**
 返回图片样式的NavigationItem
 */
+ (instancetype)itemWithImage:(NSString *)imageName shouldOriginal:(BOOL)original target:(id)target selector:(SEL)selector {
    
    UIImage *image = [UIImage imageNamed:imageName];
    if (original) {
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    NSAssert(image != nil, @"找不到对应的导航栏返回按钮");
    
    return [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:selector];
}

+ (instancetype)itemWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
                    titleFont:(UIFont *)titleFont
                       target:(id)target
                     selector:(SEL)selector {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.titleLabel.font = titleFont;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
