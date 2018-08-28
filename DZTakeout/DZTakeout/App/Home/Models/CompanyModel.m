//
//  CompanyModel.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/22.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "CompanyModel.h"

@implementation DiscountModel

@end

@implementation CompanyModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"cid":@"id",
             @"distributionPrice":@"DistributionPrice"
             };
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"list":DiscountModel.class};
}
@end
