//
//  __FormatNode.h
//  DZTakeout
//
//  Created by HuangPan on 2018/6/23.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CompanyAllGoodsModel.h"

@interface __FormatGoodsNode : NSObject

@property (nonatomic, copy) NSString *key;
- (CGFloat)totalPrice;
- (NSInteger)count;
- (void)append:(CompanyGoodModel *)model;
- (void)remove:(CompanyGoodModel *)model;
- (void)removeLastObject;
- (void)removeFirstObject;
- (CompanyGoodModel *)modelAtIndex:(NSInteger)index;

- (void)replaceModel:(CompanyGoodModel *)model atIndex:(NSUInteger)index;
- (void)removeWithNumber:(NSUInteger)number;
- (void)resetModel:(CompanyGoodModel *)model withNumber:(NSUInteger)number;
- (void)resetModels:(NSArray<CompanyGoodModel *> *)modes;
@end
