//
//  HPViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/3/26.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "HPViewController.h"
#import <IQKeyboardManager.h>

@interface HPViewController () {

    UIStatusBarStyle _super_statusBarStyle;
    
    BOOL _super_openNavBarHiddenStatusMonitorSwitch;
}

@end

@implementation HPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    _visiable = YES;
    _super_openNavBarHiddenStatusMonitorSwitch = NO;
    
    //导航栏控制器动画
    if (![self prefersNavigationBarHidden]) {
        if (self.navigationController.navigationBarHidden) {
            [self.navigationController setNavigationBarHidden:NO animated:animated];
        }
    } else {
        if (!self.navigationController.navigationBarHidden) {
            [self.navigationController setNavigationBarHidden:YES animated:animated];
        }
    }
    
    //工具栏控制器动画
    if (![self prefersToolBarHidden]) {
        if (self.navigationController.isToolbarHidden) {
            [self.navigationController setToolbarHidden:NO animated:animated];
        }
    } else {
        if (!self.navigationController.isToolbarHidden) {
            [self.navigationController setToolbarHidden:YES animated:animated];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    _super_openNavBarHiddenStatusMonitorSwitch = YES;
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    //导航栏控制器动画
    if (_super_openNavBarHiddenStatusMonitorSwitch) {
        if (![self prefersNavigationBarHidden]) {
            if (self.navigationController.navigationBarHidden) {
                [self.navigationController setNavigationBarHidden:NO animated:NO];
            }
        } else {
            if (!self.navigationController.navigationBarHidden) {
                [self.navigationController setNavigationBarHidden:YES animated:NO];
            }
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _visiable = NO;
    _super_openNavBarHiddenStatusMonitorSwitch = NO;
}

- (void)setUpdateStatusBarAppearance:(UIStatusBarStyle)statusBarStyle {
    if (_super_statusBarStyle == statusBarStyle) {
        return;
    }
    _super_statusBarStyle = statusBarStyle;
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return _super_statusBarStyle;
}

- (BOOL)prefersNavigationBarHidden {
    return NO;
}

- (BOOL)prefersToolBarHidden {
    
    return YES;
}

#pragma mark - Rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
