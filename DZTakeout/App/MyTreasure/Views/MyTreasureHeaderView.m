//
//  MyTreasureHeaderView.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/25.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "MyTreasureHeaderView.h"
#import "UIButton+HPUtil.h"
#import "UIImage+HPUtil.h"
#import <UIImageView+WebCache.h>

#define MyTreasureHeaderNavBarH (105.0f + ASPECT_STATUS_BAR_H)
#define MyTreasureContentViewH  (121.0f)

UIKIT_EXTERN CGFloat MyTreasureHeaderViewHeight(void) {
    static dispatch_once_t onceToken;
    static CGFloat height = 0;
    dispatch_once(&onceToken, ^{
        height = (78 + ASPECT_STATUS_BAR_H + MyTreasureContentViewH);
    });
    return height;
}

@interface MyTreasureHeaderView ()

@property (nonatomic, strong) UIImageView *navBar;
@property (nonatomic, strong) UIView *navContentView;

@property (nonatomic, strong) UIButton *exitBtn;
@property (nonatomic, strong) UIButton *settingBtn;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *QRCodeBtn;
@property (nonatomic, strong) UIImageView *avatarImgView;

@property (nonatomic, strong) UILabel *purseValue;
@property (nonatomic, strong) UILabel *purseLabel;

@property (nonatomic, strong) UILabel *redPacketsValue;
@property (nonatomic, strong) UILabel *redPacketsLabel;

@property (nonatomic, strong) UIView *dividingView;
@end

@implementation MyTreasureHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self addSubview:self.navBar];
    [self addSubview:self.navContentView];
    [self.navContentView addSubview:self.settingBtn];
    [self.navContentView addSubview:self.exitBtn];
    
    [self addSubview:self.contentView];
    [self addSubview:self.avatarImgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.QRCodeBtn];
    [self.contentView addSubview:self.purseValue];
    [self.contentView addSubview:self.purseLabel];
    [self.contentView addSubview:self.redPacketsLabel];
    [self.contentView addSubview:self.redPacketsValue];
    [self.contentView addSubview:self.dividingView];
    
    @weakify(self);
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(MyTreasureHeaderNavBarH);
    }];
    [self.navContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self).offset(ASPECT_STATUS_BAR_H);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(44);
    }];
    [self.settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.navContentView).offset(12);
        make.centerY.equalTo(self.navContentView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.navContentView).offset(-12);
        make.centerY.equalTo(self.navContentView);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self).offset(67 + ASPECT_STATUS_BAR_H);
        make.left.equalTo(self).offset(12.0f);
        make.right.equalTo(self).offset(-12.0f);
        make.height.mas_equalTo(MyTreasureContentViewH);
    }];
    [self.dividingView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(7);
    }];
    [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.contentView).offset(20);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.avatarImgView).offset(5);
        make.left.equalTo(self.avatarImgView.mas_right).offset(20);
    }];
    [self.QRCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView).offset(-20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.purseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.avatarImgView).offset(10);
        make.bottom.equalTo(self.contentView).offset(-18);
    }];
    [self.purseValue mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.purseLabel);
        make.bottom.equalTo(self.purseLabel.mas_top).offset(-5);
    }];
    [self.redPacketsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.purseLabel);
        make.centerX.equalTo(self.contentView);
    }];
    [self.redPacketsValue mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.redPacketsLabel);
        make.centerY.equalTo(self.purseValue);
    }];
}

#pragma mark - Event Response
- (void)onTouchUpInsideQRBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(headerView:touchUpInsideQRButton:)]) {
        [self.delegate headerView:self touchUpInsideQRButton:sender];
    }
}

- (void)onTouchUpInsideSettingBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(headerView:touchUpInsideSettingButton:)]) {
        [self.delegate headerView:self touchUpInsideSettingButton:sender];
    }
}

- (void)onTouchUpInsideExitBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(headerView:touchUpInsideExitButton:)]) {
        [self.delegate headerView:self touchUpInsideExitButton:sender];
    }
}

#pragma mark - Getter & Setter
- (UIImageView *)navBar {
    if (!_navBar) {
        _navBar = [UIImageView new];
        _navBar.contentMode = UIViewContentModeScaleAspectFill;
        UIColor *startColor = COLOR_HEX(0xFE9711);
        UIColor *endColor = NAV_FGC;
        _navBar.image = [UIImage gradientColorImageFromColors:@[startColor, endColor] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(SCREEN_WIDTH, MyTreasureHeaderNavBarH)];
    }
    return _navBar;
}

- (UIView *)navContentView {
    if (!_navContentView) {
        _navContentView = [UIView new];
        _navContentView.backgroundColor = [UIColor clearColor];
    }
    return _navContentView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 6;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UIView *)dividingView {
    if (!_dividingView) {
        _dividingView = [UIView new];
        _dividingView.backgroundColor = NAV_FGC;
    }
    return _dividingView;
}

- (UILabel *)purseLabel {
    if (!_purseLabel) {
        _purseLabel = [UILabel new];
        _purseLabel.text = @"钱包余额";
        _purseLabel.font = [UIFont systemFontOfSize:12];
        _purseLabel.textColor = COLOR_HEX(0x999999);
    }
    return _purseLabel;
}

- (UILabel *)purseValue {
    if (!_purseValue) {
        _purseValue = [UILabel new];
        _purseValue.text = @"0";
        _purseValue.font = [UIFont systemFontOfSize:18];
        _purseValue.textColor = COLOR_HEX(0x333333);
    }
    return _purseValue;
}

- (UILabel *)redPacketsValue {
    if (!_redPacketsValue) {
        _redPacketsValue = [UILabel new];
        _redPacketsValue.text = @"0";
        _redPacketsValue.font = [UIFont systemFontOfSize:18];
        _redPacketsValue.textColor = COLOR_HEX(0x333333);
    }
    return _redPacketsValue;
}

- (UILabel *)redPacketsLabel {
    if (!_redPacketsLabel) {
        _redPacketsLabel = [UILabel new];
        _redPacketsLabel.text = @"红包余额";
        _redPacketsLabel.font = [UIFont systemFontOfSize:12];
        _redPacketsLabel.textColor = COLOR_HEX(0x999999);
    }
    return _redPacketsLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = COLOR_HEX(0xFF7E00);
    }
    return _nameLabel;
}

- (UIImageView *)avatarImgView {
    if (!_avatarImgView) {
        _avatarImgView = [UIImageView new];
        _avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImgView.backgroundColor = [UIColor grayColor];
        _avatarImgView.layer.cornerRadius = 25.0f;
        _avatarImgView.clipsToBounds = YES;
        _avatarImgView.image = [UIImage imageNamed:@"icon_avatar_default"];
    }
    return _avatarImgView;
}

- (UIButton *)QRCodeBtn {
    if (!_QRCodeBtn) {
        _QRCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _QRCodeBtn.adjustsImageWhenHighlighted = NO;
        _QRCodeBtn.imageOfNormal = [UIImage imageNamed:@"icon_qrcode"];
        [_QRCodeBtn addTarget:self action:@selector(onTouchUpInsideQRBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _QRCodeBtn;
}

- (UIButton *)settingBtn {
    if (!_settingBtn) {
        _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _settingBtn.adjustsImageWhenHighlighted = NO;
        _settingBtn.imageOfNormal = [UIImage imageNamed:@"icon_setting"];
        [_settingBtn addTarget:self action:@selector(onTouchUpInsideSettingBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingBtn;
}

- (UIButton *)exitBtn {
    if (!_exitBtn) {
        _exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _exitBtn.adjustsImageWhenHighlighted = NO;
        _exitBtn.titleOfNormal = @"退出";
        _exitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _exitBtn.titleColorOfNormal = [UIColor whiteColor];
        [_exitBtn addTarget:self action:@selector(onTouchUpInsideExitBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitBtn;
}

@end
