//
//  DZSeatReserveView.m
//  DZTakeout
//
//  Created by 林鸿键 on 2018/8/29.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZSeatReserveView.h"
#import "NSString+HPUtil.h"
@implementation DZSeatReserveView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self addGestureRecognizer];
}

-(void)addGestureRecognizer{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeCurView)];
    [self.closeCoverView addGestureRecognizer:tapGestureRecognizer];
}

-(void)setupSeatReserveInfo:(NSDictionary *)dict{
    NSLog(@"%@",dict);
    if ([[dict allKeys]containsObject:@"totalCount"]) {
        NSInteger totalNum = [dict[@"totalCount"] integerValue];
        self.notiLab.text = [NSString stringWithFormat:@"提示:此桌已有%ld人预定,不建议前后两小时内预定",(long)totalNum];
    }
    if ([[dict allKeys]containsObject:@"list"]) {
        NSArray *list = dict[@"list"];
        CGFloat maxW = self.reserveInfoLab.frame.size.width;
        NSString *info;
        for (NSDictionary *infoDict in list) {
            NSString *reserveTime = infoDict[@"reserveTime"];
            if (info.length<1) {
                info = [NSString stringWithFormat:@" %@",reserveTime];
            }else{
                info = [NSString stringWithFormat:@"%@\n %@",info,reserveTime];
            }
        }
//        info = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@",info,info,info,info,info,info];
//        info = [NSString stringWithFormat:@"%@\n%@",info,info];
//        info = [NSString stringWithFormat:@"%@\n%@",info,info];
//        info = [NSString stringWithFormat:@"%@\n%@",info,info];
//        info = [NSString stringWithFormat:@"%@\n%@",info,info];
//        info = [NSString stringWithFormat:@"%@\n%@",info,info];
        self.reserveInfoLab.text = info;
        CGSize infoSize = [info sizeWithMaxWidth:maxW font:[UIFont systemFontOfSize:16]];
        self.textFileHeightConstraint.constant = infoSize.height+10;
    }
}



-(void)closeCurView{
    [self closeBtnClose:nil];
    
}
- (IBAction)closeBtnClose:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)continueBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(continueReserve:)]) {
        [self.delegate continueReserve:self];
    }
}

@end
