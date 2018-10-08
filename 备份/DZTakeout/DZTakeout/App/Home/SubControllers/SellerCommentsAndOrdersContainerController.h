//
//  SellerCommentsAndOrdersContainerController.h
//  DZTakeout
//
//  Created by HuangPan on 2018/6/20.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "HPBaseViewController.h"

@interface SellerCommentsAndOrdersContainerController : HPBaseViewController
/// 物流费
@property (nonatomic, assign) CGFloat logisticsPrice;
@property (nonatomic, copy) NSString *minPrice;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, assign) BOOL isBusiness;
@end
