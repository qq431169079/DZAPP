//
//  UIButton+HPUtil.m
//  DZTakeout
//
//  Created by HuangPan on 2018/3/26.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "UIButton+HPUtil.h"
#import "UIImage+HPUtil.h"

@implementation UIButton (HPUtil)

#pragma mark - 标题
- (NSString *)titleOfNormal {
    return [self titleForState:UIControlStateNormal];
}

- (void)setTitleOfNormal:(NSString *)titleOfNormal {
    [self setTitle:titleOfNormal forState:UIControlStateNormal];
}

- (NSString *)titleOfDisabled {
    return [self titleForState:UIControlStateDisabled];
}

- (void)setTitleOfDisabled:(NSString *)titleOfDisabled {
    [self setTitle:titleOfDisabled forState:UIControlStateDisabled];
}

- (NSString *)titleOfHighlighted {
    return [self titleForState:UIControlStateHighlighted];
}

- (void)setTitleOfHighlighted:(NSString *)titleOfHighlighted {
    [self setTitle:titleOfHighlighted forState:UIControlStateHighlighted];
}

- (NSString *)titleOfSelected {
    return [self titleForState:UIControlStateSelected];
}

- (void)setTitleOfSelected:(NSString *)titleOfSelected {
    [self setTitle:titleOfSelected forState:UIControlStateSelected];
}

#pragma mark - 标题颜色
- (UIColor *)titleColorOfNormal {
    return [self titleColorForState:UIControlStateNormal];
}

- (void)setTitleColorOfNormal:(UIColor *)titleColorOfNormal {
    [self setTitleColor:titleColorOfNormal forState:UIControlStateNormal];
}

- (UIColor *)titleColorOfDisabled {
    return [self titleColorForState:UIControlStateDisabled];
}

- (void)setTitleColorOfDisabled:(UIColor *)titleColorOfDisabled {
    [self setTitleColor:titleColorOfDisabled forState:UIControlStateDisabled];
}

- (UIColor *)titleColorOfSelected {
    return [self titleColorForState:UIControlStateSelected];
}

- (void)setTitleColorOfSelected:(UIColor *)titleColorOfSelected {
    [self setTitleColor:titleColorOfSelected forState:UIControlStateSelected];
}

- (UIColor *)titleColorOfHighlighted {
    return [self titleColorForState:UIControlStateHighlighted];
}

- (void)setTitleColorOfHighlighted:(UIColor *)titleColorOfHighlighted {
    [self setTitleColor:titleColorOfHighlighted forState:UIControlStateHighlighted];
}

#pragma mark - 按钮图片
- (UIImage *)imageOfNormal {
    return [self imageForState:UIControlStateNormal];
}

- (void)setImageOfNormal:(UIImage *)imageOfNormal {
    [self setImage:imageOfNormal forState:UIControlStateNormal];
}

- (UIImage *)imageOfDisabled {
    return [self imageForState:UIControlStateDisabled];
}

- (void)setImageOfDisabled:(UIImage *)imageOfDisabled {
    [self setImage:imageOfDisabled forState:UIControlStateDisabled];
}

- (UIImage *)imageOfSelected {
    return [self imageForState:UIControlStateSelected];
}

- (void)setImageOfSelected:(UIImage *)imageOfSelected {
    [self setImage:imageOfSelected forState:UIControlStateSelected];
}

- (UIImage *)imageOfHighlighted {
    return [self imageForState:UIControlStateHighlighted];
}

- (void)setImageOfHighlighted:(UIImage *)imageOfHighlighted{
    [self setImage:imageOfHighlighted forState:UIControlStateHighlighted];
}

#pragma mark - 背景颜色
- (UIColor *)backgroudColorOfNormal {
    return [UIColor colorWithPatternImage:self.backgroudImageOfNormal];
}

- (void)setBackgroudColorOfNormal:(UIColor *)backgroudColorOfNormal {
    if (backgroudColorOfNormal) {
        self.backgroudImageOfNormal = [UIImage imageFromColor:backgroudColorOfNormal size:CGSizeMake(1, 1)];
    }
}

- (UIColor *)backgroudColorOfDisabled {
    return [UIColor colorWithPatternImage:self.backgroudImageOfDisabled];
}

- (void)setBackgroudColorOfDisabled:(UIColor *)backgroudColorOfDisabled {
    if (backgroudColorOfDisabled) {
        self.backgroudImageOfDisabled = [UIImage imageFromColor:backgroudColorOfDisabled size:CGSizeMake(1, 1)];
    }
}

- (UIColor *)backgroudColorOfSelected {
    return [UIColor colorWithPatternImage:self.backgroudImageOfSelected];
}

- (void)setBackgroudColorOfSelected:(UIColor *)backgroudColorOfSelected {
    if (backgroudColorOfSelected) {
        self.backgroudImageOfSelected = [UIImage imageFromColor:backgroudColorOfSelected size:CGSizeMake(1, 1)];
    }
}

- (UIColor *)backgroudColorOfHighlighted {
    return [UIColor colorWithPatternImage:self.backgroudImageOfHighlighted];
}

- (void)setBackgroudColorOfHighlighted:(UIColor *)backgroudColorOfHighlighted {
    if (backgroudColorOfHighlighted) {
        self.backgroudImageOfHighlighted= [UIImage imageFromColor:backgroudColorOfHighlighted size:CGSizeMake(1, 1)];
    }
}

#pragma mark - 背景图片
- (UIImage *)backgroudImageOfNormal {
    return [self backgroundImageForState:UIControlStateNormal];
}

- (void)setBackgroudImageOfNormal:(UIImage *)backgroudImageOfNormal {
    [self setBackgroundImage:backgroudImageOfNormal forState:UIControlStateNormal];
}

- (UIImage *)backgroudImageOfDisabled {
    return [self backgroundImageForState:UIControlStateDisabled];
}

- (void)setBackgroudImageOfDisabled:(UIImage *)backgroudImageOfDisabled {
    [self setBackgroundImage:backgroudImageOfDisabled forState:UIControlStateDisabled];
}

- (UIImage *)backgroudImageOfSelected {
    return [self backgroundImageForState:UIControlStateSelected];
}

- (void)setBackgroudImageOfSelected:(UIImage *)backgroudImageOfSelected {
    [self setBackgroundImage:backgroudImageOfSelected forState:UIControlStateSelected];
}

- (UIImage *)backgroudImageOfHighlighted {
    return [self backgroundImageForState:UIControlStateHighlighted];
}

- (void)setBackgroudImageOfHighlighted:(UIImage *)backgroudImageOfHighlighted {
    [self setBackgroundImage:backgroudImageOfHighlighted forState:UIControlStateHighlighted];
}

@end
