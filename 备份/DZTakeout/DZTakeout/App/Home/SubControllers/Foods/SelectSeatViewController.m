//
//  SelectSeatViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/27.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "SelectSeatViewController.h"
#import "DiningHallViewController.h"
#import "DiningBoxViewController.h"

@interface SelectSeatViewController ()

@end

@implementation SelectSeatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Override Functions
- (NSArray<NSString *> *)navSegmentTitles {
    return @[@"大厅", @"包厢"];
}

- (NSArray<UIViewController *> *)switchChildControllers {
    DiningHallViewController *hallVc = [DiningHallViewController controller];
    DiningBoxViewController *boxVc = [DiningBoxViewController controller];
    hallVc.companyId = self.companyId;
    boxVc.companyId = self.companyId;
    return @[hallVc, boxVc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
