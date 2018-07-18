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
@property (nonatomic,assign) NSInteger reloadIMTime;             //尝试重复登陆次数
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 字体
    [UITabBarController setAppearanceTitleFont:[UIFont systemFontOfSize:10] color:NAV_FGC shadowColor:nil shadowOffset:CGSizeMake(NAN, NAN) forState:UIControlStateSelected];
    [UITabBarController setAppearanceTitleFont:[UIFont systemFontOfSize:10] color:[UIColor grayColor] shadowColor:nil shadowOffset:CGSizeMake(NAN, NAN) forState:UIControlStateNormal];
    [UITabBarController setTitlePositionAdjustment:UIOffsetMake(0,-3)];
    [self loginIM];
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
#pragma mark - 其他
-(void)loginIM{
    if (self.reloadIMTime < 3) {
        // 登录IM
        DZWeakSelf(self)
        [HPIMManager connectWithToken:@"t3UwLk3xX2HdKPPTujISyK27jFyFYCGid8Bhacdkh36tCaeHVseIYmM+2IMksCgz+C7V/wHMCbM0E3UkmrFQwA==" success:^(NSString *userId) {
            NSLog(@"userId ---- > %@", userId);
            RCUserInfo *currentUserInfo = [[RCUserInfo alloc] initWithUserId:userId
                                                                        name:[UserHelper userItem].name
                                                                    portrait:@"http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTIia8vDXHVeygRibKaIqk1ibyCQ5DGQiaVgQ2EiaiaUBKs4VdXNjznAicEMXcBzG6GsBZNyLvd4ma1LESxOw/132"];
            [RCIM sharedRCIM].currentUserInfo = currentUserInfo;
        } error:^(RCConnectErrorCode status) {
            NSLog(@"error ---- > %zd", status);
        } tokenIncorrect:^{
            NSLog(@"tokenIncorrect ---- ");
            weakSelf.reloadIMTime++;
            [weakSelf loginIM];
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end