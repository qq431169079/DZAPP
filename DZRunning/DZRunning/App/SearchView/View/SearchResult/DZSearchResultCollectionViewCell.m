//
//  DZSearchResultCollectionViewCell.m
//  DZTakeout
//
//  Created by 林鸿键 on 2018/7/4.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZSearchResultCollectionViewCell.h"
@interface DZSearchResultCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *companyIcon;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *companyInfo;

@end
@implementation DZSearchResultCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setupSearchResultCellWithCompanyModel:(CompanyModel *)companyModel{
    
//    [self.companyIcon setImageWithURL:companyModel.logo placeholderImage:nil];
    [self.companyIcon DZ_setImageWithURL:@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2442455668,3341111883&fm=27&gp=0.jpg" placeholderImage:nil];
    self.companyName.text = companyModel.name;
    self.companyInfo.text = companyModel.business_time;
}
@end
