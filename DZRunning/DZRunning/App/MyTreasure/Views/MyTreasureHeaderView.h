//
//  MyTreasureHeaderView.h
//  DZTakeout
//
//  Created by HuangPan on 2018/6/25.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
UIKIT_EXTERN CGFloat MyTreasureHeaderViewHeight(void);

@class MyTreasureHeaderView;

@protocol MyTreasureHeaderViewDelegate<NSObject>
@optional

- (void)headerView:(MyTreasureHeaderView *)headerView touchUpInsideQRButton:(UIButton *)sender;

- (void)headerView:(MyTreasureHeaderView *)headerView touchUpInsideExitButton:(UIButton *)sender;

- (void)headerView:(MyTreasureHeaderView *)headerView touchUpInsideSettingButton:(UIButton *)sender;
@end

@interface MyTreasureHeaderView : UIView

@property (nonatomic, weak) id<MyTreasureHeaderViewDelegate> delegate;
-(void)resetHeaderViewWithUserModel:(UserModel*)userModel;
@end
