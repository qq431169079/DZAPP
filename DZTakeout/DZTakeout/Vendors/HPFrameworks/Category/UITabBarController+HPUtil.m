//
//  UITabBarController+HPUtil.m
//  DZTakeout
//
//  Created by HuangPan on 2018/3/26.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "UITabBarController+HPUtil.h"
#import "UIImage+HPUtil.h"

@implementation UITabBarController (HPUtil)

- (void)setTabBarBackgroundColor:(UIColor *)color andCleanShadow:(BOOL)clean {
    [self setTabBarBackgroundColor:color shadowColor:clean ? nil : [UIColor blackColor]];
}

- (void)setTabBarBackgroundColor:(UIColor *)color shadowColor:(UIColor *)shadowColor {
    [self.tabBar setBackgroundImage:[[UIImage imageFromColor:color] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UIImage *shadowImage = shadowColor ? [[UIImage imageFromColor:shadowColor] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] : [UIImage new];
    [self.tabBar setShadowImage:shadowImage];
}

+ (void)setAppearanceTitleFont:(UIFont *)font color:(UIColor *)color shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset forState:(UIControlState)controlState {
    NSDictionary * attributeDictionary = [self mappingValueFromFont:font color:color shadowColor:shadowColor shadowOffset:shadowOffset];
    if (attributeDictionary) {
        [[UITabBarItem appearance] setTitleTextAttributes:attributeDictionary forState:controlState];
    }
}

+ (void)setTitlePositionAdjustment:(UIOffset)offset {
    [[UITabBarItem appearance] setTitlePositionAdjustment:offset];
}

- (void)setTabBarItemAtIndex:(NSInteger)index title:(NSString *)title normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage {
    if (self.tabBar.items.count > index) {
        [UITabBarController setTabBarItem:self.tabBar.items[index] title:title normalImage:normalImage selectedImage:selectedImage];
    }
}

+ (void)setTabBarItem:(UITabBarItem *)tabbarItem title:(NSString *)title normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage {
    if (tabbarItem) {
        tabbarItem.title = title;
        [self setTabBarItem:tabbarItem normalImage:normalImage selectedImage:selectedImage];
    }
}

- (void)setTabBarItemAtIndex:(NSInteger)index nromalImage:(UIImage *) normalImage selectedImage:(UIImage *)selectedImage {
    if ( self.tabBar.items.count > index ) {
        [UITabBarController setTabBarItem:self.tabBar.items[index] normalImage:normalImage selectedImage:selectedImage];
    }
}

+ (void)setTabBarItem:(UITabBarItem *)tabbarItem normalImage:(UIImage *) normalImage selectedImage:(UIImage *)selectedImage {
    if (tabbarItem) {
        if (normalImage) {
            [tabbarItem setImage:[normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        }
        if (selectedImage) {
            [tabbarItem setSelectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        }
    }
}


- (void)setTabBarItemAtIndex:(NSInteger)index font:(UIFont *)font color:(UIColor *)color shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize) shadowOffset forState:(UIControlState)controlState {
    if (index < self.tabBar.items.count) {
        [UITabBarController setTabBarItem:self.tabBar.items[index] font:font color:color shadowColor:shadowColor shadowOffset:shadowOffset forState:controlState];
    }
}

+ (void)setTabBarItem:(UITabBarItem *)tabbarItem font:(UIFont *) font color: (UIColor *)color shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize) shadowOffset forState:(UIControlState)controlState {
    if (tabbarItem) {
        NSDictionary * attributeDictionary = [self mappingValueFromFont:font color:color shadowColor:shadowColor shadowOffset:shadowOffset];
        if (attributeDictionary) {
            [tabbarItem setTitleTextAttributes:attributeDictionary forState:controlState];
        }
    }
}


+ (NSDictionary *)mappingValueFromFont:(UIFont *)font color:(UIColor *)color shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset {
    NSMutableDictionary * mutableDictionary = [NSMutableDictionary dictionaryWithCapacity:4];
    if (font) {
        [mutableDictionary setObject:font forKey:NSFontAttributeName];
    }
    if (color) {
        [mutableDictionary setObject:color forKey:NSForegroundColorAttributeName];
    }
    if (shadowColor && !isnan(shadowOffset.width) && !isnan(shadowOffset.height)) {
        NSShadow * shadow = [[NSShadow alloc] init];
        shadow.shadowColor = shadowColor;
        shadow.shadowOffset = shadowOffset;
        [mutableDictionary setObject:shadow forKey:NSShadowAttributeName];
    }
    if (mutableDictionary.count > 0) {
        return mutableDictionary.copy;
    }
    return nil;
}
@end
