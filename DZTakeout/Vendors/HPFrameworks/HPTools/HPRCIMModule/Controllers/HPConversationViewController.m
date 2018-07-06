//
//  HPConversationViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/25.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "HPConversationViewController.h"
#import "UIViewController+HPUtil.h"
@interface HPConversationViewController ()

@end

@implementation HPConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavigation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)setupNavigation{
    if ((self.navigationController && self.navigationController.viewControllers.firstObject != self) || self.navigationController.presentingViewController != nil) {
        [self setLeftBarButtonItem:[self barButtonItemWithTitle:nil normalColor:nil highlightColor:nil normalImage:[UIImage imageNamed:@"nav_nav_icon_back_normal"] highlightImage:nil target:self action:@selector(__onPopBackAction)]];
    }
}
- (void)__onPopBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
