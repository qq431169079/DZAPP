//
//  DZLoadingView.h
//  DZTakeout
//
//  Created by 林鸿键 on 2018/7/5.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSInteger{
    //大图标模式
    DZLoadingViewFullType,
    //小图标
    DZLoadingViewMiniType
}DZLoadingViewType;

@interface DZLoadingView : UIView
@property (nonatomic,strong) UIImageView *loadingImageView;
@property (nonatomic,assign) BOOL isloading;
+(instancetype)DZLoadingViewWithType:(DZLoadingViewType)loadingViewType;
//开始动画
-(void)startLoadingAnimation;
//结束动画
-(void)endLoadingAnimaton;
@end
