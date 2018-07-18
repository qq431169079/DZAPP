//
//  HPTabBarController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/3/26.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "HPTabBarController.h"

@interface HPTabBarController ()<UITabBarControllerDelegate>

@end

@implementation HPTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewControllers = [self tabBarViewControllers];
    [self setTabBarBackgroundColor:[self tabBarBackgroundColor] andCleanShadow:YES];
    [self setUpTabBarItems];
}

- (NSArray<UIViewController *> *)tabBarViewControllers {
    
    // Crude way to emulate "abstract" class
    [self doesNotRecognizeSelector:_cmd];
    
    return nil;
}

- (void)setUpTabBarItems {
    
    // Crude way to emulate "abstract" class
    [self doesNotRecognizeSelector:_cmd];
    
    /*
    [self setTabBarItemAtIndex:0
                         title:L(@"Title.Page.Home")
                   normalImage:[UIImage imageNamed:@"tabbar_icon_home_normal"]
                 selectedImage:[UIImage imageNamed:@"tabbar_icon_home_selected"]];
    
    [self setTabBarItemAtIndex:1
                         title:L(@"Title.Page.Find")
                   normalImage:[UIImage imageNamed:@"tabbar_icon_find_normal"]
                 selectedImage:[UIImage imageNamed:@"tabbar_icon_find_selected"]];
    
    [self setTabBarItemAtIndex:2
                         title:L(@"Title.Page.IM")
                   normalImage:[UIImage imageNamed:@"tabbar_icon_message_normal"]
                 selectedImage:[UIImage imageNamed:@"tabbar_icon_message_selected"]];
    
    [self setTabBarItemAtIndex:3
                         title:L(@"Title.Page.Mine")
                   normalImage:[UIImage imageNamed:@"tabbar_icon_me_normal"]
                 selectedImage:[UIImage imageNamed:@"tabbar_icon_me_selected"]];
     */
}

- (UIColor *)tabBarBackgroundColor {
    
    return [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
