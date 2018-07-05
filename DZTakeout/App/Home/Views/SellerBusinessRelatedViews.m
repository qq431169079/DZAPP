//
//  SellerBusinessRelatedViews.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/20.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "SellerBusinessRelatedViews.h"

@interface PartInfo_NavBar ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *popBtn;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UIButton *checkMoreBtn;

@end

@implementation PartInfo_NavBar : UIView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.popBtn];
    [self.contentView addSubview:self.searchBtn];
    [self.contentView addSubview:self.checkMoreBtn];
    
    @weakify(self);
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self).offset(ASPECT_STATUS_BAR_H);
    }];
    [self.popBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.contentView).offset(5);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.checkMoreBtn.mas_left).offset(-5);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.checkMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
}

- (void)touchUpInsidePopBtn:(UIButton *)sender {
    if (self.onPopBackHandler) {
        self.onPopBackHandler();
    }
}

- (void)touchUpInsideSearchBtn:(UIButton *)sender {
    if (self.onSearchHandler) {
        self.onSearchHandler();
    }
}

- (void)touchUpInsideCheckMoreBtn:(UIButton *)sender {
    if (self.onCheckMoreHandler) {
        self.onCheckMoreHandler();
    }
}

- (void)setAnimationProgress:(CGFloat)progress {
    if (progress < 0) { progress = 0; }
    if (progress > 1) { progress = 1; }
    self.searchBtn.alpha = (1.0f - progress);
    self.checkMoreBtn.alpha = (1.0f - progress);
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}

- (UIButton *)popBtn {
    if (!_popBtn) {
        _popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _popBtn.imageOfNormal = [UIImage imageNamed:@"nav_nav_icon_back_normal"];
        [_popBtn addTarget:self action:@selector(touchUpInsidePopBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _popBtn;
}

- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBtn.imageOfNormal = [UIImage imageNamed:@"icon_company_search"];
        [_searchBtn addTarget:self action:@selector(touchUpInsideSearchBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

- (UIButton *)checkMoreBtn {
    if (!_checkMoreBtn) {
        _checkMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkMoreBtn.imageOfNormal = [UIImage imageNamed:@"icon_company_menu"];
        [_checkMoreBtn addTarget:self action:@selector(touchUpInsideCheckMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkMoreBtn;
}
@end



#import "CompanyModel.h"
#import <UIImageView+WebCache.h>
#import "NSString+HPUtil.h"

@interface PartInfo_Summary ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *serviceLabel;// 服务
@property (nonatomic, strong) UIButton *logisticsBtn;// 物流
@property (nonatomic, strong) UIButton *salesVolumeBtn;// 销量
@property (nonatomic, strong) UIImageView *logoImgView; // logo

@end

@implementation PartInfo_Summary : UIView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.serviceLabel];
    [self.contentView addSubview:self.logisticsBtn];
    [self.contentView addSubview:self.salesVolumeBtn];
    [self.contentView addSubview:self.logoImgView];
    
    @weakify(self);
    [self.serviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.salesVolumeBtn);
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.logoImgView).offset(-5);
        make.height.equalTo(self.logisticsBtn);
    }];
    [self.logisticsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.salesVolumeBtn.mas_right).offset(20);
        make.centerY.equalTo(self.salesVolumeBtn);
        make.height.equalTo(self.salesVolumeBtn);
        make.width.mas_equalTo(0);
    }];
    [self.salesVolumeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.logoImgView.mas_right).offset(20);
        make.bottom.equalTo(self.logoImgView);
        make.width.mas_equalTo(0); make.top.equalTo(self.logoImgView.mas_centerY).offset(20).priorityMedium();
    }];
    [self.logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.contentView).offset(15);
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(self.logoImgView.mas_height);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
}

- (void)setAnimationProgress:(CGFloat)progress {
    if (progress < 0) { progress = 0; }
    if (progress > 1) { progress = 1; }
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    self.contentView.frame = CGRectMake(0, 0, width * progress, height * progress);
    self.contentView.alpha = progress;
}

- (void)setModel:(CompanyModel *)model {
    _model = model;
    
    self.logisticsBtn.titleOfNormal = @"动致配送";
    self.salesVolumeBtn.titleOfNormal = [NSString stringWithFormat:@"月销:%zd", _model.monSales];
    self.serviceLabel.text = _model.notice;
    [self.logoImgView sd_setImageWithURL:[NSURL URLWithString:_model.logo]];
    
    CGFloat width = [self.logisticsBtn.titleOfNormal sizeWithMaxWidth:CGFLOAT_MAX font:self.logisticsBtn.titleLabel.font].width + 10;
    [self.logisticsBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
    width = [self.salesVolumeBtn.titleOfNormal sizeWithMaxWidth:CGFLOAT_MAX font:self.logisticsBtn.titleLabel.font].width + 10;
    [self.salesVolumeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}

- (UILabel *)serviceLabel {
    if (!_serviceLabel) {
        _serviceLabel = [UILabel new];
        _serviceLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f];
        _serviceLabel.font = [UIFont systemFontOfSize:14];
        _serviceLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _serviceLabel;
}

- (UIButton *)salesVolumeBtn {
    if (!_salesVolumeBtn) {
        _salesVolumeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _salesVolumeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _salesVolumeBtn.backgroundColor = [UIColor yellowColor];
        _salesVolumeBtn.titleColorOfNormal = [UIColor blackColor];
    }
    return _salesVolumeBtn;
}

- (UIButton *)logisticsBtn {
    if (!_logisticsBtn) {
        _logisticsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _logisticsBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _logisticsBtn.backgroundColor = NAV_FGC;
        _logisticsBtn.titleColorOfNormal = [UIColor whiteColor];
    }
    return _logisticsBtn;
}

- (UIImageView *)logoImgView {
    if (!_logoImgView) {
        _logoImgView = [UIImageView new];
        _logoImgView.backgroundColor = [UIColor whiteColor];
        _logoImgView.contentMode = UIViewContentModeScaleAspectFill;
        _logoImgView.clipsToBounds = YES;
    }
    return _logoImgView;
}
@end


#import "CompanyModel.h"
@interface PartInfo_Details ()

@property (nonatomic ,strong) UILabel *despLabel;
@property (nonatomic, strong) UILabel *totalDiscountLabel;
@end

@implementation PartInfo_Details : UIView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self addSubview:self.despLabel];
    [self addSubview:self.totalDiscountLabel];
    
    @weakify(self);
    [self.despLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self).offset(15);
        make.left.equalTo(self).offset(15);
    }];
    [self.totalDiscountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.despLabel.mas_right).offset(5);
        make.top.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
    }];
    [self.totalDiscountLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.totalDiscountLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat minX = CGRectGetMinX(self.totalDiscountLabel.frame);
    self.despLabel.preferredMaxLayoutWidth = (minX - 5);
}

- (void)setItems:(NSArray<DiscountModel *> *)items {
    _items = items.copy;
    
    NSMutableString *string = [NSMutableString string];
    __block NSInteger count = 0;
    [_items enumerateObjectsUsingBlock:^(DiscountModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isOpen1) {
            [string appendString:obj.activityName1];
            [string appendString:@"\n"];
            [string appendString:obj.subtraction];
            [string appendString:@"\n"];
            count ++;
        }
    }];
    self.despLabel.text = string.copy;
    self.totalDiscountLabel.text = [NSString stringWithFormat:@"%zd个活动", count];
}

- (UILabel *)despLabel {
    if (!_despLabel) {
        _despLabel = [UILabel new];
        _despLabel.textColor = [UIColor grayColor];
        _despLabel.numberOfLines = 0;
        _despLabel.font = [UIFont systemFontOfSize:14];
    }
    return _despLabel;
}

- (UILabel *)totalDiscountLabel {
    if (!_totalDiscountLabel) {
        _totalDiscountLabel = [UILabel new];
        _totalDiscountLabel.textColor = [UIColor grayColor];
        _totalDiscountLabel.numberOfLines = 0;
        _totalDiscountLabel.font = [UIFont systemFontOfSize:14];
        _totalDiscountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _totalDiscountLabel;
}
@end
