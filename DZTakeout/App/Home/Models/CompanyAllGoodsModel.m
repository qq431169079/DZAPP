//
//  CompanyAllFoodsModel.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/22.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "CompanyAllGoodsModel.h"

@implementation CompanyGoodModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"gid":@"id"};
}

@end

@implementation CompanyAllGoodsModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"list":CompanyGoodModel.class};
}

@end
