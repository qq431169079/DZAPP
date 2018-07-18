//
//  __FormatNode.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/23.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "__FormatGoodsNode.h"

@interface __FormatGoodsNode (){
    NSMutableArray<CompanyGoodModel *> *_caches;
}
@end

@implementation __FormatGoodsNode
- (instancetype)init {
    if (self = [super init]) {
        _caches = [NSMutableArray array];
    }
    return self;
}

- (NSInteger)count { return _caches.count;}

- (CGFloat)totalPrice {
    __block CGFloat price = 0;
    [_caches enumerateObjectsUsingBlock:^(CompanyGoodModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        price += obj.price;
    }];
    return price;
}

- (void)append:(CompanyGoodModel *)model {
    if (model) {
        [_caches addObject:model];
    }
}

- (CompanyGoodModel *)modelAtIndex:(NSInteger)index {
    if (index < 0 || index >= _caches.count) {
        return nil;
    }
    return _caches[index];
}

- (void)remove:(CompanyGoodModel *)model {
    [_caches removeObject:model];
}

- (void)removeLastObject {
    [_caches removeLastObject];
}

- (void)removeFirstObject {
    if ([self count] > 0) {
        [_caches removeObjectAtIndex:0];
    }
}

- (void)removeWithNumber:(NSUInteger)number {
    if ([self count] == 0) {return;};
    if (number >= _caches.count) {
        [_caches removeAllObjects];
    } else {
        [_caches removeObjectsInRange:NSMakeRange([self count] - number, number)];
    }
}

- (void)replaceModel:(CompanyGoodModel *)model atIndex:(NSUInteger)index {
    if (index < _caches.count) {
        [_caches replaceObjectAtIndex:index withObject:model];
    }
}

- (void)resetModel:(CompanyGoodModel *)model withNumber:(NSUInteger)number; {
    if (!model || number == 0) {
        [_caches removeAllObjects];
        return;
    }
    NSMutableArray<CompanyGoodModel *> *tmp = [NSMutableArray array];
    for (NSInteger i = 0; i < number; i++) {
        [tmp addObject:model];
    }
    [self resetModels:tmp.copy];
}

- (void)resetModels:(NSArray<CompanyGoodModel *> *)modes {
    [_caches removeAllObjects];
    if (modes.count == 0) {
        return;
    }
    [modes enumerateObjectsUsingBlock:^(CompanyGoodModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self append:obj];
    }];
}

@end
