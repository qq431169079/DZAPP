//
//  DZGoodsProfileView.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/23.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZGoodsProfileView.h"
#import <UIImageView+WebCache.h>
#import "HPIncreaseButton.h"
#import "CompanyAllGoodsModel.h"

@interface DZGoodsProfileView ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *classifyLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *commentsLabel;
@property (nonatomic, strong) HPIncreaseButton *addOrRemoveBtn;
@property (nonatomic, strong) UIImageView *imageView;


@end

@implementation DZGoodsProfileView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
        [self setupSubviews];
        [self setupGestureRecognizer];
    }
    return self;
}

- (void)setupSubviews {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.classifyLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.commentsLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.addOrRemoveBtn];
    
    @weakify(self);
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self).offset(50);
        make.right.equalTo(self).offset(-50);
//        make.bottom.equalTo(self).offset(-100);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(self.imageView.mas_width);
    }];
    [self.classifyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.bottom.equalTo(self.imageView);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.imageView.mas_bottom).offset(15);
        make.left.equalTo(self.priceLabel);
    }];
    [self.commentsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.priceLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.commentsLabel.mas_bottom).offset(15);
    }];
    [self.addOrRemoveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-15);
        make.size.mas_equalTo(CGSizeMake(80, 20));
        make.top.equalTo(self.commentsLabel.mas_bottom).offset(15);
    }];
}

- (void)setupGestureRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeProfile:)];
    [self addGestureRecognizer:tap];
}

#pragma mark - Events Response
- (void)removeProfile:(UITapGestureRecognizer *)sender {
    [self remove];
}

- (void)removeOrAdd:(BOOL)add number:(CGFloat)number {
    if (add && self.onAddedGoodsToCartHandler) {
        CGRect rect = [self.addOrRemoveBtn convertRect:self.addOrRemoveBtn.increaseBtn.frame toView:self];
        CGRect startRect = [self convertRect:rect toView:[UIApplication sharedApplication].keyWindow];
        CGPoint startPoint = CGPointMake(startRect.origin.x + CGRectGetWidth(startRect) * 0.5f, startRect.origin.y + CGRectGetHeight(startRect) * 0.5f);
        _model.hasSelectedCount = number;
        self.onAddedGoodsToCartHandler(startPoint, self.model ,floor(number));
    }
    if (!add && self.removeGoodsHandler) {
        _model.hasSelectedCount = number;
        self.removeGoodsHandler(self.model);
    }
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.alpha = 0;
    self.contentView.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.35f animations:^{
        self.alpha = 1;
        self.contentView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        self.contentView.transform = CGAffineTransformIdentity;
    }];
}

- (void)remove {
    if ([self superview]) {
        self.alpha = 1;
        self.contentView.transform = CGAffineTransformMakeScale(1, 1);
        [UIView animateWithDuration:0.35f animations:^{
            self.alpha = 0;
            self.contentView.transform = CGAffineTransformMakeScale(0, 0);
        } completion:^(BOOL finished) {
            self.contentView.transform = CGAffineTransformIdentity;
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - Getter & Setter

- (void)setModel:(CompanyGoodModel *)model {
    _model = model;
    self.nameLabel.text = _model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", _model.price];
    self.classifyLabel.text = _model.ificationName;
    self.commentsLabel.text = [NSString stringWithFormat:@"好评率%.2f%%", ((1 - _model.svg_price) * 100)];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_model.zoom_url]];
    if (_model.hasSelectedCount > 0) {
        self.addOrRemoveBtn.currentNumber = _model.hasSelectedCount;
        [self.addOrRemoveBtn setRetract:NO];
    } else {
        self.addOrRemoveBtn.currentNumber = 0;
        [self.addOrRemoveBtn setRetract:YES];
    }
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 6;
        _contentView.clipsToBounds = YES;
    }
    return _contentView;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.textColor = NAV_FGC;
        _priceLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _priceLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    }
    return _nameLabel;
}

- (UILabel *)classifyLabel {
    if (!_classifyLabel) {
        _classifyLabel = [UILabel new];
        _classifyLabel.textColor = [UIColor whiteColor];
        _classifyLabel.font = [UIFont systemFontOfSize:13.0f];
        _classifyLabel.textAlignment = NSTextAlignmentLeft;
        _classifyLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    }
    return _classifyLabel;
}

- (UILabel *)commentsLabel {
    if (!_commentsLabel) {
        _commentsLabel = [UILabel new];
        _commentsLabel.textColor = [UIColor grayColor];
        _commentsLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    return _commentsLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.backgroundColor = [UIColor grayColor];
    }
    return _imageView;
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
