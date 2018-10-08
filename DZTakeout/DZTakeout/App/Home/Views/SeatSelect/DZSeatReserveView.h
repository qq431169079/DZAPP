//
//  DZSeatReserveView.h
//  DZTakeout
//
//  Created by 林鸿键 on 2018/8/29.
//  Copyright © 2018年 HuangPan. All rights reserved.
//


#import <UIKit/UIKit.h>
@class DZSeatReserveView;
@protocol DZSeatReserveViewDelegate<NSObject>
@optional
-(void)continueReserve:(DZSeatReserveView *)seatReserveView;

@end
@interface DZSeatReserveView : UIView
@property (nonatomic,weak) id<DZSeatReserveViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *closeCoverView;
@property (weak, nonatomic) IBOutlet UILabel *reserveInfoLab;
@property (weak, nonatomic) IBOutlet UILabel *notiLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFileHeightConstraint;
-(void)setupSeatReserveInfo:(NSDictionary *)dict;
@end
