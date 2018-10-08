//
//  DZActivityTableViewCell.m
//  DZTakeout
//
//  Created by 林鸿键 on 2018/8/29.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZActivityTableViewCell.h"
@interface DZActivityTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *activityIcon;

@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UILabel *activityName;
@property (weak, nonatomic) IBOutlet UIImageView *openImageView;

@end

@implementation DZActivityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCellWithModel:(DiscountModel *)model needSelectedIcon:(BOOL)needIcon selected:(BOOL)selected{
    NSString *action = [NSString stringWithFormat:@"%@ %@",model.activityName1,model.subtraction];
    self.activityName.text = action;
    
//    tabbar_discover_normal
    //tabbar_discover_highlight
    if (needIcon) {
        self.subTitle.hidden = NO;
        self.subTitle.text = [NSString stringWithFormat:@"%ld个活动",(long)self.totalNum];
        self.openImageView.hidden = NO;
        NSString *imageName = @"c_company_info_down";
        if (selected) {
            imageName = @"c_company_info_up";
        }
        self.openImageView.image = [UIImage imageNamed:imageName];
    }else{
        self.subTitle.hidden = YES;
        self.openImageView.hidden = YES;
    }
    if (self.totalNum == 1) {
        self.openImageView.hidden = YES;
    }
}
@end
