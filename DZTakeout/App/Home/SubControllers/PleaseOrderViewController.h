//
//  PleaseOrderViewController.h
//  DZTakeout
//
//  Created by HuangPan on 2018/6/19.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "HPBaseViewController.h"

/**
 外卖美食点餐
 */
@interface PleaseOrderViewController : HPBaseViewController

/// 物流费
@property (nonatomic, assign) CGFloat logisticsPrice;
@property (nonatomic, copy) NSString *companyId;

@end
