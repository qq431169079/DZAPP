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

@interface RootViewController ()<RCIMUserInfoDataSource>
@property (nonatomic,assign) NSInteger reloadIMTime;             //尝试重复登陆次数
@property (nonatomic,strong) RCUserInfo *currentUserInfo;
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
        UserModel *model = [UserHelper userItem];
        [RCIM sharedRCIM].userInfoDataSource = self;
        [HPIMManager connectWithToken:[UserHelper userItem].coludtoken success:^(NSString *userId) {
            NSLog(@"userId ---- > %@", userId);
            NSString *img_url = @"http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTIia8vDXHVeygRibKaIqk1ibyCQ5DGQiaVgQ2EiaiaUBKs4VdXNjznAicEMXcBzG6GsBZNyLvd4ma1LESxOw/132";
            if (model.img_url) {
                img_url = model.img_url;
            }
            weakSelf.currentUserInfo = [[RCUserInfo alloc] initWithUserId:userId
                                                                        name:[UserHelper userItem].name
                                                                    portrait:img_url];
            [RCIM sharedRCIM].currentUserInfo = weakSelf.currentUserInfo;
        } error:^(RCConnectErrorCode status) {
            NSLog(@"error ---- > %zd", status);
        } tokenIncorrect:^{
            NSLog(@"tokenIncorrect ---- ");
            weakSelf.reloadIMTime++;
            [weakSelf loginIM];
        }];
    }
}
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
