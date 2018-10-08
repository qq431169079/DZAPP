//
//  DZRedPackViewController.m
//  DZTakeout
//
//  Created by 林鸿键 on 2018/10/8.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZRedPackViewController.h"
#import "UIViewController+HPUtil.h"
#import "UIImage+HPUtil.h"
@interface DZRedPackViewController ()

@end

@implementation DZRedPackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupNav{
    self.title = @"啄呗官方红包群";
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageFromColor:NAV_FGC size:CGSizeMake(1, 1)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self setLeftBarButtonItem:[self barButtonItemWithTitle:nil normalColor:nil highlightColor:nil normalImage:[UIImage imageNamed:@"nav_nav_icon_back_normal"] highlightImage:nil target:self action:@selector(backAction)]];
}
-(void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
