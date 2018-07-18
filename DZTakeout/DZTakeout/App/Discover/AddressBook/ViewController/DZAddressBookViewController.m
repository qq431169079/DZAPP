//
//  DZAddressBookViewController.m
//  DZTakeout
//
//  Created by 林鸿键 on 2018/7/6.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZAddressBookViewController.h"

#import "HPConversationViewController.h"

#import "DZAddressBookTableViewCell.h"
#import "DZFriendModel.h"
#import "UIView+HPUtil.h"
@interface DZAddressBookViewController ()<UITableViewDelegate,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *addressBookTableView;
@property (nonatomic,strong) NSMutableArray *friendsArray;

@end

@implementation DZAddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAddressBookTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化
-(void)setupAddressBookTableView{
    [self.addressBookTableView registerNib:[UINib nibWithNibName:NSStringFromClass([DZAddressBookTableViewCell class]) bundle:nil] forCellReuseIdentifier:self.addressBookTableView.restorationIdentifier];
    self.addressBookTableView.tableFooterView = [UIView new];
}

#pragma mark -UITableViewDelegate,UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.friendsArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZAddressBookTableViewCell *addressBookCell = [tableView dequeueReusableCellWithIdentifier:tableView.restorationIdentifier forIndexPath:indexPath];
    DZFriendModel *friendModel = self.friendsArray[indexPath.row];
//    [cell setupCellWithMusicName:filePath serialNumber:indexPath.row];
    [addressBookCell resetUIWithFriendModel:friendModel];
    return addressBookCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DZFriendModel *friendModel = self.friendsArray[indexPath.row];
    HPConversationViewController *conversationVC = [[HPConversationViewController alloc] init];
    conversationVC.conversationType = ConversationType_PRIVATE;
    conversationVC.targetId = friendModel.targetId;
    conversationVC.title = friendModel.name;
    
    [self.view.getCurActiveViewController.navigationController pushViewController:conversationVC animated:YES];
}
#pragma mark - lazy
-(NSMutableArray *)friendsArray{
    if (_friendsArray == nil) {
        _friendsArray = [NSMutableArray array];
        //假数据
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"user002",@"targetId",
                              @"user002",@"name",
                              nil];
        DZFriendModel *friendModel = [DZFriendModel modelDictionary:dict];
        [_friendsArray addObject:friendModel];
        NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"user003",@"targetId",
                              @"user003",@"name",
                              nil];
        DZFriendModel *friendModel2 = [DZFriendModel modelDictionary:dict2];
        [_friendsArray addObject:friendModel2];
        NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"user004",@"targetId",
                              @"user004",@"name",
                              nil];
        DZFriendModel *friendModel3 = [DZFriendModel modelDictionary:dict3];
        [_friendsArray addObject:friendModel3];
    }
    return _friendsArray;
}
@end
