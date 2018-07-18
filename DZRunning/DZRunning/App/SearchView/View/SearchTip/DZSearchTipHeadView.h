//
//  DZSearchTipHeadView.h
//  DZTakeout
//
//  Created by 林鸿键 on 2018/7/4.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    DZSearchTipHistory = 0, //搜索记录
    DZSearchTipHot = 1,    //热门
} HMDSearchTipHeadStyle; //样式
@interface DZSearchTipHeadView : UICollectionReusableView

@property (nonatomic,copy) void(^clearBtnBlcik)(void);

-(void)resetUIWithHeadStyle:(HMDSearchTipHeadStyle)style;
@end
