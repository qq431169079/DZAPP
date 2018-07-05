//
//  RootViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/3/26.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "RootViewController.h"
#import "HomeViewController.h"
#import "DiscoverViewController.h"
#import "MyTreasureViewController.h"
#import "HPNavigationController.h"
#import "HPMacro.h"
#import "HPIMManager.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 字体
    [UITabBarController setAppearanceTitleFont:[UIFont systemFontOfSize:10] color:NAV_FGC shadowColor:nil shadowOffset:CGSizeMake(NAN, NAN) forState:UIControlStateSelected];
    [UITabBarController setAppearanceTitleFont:[UIFont systemFontOfSize:10] color:[UIColor grayColor] shadowColor:nil shadowOffset:CGSizeMake(NAN, NAN) forState:UIControlStateNormal];
    [UITabBarController setTitlePositionAdjustment:UIOffsetMake(0,-3)];
    
    // 登录IM
    [HPIMManager connectWithToken:[UserHelper userToken] success:^(NSString *userId) {
        NSLog(@"userId ---- > %@", userId);
    } error:^(RCConnectErrorCode status) {
        NSLog(@"error ---- > %zd", status);
    } tokenIncorrect:^{
        NSLog(@"tokenIncorrect ---- ");
    }];
}

- (NSArray<UIViewController *> *)tabBarViewControllers {
    
    HPNavigationController *home = [[HPNavigationController alloc] initWithRootViewController:[HomeViewController controller]];
    
    HPNavigationController *discover = [[HPNavigationController alloc] initWithRootViewController:[DiscoverViewController controller]];
    
    HPNavigationController *myTreasure = [[HPNavigationController alloc] initWithRootViewController:[MyTreasureViewController controller]];
    return @[home, discover, myTreasure];
}

- (void)setUpTabBarItems {
    
     [self setTabBarItemAtIndex:0
     title:@"首页"
     normalImage:[UIImage imageNamed:@"tabbar_home_normal"]
     selectedImage:[UIImage imageNamed:@"tabbar_home_highlight"]];
    
     [self setTabBarItemAtIndex:1
     title:@"寻找"
     normalImage:[UIImage imageNamed:@"tabbar_discover_normal"]
     selectedImage:[UIImage imageNamed:@"tabbar_discover_highlight"]];
     
     [self setTabBarItemAtIndex:2
     title:@"我的宝藏"
     normalImage:[UIImage imageNamed:@"tabbar_myTreasure_normal"]
     selectedImage:[UIImage imageNamed:@"tabbar_myTreasure_highlight"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
