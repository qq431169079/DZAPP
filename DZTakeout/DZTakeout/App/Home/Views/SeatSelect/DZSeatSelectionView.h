//
//  DZSeatSelectionView.h
//  DZTakeout
//
//  Created by 林鸿键 on 2018/7/7.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZSeatSelectionView : UIView

@property (nonatomic,copy) void(^orderDishesBlock)(NSString *endTime,NSString *mealNum,NSString *phoneNum);//点餐
@property (nonatomic,copy) void(^paySecurityBlock)(NSString *endTime,NSString *mealNum,NSString *phoneNum);//支付押金
-(void)reloadUIWithSeatInfo:(NSDictionary *)infoDict;
@end
