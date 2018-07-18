//
//  CheckoutViewController.h
//  DZTakeout
//
//  Created by HuangPan on 2018/6/25.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZBaseWKViewController.h"

/**
 外卖配送
 */
@interface CheckoutViewController : DZBaseWKViewController

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderNo;

- (void)loadingIfNeeded;
@end
