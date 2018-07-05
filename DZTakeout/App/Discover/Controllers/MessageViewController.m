//
//  MessageViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/26.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置需要显示哪些类型的会话,由于楼主只需要单聊功能,所以只设置ConversationType_PRIVATE
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
    
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_PRIVATE)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
