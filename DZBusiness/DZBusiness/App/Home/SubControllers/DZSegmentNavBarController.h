//
//  DZSegmentNavBarController.h
//  DZTakeout
//
//  Created by HuangPan on 2018/6/15.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZWKWebViewController.h"
#import "DZSegmentNavBar.h"
@interface DZSegmentNavBarController : HPViewController

@property (nonatomic, strong) DZSegmentNavBar *navBar;
#pragma mark - Override
- (NSArray<NSString *> *)navSegmentTitles;
- (NSArray<UIViewController *> *)switchChildControllers;
- (void)segmentSwitchToIndex:(NSInteger)index;
@end
