//
//  HPTabBarController.h
//  DZTakeout
//
//  Created by HuangPan on 2018/3/26.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITabBarController+HPUtil.h"

@interface HPTabBarController : UITabBarController

- (NSArray<UIViewController *> *)tabBarViewControllers;

- (UIColor *)tabBarBackgroundColor;

- (void)setUpTabBarItems;

@end
