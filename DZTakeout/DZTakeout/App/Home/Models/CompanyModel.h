//
//  CompanyModel.h
//  DZTakeout
//
//  Created by HuangPan on 2018/6/22.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "HPModel.h"

@interface DiscountModel : HPModel

@property (nonatomic, copy) NSString *activityName1;
@property (nonatomic, copy) NSString *subtraction;
@property (nonatomic, assign) BOOL isOpen1;

@end

@interface CompanyModel : HPModel

@property (nonatomic, copy) NSString *business_time;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *range;
@property (nonatomic, copy) NSString *GDP;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *place;
@property (nonatomic, copy) NSString *notice;
@property (nonatomic, copy) NSArray<DiscountModel *> *list;

@property (nonatomic, assign) BOOL success;
@property (nonatomic, assign) CGFloat assess;
@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger monSales;
@property (nonatomic, assign) NSInteger totalCount;
@end
