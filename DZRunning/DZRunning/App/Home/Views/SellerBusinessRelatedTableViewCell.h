//
//  SellerBusinessRelatedTableViewCell.h
//  DZTakeout
//
//  Created by HuangPan on 2018/6/21.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CompanyGoodModel;

@interface PartInfo_FoodsSummaryCell : UITableViewCell

@property (nonatomic, strong) CompanyGoodModel *model;
@property (nonatomic, copy) void(^removeGoodsHandler) (CompanyGoodModel *model);
@property (nonatomic, copy) void(^onAddedGoodsToCartHandler) (CGPoint startPoint, CompanyGoodModel *model, NSUInteger count);

@end




@interface PartInfo_FoodsHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString *name;

@end
