//
//  DZSearchTipCollectionView.m
//  DZTakeout
//
//  Created by 林鸿键 on 2018/7/4.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZSearchTipCollectionView.h"
#import "DZSearchTipCollectionViewCell.h"
#import "DZSearchTipHeadView.h"
#import "NSString+HPUtil.h"
@implementation DZSearchTipCollectionView
static NSString * const reuseIdentifierCell = @"DZSearchTipCollectionViewCell";

static NSString * const reuseIdentifierHead = @"DZSearchTipHeadView";
-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([DZSearchTipCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifierCell];
        //注册头尾视图
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([DZSearchTipHeadView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierHead];
        self.delegate = self;
        self.dataSource = self;
        
    }
    return self;
}
#pragma mark - UICollectionViewDelegate/UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    if (self.searchTipsType == DZSearchRecordAndHotTipsType) {
        if (section==0) {
            return self.recordSearchArray.count;
        }else{
            return self.hotSearchArray.count;
        }
    }else{
        if (self.searchTipsType == DZSearchOnlyRecordTipsType) {
            return self.recordSearchArray.count;
        }else{
            return self.hotSearchArray.count;
        }
    }
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

        if (self.recordSearchArray.count>0 && self.hotSearchArray.count>0) {
            self.searchTipsType = DZSearchRecordAndHotTipsType;
            return 2;
        }else{
            if (self.recordSearchArray.count > 0) {
                self.searchTipsType = DZSearchOnlyRecordTipsType;
            }else{
                self.searchTipsType = DZSearchOnlyHotTipsType;
            }
            return 1;
        }

}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *tip = [self getTipWithIndexPath:indexPath];
    CGFloat width = [tip sizeWithMaxWidth:CGFLOAT_MAX font:[UIFont systemFontOfSize:14]].width + 25;
    return CGSizeMake(width, 32);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGRect bounds = collectionView.bounds;

    return CGSizeMake(CGRectGetWidth(bounds), 50);
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{

    return 5;

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DZSearchTipCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierCell forIndexPath:indexPath];
    NSString *tip = [self getTipWithIndexPath:indexPath];
    cell.tipLab.text = tip;
    return cell;
}

-(NSString *)getTipWithIndexPath:(NSIndexPath *)indexPath{
    NSString *tip;
    if (self.searchTipsType == DZSearchRecordAndHotTipsType) {
        if (indexPath.section==0) {
            tip = self.recordSearchArray[indexPath.row];
        }else{
            NSDictionary *tipDict = self.hotSearchArray[indexPath.row];
            if ([[tipDict allKeys]containsObject:@"keyword"]) {
                tip = tipDict[@"keyword"];
            }
        }
    }else{
        if (self.searchTipsType == DZSearchOnlyRecordTipsType) {
            tip = self.recordSearchArray[indexPath.row];
        }else{
            NSDictionary *tipDict = self.hotSearchArray[indexPath.row];
            if ([[tipDict allKeys]containsObject:@"keyword"]) {
                tip = tipDict[@"keyword"];
            }
        }
    }
    return tip;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *tip = [self getTipWithIndexPath:indexPath];
    if (self.SearchTipBlock) {
        self.SearchTipBlock(tip);
    }
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        DZSearchTipHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierHead forIndexPath:indexPath];
 
            if (self.searchTipsType == DZSearchRecordAndHotTipsType) {
                if (indexPath.section == 0){
                    DZWeakSelf(self)
                    headerView.clearBtnBlcik = ^{
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kDZSearchWordHistory];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        weakSelf.recordSearchArray = nil;
                        [weakSelf reloadData];
                        if (weakSelf.clearHistorySearchTipBlock) {
                            weakSelf.clearHistorySearchTipBlock();
                        }
                    };
                    [headerView resetUIWithHeadStyle:DZSearchTipHistory];
                }else{
                    [headerView resetUIWithHeadStyle:DZSearchTipHot];
                }
            }else{
                if (self.searchTipsType == DZSearchOnlyRecordTipsType) {
                    [headerView resetUIWithHeadStyle:DZSearchTipHistory];
                }else{
                    [headerView resetUIWithHeadStyle:DZSearchTipHot];
                }
            }
        
        return headerView;
    }else{
        return  nil;
    }
}

#pragma mark - 懒加载
-(NSMutableArray *)recordSearchArray{
    if (_recordSearchArray == nil) {
        _recordSearchArray = [NSMutableArray array];
        NSArray *recordArray = [[NSUserDefaults standardUserDefaults] objectForKey:kDZSearchWordHistory];
        if (recordArray) {
            [_recordSearchArray addObjectsFromArray:recordArray];
        }
    }
    return _recordSearchArray;
}

-(NSArray *)hotSearchArray{
    if (_hotSearchArray == nil) {
        _hotSearchArray = [NSArray array];
    }
    return _hotSearchArray;
}
@end
