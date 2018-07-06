//
//  DiscoverViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/3/26.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DiscoverViewController.h"
#import "MessageViewController.h"
#import "ContactsViewController.h"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navBar hiddenBackBtn:YES];
}

#pragma mark - Override Functions
- (NSArray<NSString *> *)navSegmentTitles {
    return @[@"消息", @"通讯录"];
}

- (NSArray<UIViewController *> *)switchChildControllers {
    MessageViewController *messageVc = [[MessageViewController alloc] init];
    ContactsViewController *contactsVc = [[ContactsViewController alloc] init];
    return @[messageVc, contactsVc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
