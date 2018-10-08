//
//  DZLoadingHoldView.h
//  DZTakeout
//
//  Created by 林鸿键 on 2018/7/11.
//  Copyright © 2018年 HuangPan. All rights reserved.
//  加载占位图

#import <UIKit/UIKit.h>
typedef enum{
    DZRequestSuccess,                   //加载成功
    DZRequestFailure,                   //加载失败
    DZRequestEmpty,                     //空数据
    DZRequestLoading,                   //加载中
    DZRequestEmptyMessage               //空消息
}DZRequestResult;
@interface DZLoadingHoldView : UIView
@property (nonatomic,copy) void(^reResultBlock)(void);

-(void)setImageWithRequestResult:(DZRequestResult)requestResult;
@end
