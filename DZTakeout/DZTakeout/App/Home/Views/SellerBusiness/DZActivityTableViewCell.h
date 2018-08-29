//
//  DZActivityTableViewCell.h
//  DZTakeout
//
//  Created by 林鸿键 on 2018/8/29.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyModel.h"
@interface DZActivityTableViewCell : UITableViewCell
@property (nonatomic,assign) NSInteger totalNum;
-(void)setCellWithModel:(DiscountModel *)model needSelectedIcon:(BOOL)needIcon selected:(BOOL)selected;
@end
