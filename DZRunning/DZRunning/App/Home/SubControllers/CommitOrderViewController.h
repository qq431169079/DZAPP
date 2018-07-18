//
//  CommitOrderViewController.h
//  DZTakeout
//
//  Created by HuangPan on 2018/6/19.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZSegmentNavBarController.h"

/**
 提交订单
 */
@interface CommitOrderViewController : DZSegmentNavBarController

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderNo;

@end
