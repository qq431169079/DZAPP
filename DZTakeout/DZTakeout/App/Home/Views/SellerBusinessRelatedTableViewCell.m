
//
//  SellerBusinessRelatedTableViewCell.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/21.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "SellerBusinessRelatedTableViewCell.h"
#import "UIButton+HPUtil.h"
#import "HPIncreaseButton.h"
#import <UIImageView+WebCache.h>
#import "CompanyAllGoodsModel.h"

@interface PartInfo_FoodsSummaryCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIImageView *logoImgView;
@property (nonatomic, strong) HPIncreaseButton *addOrRemoveBtn;

@property (nonatomic, strong) UIView *separatorLine;

@end

@implementation PartInfo_FoodsSummaryCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.logoImgView];
    [self.contentView addSubview:self.addOrRemoveBtn];
    [self.contentView addSubview:self.separatorLine];
    @weakify(self);
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.logoImgView);
        make.left.equalTo(self.logoImgView.mas_right).offset(15);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.logoImgView);
        make.left.equalTo(self.nameLabel);
    }];
    [self.logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.width.equalTo(self.logoImgView.mas_height);
    }];
    [self.addOrRemoveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.logoImgView);
        make.right.equalTo(self.contentView).offset(-15);
        make.size.mas_equalTo(CGSizeMake(80, 25));
    }];
    
    [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
}

- (void)removeOrAdd:(BOOL)add number:(CGFloat)number {
    if (add && self.onAddedGoodsToCartHandler) {
        CGRect rect = [self.addOrRemoveBtn convertRect:self.addOrRemoveBtn.increaseBtn.frame toView:self.contentView];
        CGRect startRect = [self.contentView convertRect:rect toView:[UIApplication sharedApplication].keyWindow];
        CGPoint startPoint = CGPointMake(startRect.origin.x + CGRectGetWidth(startRect) * 0.5f, startRect.origin.y + CGRectGetHeight(startRect) * 0.5f);
        _model.hasSelectedCount = number;
        self.onAddedGoodsToCartHandler(startPoint, self.model ,floor(number));
    }
    if (!add && self.removeGoodsHandler) {
        _model.hasSelectedCount = number;
        self.removeGoodsHandler(self.model);
    }
}

- (void)setModel:(CompanyGoodModel *)model {
    _model = model;
    self.nameLabel.text = _model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", _model.price];
    [self.logoImgView sd_setImageWithURL:[NSURL URLWithString:_model.zoom_url]];
    if (_model.hasSelectedCount > 0) {
        self.addOrRemoveBtn.currentNumber = _model.hasSelectedCount;
        [self.addOrRemoveBtn setRetract:NO];
    } else {
        self.addOrRemoveBtn.currentNumber = 0;
        [self.addOrRemoveBtn setRetract:YES];
    }
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    }
    return _nameLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.textColor = NAV_FGC;
        _priceLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _priceLabel;
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

- (HPIncreaseButton *)addOrRemoveBtn {
    if (!_addOrRemoveBtn) {
        _addOrRemoveBtn = [HPIncreaseButton increaseButtonWithFrame:CGRectMake(0, 0, 100, 25)];
        _addOrRemoveBtn.decreaseHide = YES;
        _addOrRemoveBtn.editing = NO;
        _addOrRemoveBtn.shakeAnimation = YES;
        _addOrRemoveBtn.increaseImage = [UIImage imageNamed:@"icon_add_to_cart"];
        _addOrRemoveBtn.decreaseImage = [UIImage imageNamed:@"icon_delete_to_cart"];
        
        @weakify(self);
        _addOrRemoveBtn.numberChangedHandler = ^(CGFloat number, BOOL increaseStatus) {
            @strongify(self);
            [self removeOrAdd:increaseStatus number:number];
        };
    }
    return _addOrRemoveBtn;
}

- (UIView *)separatorLine {
    if (!_separatorLine) {
        _separatorLine = [UIView new];
        _separatorLine.backgroundColor = [UIColor whiteColor];
    }
    return _separatorLine;
}

@end




@interface PartInfo_FoodsHeaderView ()
@property (nonatomic, strong) UILabel *nameLabel;
@end
@implementation PartInfo_FoodsHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.nameLabel];
    
    @weakify(self);
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.bottom.equalTo(self.contentView);
    }];
}

- (void)setName:(NSString *)name {
    _name = name.copy;
    self.nameLabel.text = _name;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor grayColor];
        _nameLabel.font = [UIFont systemFontOfSize:14.0f];
        _nameLabel.backgroundColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _nameLabel;
}
@end
