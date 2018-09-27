//
//  DZCameraViewController.m
//  DZTakeout
//
//  Created by 林鸿键 on 2018/9/20.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZCameraViewController.h"

//#import "P2P_API.h"
@interface DZCameraViewController ()

@end

@implementation DZCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"直播";
    [self setupCamera];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupCamera{

    [self EditP2PCameraInfo:YES Name:@"后厨" DID:@"VSTF166008EFRHA" User:@"admin" Pwd:@"18126180537" OldDID:nil];
}
- (BOOL) EditP2PCameraInfo:(BOOL)bAdd Name:(NSString *)name DID:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd OldDID:(NSString *)olddid{
    NSLog(@"P2P代理函数");
    NSLog(@"EditP2PCameraInfo  bAdd: %d, name: %@, did: %@, user: %@, pwd: %@, olddid: %@", bAdd, name, did, user, pwd, olddid);
    
    BOOL bRet = YES;
    
    NSLog(@"bRet: %d", bRet);
    
    return bRet;
}
@end
