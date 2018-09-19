//
//  DZShoppingCartView.h
//  DZTakeout
//
//  Created by HuangPan on 2018/6/21.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CompanyGoodModel;

@interface DZShoppingCartView : UIView

+ (instancetype)shoppingCart;

@property (nonatomic, copy) NSString *companyId;
/// 物流费
@property (nonatomic, assign) CGFloat logisticsPrice;
/// 准备结算
@property (nonatomic, copy) void(^onPrepareCommitHandler) (void);
@property (nonatomic, copy) void(^onChangedBadgeHanlder) (NSInteger count, CompanyGoodModel *model);
- (NSInteger)numberOfGooods:(CompanyGoodModel *)goods;
- (void)newlyAddedGoods:(CompanyGoodModel *)goods toCart:(NSInteger)number;
- (void)removeGoods:(CompanyGoodModel *)goods;
- (NSDictionary *)getAllGoodsByCompanyId:(NSString *)companyId;
- (void)show;
- (void)remove;
- (void)clear;
-(void)removeCurOrd:(NSString *)cid;
@end
