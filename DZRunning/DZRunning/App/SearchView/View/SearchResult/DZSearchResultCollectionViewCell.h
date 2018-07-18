//
//  DZSearchResultCollectionViewCell.h
//  DZTakeout
//
//  Created by 林鸿键 on 2018/7/4.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyModel.h"
@interface DZSearchResultCollectionViewCell : UICollectionViewCell
-(void)setupSearchResultCellWithCompanyModel:(CompanyModel *)companyModel;
@end
