//
//  DZShoppingCartRelatedView.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/30.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZShoppingCartRelatedView.h"
#import "HPIncreaseButton.h"
#import "CompanyAllGoodsModel.h"

@interface CartDetailCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) HPIncreaseButton *addOrRemoveBtn;

@end

@implementation CartDetailCell
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
    [self.contentView addSubview:self.addOrRemoveBtn];
    @weakify(self);
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.addOrRemoveBtn.mas_left).offset(-15);
    }];
    [self.addOrRemoveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
        make.size.mas_equalTo(CGSizeMake(80, 25));
    }];
}

- (void)removeOrAdd:(BOOL)add number:(CGFloat)number {
    if (add && self.onAddedGoodsToCartHandler) {
        _model.hasSelectedCount = number;
        self.onAddedGoodsToCartHandler(self.model ,floor(number));
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
@end




#import "UIButton+HPUtil.h"
@interface CartDetailHeaderView ()

@property (nonatomic, strong) UIView *separateLine;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *cleanBtn;

@end

@implementation CartDetailHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.backgroundColor = COLOR_HEX(0xf5f5f5);
    self.contentView.backgroundColor = COLOR_HEX(0xf5f5f5);
    [self.contentView addSubview:self.separateLine];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.cleanBtn];
    
    @weakify(self);
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.left.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(4);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.separateLine.mas_right).offset(5);
    }];
    [self.cleanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
    }];
}

- (void)onClickClearBtn:(UIButton *)sender {
    if (self.onClearHandler) {
        self.onClearHandler();
    }
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor grayColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _nameLabel.text = @"已选商品";
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _nameLabel;
}

- (UIView *)separateLine {
    if (!_separateLine) {
        _separateLine = [UIView new];
        _separateLine.backgroundColor = NAV_FGC;
    }
    return _separateLine;
}

- (UIButton *)cleanBtn {
    if (!_cleanBtn) {
        _cleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cleanBtn.adjustsImageWhenHighlighted = NO;
        _cleanBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _cleanBtn.titleOfNormal = @"清空";
        _cleanBtn.titleColorOfNormal = COLOR_HEX(0x666666);
        _cleanBtn.imageOfNormal = [UIImage imageNamed:@"icon_clear"];
        [_cleanBtn addTarget:self action:@selector(onClickClearBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cleanBtn;
}
@end
