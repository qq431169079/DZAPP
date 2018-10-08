//
//  DZShoppingCartRelatedView.h
//  DZTakeout
//
//  Created by HuangPan on 2018/6/30.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  CompanyGoodModel;
@interface CartDetailCell : UITableViewCell

@property (nonatomic, strong) CompanyGoodModel *model;
@property (nonatomic, copy) void(^removeGoodsHandler) (CompanyGoodModel *model);
@property (nonatomic, copy) void(^onAddedGoodsToCartHandler) (CompanyGoodModel *model, NSUInteger count);

@end



@interface CartDetailHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) void(^onClearHandler) (void);

@end
