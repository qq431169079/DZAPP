//
//  DZSearchTipCollectionView.h
//  DZTakeout
//
//  Created by 林鸿键 on 2018/7/4.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    DZSearchRecordAndHotTipsType = 0,        //记录与热词
    DZSearchOnlyHotTipsType = 1,             //只有热词
    DZSearchOnlyRecordTipsType = 2,          //只有记录
} DZSearchTipsType;

@interface DZSearchTipCollectionView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) NSMutableArray *recordSearchArray;
@property (nonatomic,strong) NSArray *hotSearchArray;

@property (nonatomic,assign) DZSearchTipsType searchTipsType;                   //推荐模式
@property (nonatomic,copy) void(^SearchTipBlock)(NSString *keyWord);            //关键词搜索
@property (nonatomic,copy) void(^clearHistorySearchTipBlock)(void);             //清空历史关键词
@property (nonatomic,copy) void(^scrollViewWillBeginDraggingBlock)(void);       //界面拖动
@end
