//
//  HPViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/3/26.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "HPViewController.h"
#import <IQKeyboardManager.h>
#import "DZBMKLocationTool.h"
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


-(void)setCookieForURL:(NSURL *)url{
    if ([UserHelper userToken].length >1 && [DZBMKLocationTool sharedInstance].coordinateStr.length >1) {
        NSMutableArray *cookies = [NSMutableArray array];
        for (int i=0; i<2; i++) {
            
            NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
            
            if (i==0) {
                
                [cookieProperties setObject:@"token" forKey:NSHTTPCookieName];
                
                [cookieProperties setObject:[UserHelper userToken] forKey:NSHTTPCookieValue];
                
            }
            
            if (i==1) {
                
                [cookieProperties setObject:@"lng" forKey:NSHTTPCookieName];
                
                [cookieProperties setObject:[DZBMKLocationTool sharedInstance].coordinateStr forKey:NSHTTPCookieValue];
                
            }
            
            
            [cookieProperties setObject:@"dzRunning" forKey:NSHTTPCookieDomain];
            
            [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
            
            [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
            [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
            NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
            
            [cookies addObject:cookie];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
        
        for (NSHTTPCookie *cookie in cookies){
            // cookiesWithResponseHeaderFields方法，需要为URL设置一个cookie为NSDictionary类型的header，注意NSDictionary里面的forKey需要是@"Set-Cookie"
            NSString *str = [[NSString alloc] initWithFormat:@"%@=%@",[cookie name],[cookie value]];
            NSDictionary *dic = [NSDictionary dictionaryWithObject:str forKey:@"Set-Cookie"];
            NSArray *headeringCookie = [NSHTTPCookie cookiesWithResponseHeaderFields:dic forURL:url];
            // 设置Cookie，只要访问URL为HOST的网页时，会自动附带上设置的header
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:headeringCookie
                                                               forURL:url
                                                      mainDocumentURL:nil];
        }
        
    }
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
