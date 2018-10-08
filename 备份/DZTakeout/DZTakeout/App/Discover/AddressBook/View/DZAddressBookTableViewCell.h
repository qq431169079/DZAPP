//
//  DZAddressBookTableViewCell.h
//  DZTakeout
//
//  Created by 林鸿键 on 2018/7/6.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DZFriendModel;
@interface DZAddressBookTableViewCell : UITableViewCell
-(void)resetUIWithFriendModel:(DZFriendModel *)friendModel;
@end
