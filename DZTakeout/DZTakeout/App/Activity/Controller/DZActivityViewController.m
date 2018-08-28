//
//  DZActivityViewController.m
//  DZTakeout
//
//  Created by 林鸿键 on 2018/8/26.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZActivityViewController.h"
#import "DZBMKLocationTool.h"
@interface DZActivityViewController ()

@end

@implementation DZActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableDictionary *activityDict = [NSMutableDictionary dictionary];
    [activityDict setValue:self.activityId forKey:@"activityId"];
    [activityDict setValue:[DZBMKLocationTool sharedInstance].coordinateStr forKey:@"lng"];
    
    [self loadWebView:DZActivityURL params:activityDict];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
