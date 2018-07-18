//
//  SellerBusinessRelatedViews.h
//  DZTakeout
//
//  Created by HuangPan on 2018/6/20.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+HPUtil.h"

@interface PartInfo_NavBar : UIView

@property (nonatomic, copy) void(^onCheckMoreHandler) (void);
@property (nonatomic, copy) void(^onPopBackHandler) (void);
@property (nonatomic, copy) void(^onSearchHandler) (void);

- (void)setAnimationProgress:(CGFloat)progress;
@end



@class CompanyModel;
@interface PartInfo_Summary : UIView

@property (nonatomic, strong) CompanyModel *model;

- (void)setAnimationProgress:(CGFloat)progress;

@end



@class DiscountModel;
@interface PartInfo_Details : UIView

@property (nonatomic, copy) NSArray<DiscountModel *> *items;

@end
