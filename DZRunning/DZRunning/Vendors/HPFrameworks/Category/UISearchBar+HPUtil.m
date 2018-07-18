//
//  UISearchBar+MTUtil.m
//  xsh
//
//  Created by HuangPan on 2018/2/24.
//  Copyright © 2018年 Moemoe Technology. All rights reserved.
//

#import "UISearchBar+HPUtil.h"
#import "UIView+HPUtil.h"
#import <objc/runtime.h>

@implementation UISearchBar (HPUtil)

- (void)setClipCornerRadius:(CGFloat)clipCornerRadius {
    
    objc_setAssociatedObject(self, @selector(clipCornerRadius), @(clipCornerRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UIView *tmpView = [self subviewOfClassName:@"_UISearchBarSearchFieldBackgroundView"];
    if (tmpView && [tmpView isKindOfClass:UIView.class]) {
        tmpView.layer.cornerRadius = clipCornerRadius;
        tmpView.clipsToBounds = YES;
    }
}

- (CGFloat)clipCornerRadius {
    return [objc_getAssociatedObject(self, @selector(clipCornerRadius)) floatValue];
}


- (void)setFont:(UIFont *)font {
    objc_setAssociatedObject(self, @selector(font), font, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UITextField *searchField = [self valueForKey:@"_searchField"];
    if (searchField &&
        [searchField isKindOfClass:UITextField.class]) {
        searchField.font = font;
    }
}

- (UIFont *)font {
    UIFont *font = objc_getAssociatedObject(self, @selector(font));
    if (!font) {
        UITextField *searchField = [self valueForKey:@"_searchField"];
        if (searchField &&
            [searchField isKindOfClass:UITextField.class]) {
            self.font = searchField.font;
            font = searchField.font;
        }
    }
    return font;
}
@end
