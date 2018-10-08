//
//  MyCollectsViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/20.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "MyCollectsViewController.h"
#import "UIViewController+HPUtil.h"
@interface MyCollectsViewController ()
@property (nonatomic,strong) UIButton *deleteBtn;
@end

@implementation MyCollectsViewController
#pragma mark - Initialize Methods
- (void)setupNavigation {
    self.title = @"收藏";
    [self setRightBarButtonItem:[self barButtonItemWithTitle:@"编辑" selectedTitle:@"取消" normalColor:[UIColor whiteColor] highlightColor:nil selectedColor:[UIColor whiteColor] normalImage:nil highlightImage:nil target:self action:@selector(editCollects:)]];
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
        [self setupNavigation];
    // Do any additional setup after loading the view.
    [self loadWebViewWithURL:DZUserFavorite([UserHelper userToken])];
}

-(void)editCollects:(UIButton *)editBtn {
    editBtn.selected = !editBtn.selected;
    if (editBtn.selected) {
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.noneCheckbox()"]];
    }else{
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.openCheckbox()"]];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
