//
//  MessageViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/26.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "MessageViewController.h"
#import "HPConversationViewController.h"
#import "UIView+HPUtil.h"
@interface MessageViewController ()<RCIMUserInfoDataSource>

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.conversationListTableView.tableFooterView = [UIView new];
    // Do any additional setup after loading the view.
    //设置需要显示哪些类型的会话,由于楼主只需要单聊功能,所以只设置ConversationType_PRIVATE
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
    
    //设置需要将哪些类型的会话在会话列表中聚合显示
//    [self setCollectionConversationType:@[@(ConversationType_PRIVATE)]];
    [RCIM sharedRCIM].userInfoDataSource = self;
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    HPConversationViewController *conversationVC = [[HPConversationViewController alloc] init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.conversationTitle;
    
    [self.view.getCurActiveViewController.navigationController pushViewController:conversationVC animated:YES];
}
//获取用户信息
-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    RCUserInfo *currentUserInfo = [[RCUserInfo alloc] initWithUserId:userId
                                                     name:[UserHelper userItem].name
                                                 portrait:@"http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTIia8vDXHVeygRibKaIqk1ibyCQ5DGQiaVgQ2EiaiaUBKs4VdXNjznAicEMXcBzG6GsBZNyLvd4ma1LESxOw/132"];
     [RCIM sharedRCIM].currentUserInfo = currentUserInfo;
    return completion(currentUserInfo);
}
//点击头像添加好友
- (void)didTapCellPortrait:(RCConversationModel *)model{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加为好友" message:model.conversationTitle preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:addAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Event Response
- (void)_handleReturnBackEvent {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
