//
//  HPNavigationController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/3/26.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "HPNavigationController.h"
#import "UIImage+HPUtil.h"
#import "HPMacro.h"

static CGFloat shadowOpacity = 0.0f;

@interface UINavigationBar (HPShadow)

/**
 *  绘制导航栏阴影
 */
- (void)drawShadowWithOffset:(CGSize)offset radius:(CGFloat)radius color:(UIColor *)color opacity:(CGFloat)opacity;
/**
 *  隐藏导航栏阴影
 */
- (void)hideShadow;
/**
 *  显示导航栏阴影
 */
- (void)showShadow;

@end

@implementation UINavigationBar (HPShadow)

- (void)drawShadowWithOffset:(CGSize)offset radius:(CGFloat)radius color:(UIColor *)color opacity:(CGFloat)opacity {
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    self.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = opacity;
    shadowOpacity = opacity;
    
    self.clipsToBounds = NO;
}

- (void)hideShadow {
    self.layer.shadowOpacity = 0.0f;
}

- (void)showShadow {
    self.layer.shadowOpacity = shadowOpacity;
}

@end



@interface HPNavigationController ()

@end

@implementation HPNavigationController

+ (void)initialize {
    
    NSDictionary *barButtonTitleTextAttributes =
    @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
      NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:barButtonTitleTextAttributes];
    NSDictionary *barButtonItemTextAttributes =
    @{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],
      NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonItemTextAttributes forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavBarBackgroundColor:NAV_FGC];
    [self.navigationBar setShadowImage:[UIImage new]];
    if ([self.navigationBar respondsToSelector:@selector(setTranslucent:)]) {
        self.navigationBar.translucent = NO;
    }
}

- (void)setupNavBarBackgroundColor:(UIColor *)color {
    
    [self.navigationBar setBackgroundImage:[[UIImage imageFromColor:color size:CGSizeMake(1, 1)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}

- (void)drawNavigationBarShadowWithOffset:(CGSize)offset radius:(CGFloat)radius color:(UIColor *)color opacity:(CGFloat)opacity {
    [self.navigationBar drawShadowWithOffset:offset radius:radius color:color opacity:opacity];
}

- (void)hideNavigationBarShadow {
    [self.navigationBar hideShadow];
}

- (void)showNavigationBarShadow {
    [self.navigationBar showShadow];
}

#pragma mark - 状态栏

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

#pragma mark - push操作

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - 旋转
- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
