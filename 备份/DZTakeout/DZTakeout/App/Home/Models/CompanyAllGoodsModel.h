//
//  CompanyAllFoodsModel.h
//  DZTakeout
//
//  Created by HuangPan on 2018/6/22.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "HPModel.h"


@interface CompanyGoodModel : HPModel
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) CGFloat svg_price;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, assign) NSInteger click;
@property (nonatomic, assign) NSInteger mon_sales;
@property (nonatomic, assign) NSInteger total_sales;

@property (nonatomic, assign) BOOL fine;
@property (nonatomic, assign) BOOL is_new;
@property (nonatomic, assign) BOOL is_svg;
@property (nonatomic, assign) BOOL Selling;
@property (nonatomic, assign) BOOL shelves;
@property (nonatomic, assign) BOOL recommend;

@property (nonatomic, copy) NSString *gid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *brief;
@property (nonatomic, copy) NSString *details;
@property (nonatomic, copy) NSString *ksy_word;
@property (nonatomic, copy) NSString *zoom_url;
@property (nonatomic, copy) NSString *ificationId;
@property (nonatomic, copy) NSString *original_url;
@property (nonatomic, copy) NSString *ificationName;

@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *create_time;

/*** 前端需要 **/
@property (nonatomic, assign) NSInteger hasSelectedCount;
@property (nonatomic, strong) NSIndexPath *indexPath; // 分组

@end

@interface CompanyAllGoodsModel : HPModel

@property (nonatomic, copy) NSArray<CompanyGoodModel *> *list;
@property (nonatomic, assign) BOOL success;
@property (nonatomic, assign) NSInteger totalCount;

@end
