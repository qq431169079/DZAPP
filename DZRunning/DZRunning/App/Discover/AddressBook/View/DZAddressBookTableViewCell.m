//
//  DZAddressBookTableViewCell.m
//  DZTakeout
//
//  Created by 林鸿键 on 2018/7/6.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZAddressBookTableViewCell.h"
#import "DZFriendModel.h"
@interface DZAddressBookTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;

@end
@implementation DZAddressBookTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)resetUIWithFriendModel:(DZFriendModel *)friendModel{
    self.userNameLab.text = friendModel.name;
}
@end
