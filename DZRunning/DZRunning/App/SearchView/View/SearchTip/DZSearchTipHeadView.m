//
//  DZSearchTipHeadView.m
//  DZTakeout
//
//  Created by 林鸿键 on 2018/7/4.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZSearchTipHeadView.h"
@interface DZSearchTipHeadView()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;

@end
@implementation DZSearchTipHeadView

-(void)resetUIWithHeadStyle:(HMDSearchTipHeadStyle)style{
    switch (style) {
        case DZSearchTipHistory:
            self.titleLab.text = @"搜索历史";
            self.clearBtn.hidden = NO;
            break;
        case DZSearchTipHot:
            self.titleLab.text = @"热门搜索";
            self.clearBtn.hidden = YES;
            break;
        default:
            break;
    }
}
- (IBAction)clearBtnClick:(id)sender {
    if (self.clearBtnBlcik) {
        self.clearBtnBlcik();
    }
}

@end
