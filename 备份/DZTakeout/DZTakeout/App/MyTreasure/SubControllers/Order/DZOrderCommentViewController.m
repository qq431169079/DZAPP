//
//  DZOrderCommentViewController.m
//  DZTakeout
//
//  Created by 林鸿键 on 2018/9/27.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZOrderCommentViewController.h"

@interface DZOrderCommentViewController ()

@end

@implementation DZOrderCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价订单";
    NSMutableDictionary *orderDict = [NSMutableDictionary dictionary];
    [orderDict setValue:self.cid forKey:@"cid"];
    [orderDict setValue:self.orderId forKey:@"orderId"];
    [orderDict setValue:self.status forKey:@"status"];
    [orderDict setValue:[UserHelper userToken] forKey:@"token"];
    [self loadWebView:DZCommentOrderURL params:orderDict];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)launch:(NSString *)destn {
    if ([destn isEqualToString:@"finish"] ||[destn isEqualToString:@"nfinish"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"发表成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        [super launch:destn];
    }
    
}

@end
