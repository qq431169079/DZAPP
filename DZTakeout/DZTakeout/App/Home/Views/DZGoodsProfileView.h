//
//  DZGoodsProfileView.h
//  DZTakeout
//
//  Created by HuangPan on 2018/6/23.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CompanyGoodModel;

@interface DZGoodsProfileView : UIView

@property (nonatomic, strong) CompanyGoodModel *model;
@property (nonatomic, copy) void(^removeGoodsHandler) (CompanyGoodModel *model);
@property (nonatomic, copy) void(^onAddedGoodsToCartHandler) (CGPoint startPoint, CompanyGoodModel *model, NSUInteger count);

- (void)show;
- (void)remove;

@end
