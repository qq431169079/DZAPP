//
//  UIViewController+HPUtil.m
//  DZTakeout
//
//  Created by HuangPan on 2018/3/26.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "UIViewController+HPUtil.h"
#import "UIImage+HPUtil.h"

@implementation UIViewController (NavBarItems)

- (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title
                                normalColor:(UIColor *)normalColor
                             highlightColor:(UIColor *)highlightColor
                                normalImage:(UIImage *)normalImage
                             highlightImage:(UIImage *)highlightImage
                                     target:(id)target
                                     action:(SEL)action
{
    UIButton * button = [self buttonWithTitle:title highlightTitle:nil selectedTitle:nil disableTitle:nil
                                  normalColor:normalColor highlightColor:highlightColor selectedColor:nil disableColor:nil
                                  normalImage:normalImage highlightImage:highlightImage selectedImage:nil disableImage:nil
                                       target:target action:action event:UIControlEventTouchUpInside];
    CGRect frame = button.frame;
    if (frame.size.width<30) {
        frame.size = CGSizeMake(30, 30);
    }
    button.frame = frame;
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (UIButton *)buttonWithTitle:(NSString *)normalTitle
               highlightTitle:(NSString *)highlightTitle
                selectedTitle:(NSString *)selectedTitle
                 disableTitle:(NSString *)disableTitle
                  normalColor:(UIColor *)normalColor
               highlightColor:(UIColor *)highlightColor
                selectedColor:(UIColor *)selectedColor
                 disableColor:(UIColor *)disableColor
                  normalImage:(UIImage *)normalImage
               highlightImage:(UIImage *)highlightImage
                selectedImage:(UIImage *)selectedImage
                 disableImage:(UIImage *)disableImage
                       target:(id)target
                       action:(SEL)action
                        event:(UIControlEvents)controlEvents
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    if (normalTitle) {
        [button setTitle:normalTitle forState:UIControlStateNormal];
    }
    if (highlightTitle) {
        [button setTitle:highlightTitle forState:UIControlStateHighlighted];
    }
    if (selectedTitle) {
        [button setTitle:selectedTitle forState:UIControlStateSelected];
    }
    if (disableTitle) {
        [button setTitle:disableTitle forState:UIControlStateDisabled];
    }
    if (normalColor) {
        [button setTitleColor:normalColor forState:UIControlStateNormal];
    }
    if (highlightColor) {
        [button setTitleColor:highlightColor forState:UIControlStateHighlighted];
    }
    if (selectedColor) {
        [button setTitleColor:selectedColor forState:UIControlStateSelected];
    }
    if (disableColor) {
        [button setTitleColor:disableColor forState:UIControlStateDisabled];
    }
    if (normalImage) {
        [button setImage:normalImage forState:UIControlStateNormal];
    }
    if (highlightImage) {
        [button setImage:highlightImage forState:UIControlStateHighlighted];
    }
    if (selectedImage) {
        [button setImage:selectedImage forState:UIControlStateSelected];
    }
    if (disableImage) {
        [button setImage:disableImage forState:UIControlStateDisabled];
    }
    if (target && action) {
        [button addTarget:target action:action forControlEvents:controlEvents];
    }
    [button sizeToFit];
    return button;
}

@end



@implementation UIViewController (NavBarSetting)

- (void)setLeftBarButtonItem:(UIBarButtonItem *)item {
    [self setLeftBarButtonItems:item ? @[item] : nil];
}

- (void)setLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)leftBarButtonItems {
    [self setLeftBarButtonItems:leftBarButtonItems fixedSpace:-8];
}

- (void)setLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)leftBarButtonItems fixedSpace:(CGFloat)space {
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = space;
    NSMutableArray * items = [NSMutableArray arrayWithArray:leftBarButtonItems];
    [items insertObject:spaceItem atIndex:0];
    self.navigationItem.leftBarButtonItems = items;
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)item {
    [self setRightBarButtonItems: item ? @[item] : nil];
}

- (void)setRightBarButtonItems:(NSArray<UIBarButtonItem *> *)leftBarButtonItems {
    [self setRightBarButtonItems:leftBarButtonItems fixedSpace:-8];
}

- (void)setRightBarButtonItems:(NSArray<UIBarButtonItem *> *)leftBarButtonItems fixedSpace:(CGFloat)space {
    
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = space;
    NSMutableArray * items = [NSMutableArray arrayWithArray:leftBarButtonItems];
    [items insertObject:spaceItem atIndex:0];
    self.navigationItem.rightBarButtonItems = items;
}

- (void)setNavigationBarColor:(UIColor *)color {
    
    if (color && self.navigationController) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageFromColor:color] forBarMetrics:UIBarMetricsDefault];
        // 去掉iOS6之后navigationBar底部的黑线
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }
}

@end
