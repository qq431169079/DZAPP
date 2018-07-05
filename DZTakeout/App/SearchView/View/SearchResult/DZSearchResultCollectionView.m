//
//  DZSearchResultCollectionView.m
//  DZTakeout
//
//  Created by 林鸿键 on 2018/7/4.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZSearchResultCollectionView.h"
#import "DZSearchResultCollectionViewCell.h"
@implementation DZSearchResultCollectionView

static NSString * const reuseIdentifierCell = @"DZSearchResultCollectionViewCell";

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([DZSearchResultCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifierCell];
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - UICollectionViewDelegate/UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.searchResultArray.count;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake(SCREEN_WIDTH, 55);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DZSearchResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierCell forIndexPath:indexPath];
    CompanyModel *model = self.searchResultArray[indexPath.row];
    [cell setupSearchResultCellWithCompanyModel:model];
    return cell;
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

#pragma mark - 懒加载
-(NSMutableArray *)searchResultArray{
    if (_searchResultArray == nil) {
        _searchResultArray = [NSMutableArray array];
    }
    return _searchResultArray;
}
@end
