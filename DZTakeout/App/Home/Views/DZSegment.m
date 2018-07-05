//
//  DZSegment.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/23.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZSegment.h"
#import "UIButton+HPUtil.h"
#import "NSString+HPUtil.h"

@interface DZSegment () {
    NSArray<NSString *> *_titles;
    NSMutableArray<UIButton *> *_segmentBtns;
    UIButton *_selectedBtn;
}
@property (nonatomic, strong) UIView *contentView;
@end

@implementation DZSegment

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray<NSString *> *)items {
    self = [super initWithFrame:frame];
    if (self) {
        _titles = items.copy;
        _margin = 10.0f;
        _segmentBtns = [NSMutableArray array];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    [self addSubview:self.contentView];
    [_titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [self _createBtnWithTitle:obj];
        btn.tag = idx + 1;
        if (idx == 0) {
            btn.selected = YES;
            _selectedBtn = btn;
        };
        [self.contentView addSubview:btn];
        [_segmentBtns addObject:btn];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
  
    __block CGFloat totalWidth = 0;
    [_titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        totalWidth += ([obj sizeWithMaxWidth:CGFLOAT_MAX font:[UIFont systemFontOfSize:16.0f]].width + _margin * 2);
    }];
    CGFloat w = CGRectGetWidth(self.bounds);
    if (totalWidth > w) {
        totalWidth = w;
    }
    if (_segmentBtns.count > 0) {
        CGFloat width = totalWidth / _segmentBtns.count;
        CGFloat height = CGRectGetHeight(self.bounds);
        
        __block CGFloat startX = (w - totalWidth) * 0.5f;
        self.contentView.frame = CGRectMake(startX, 0, totalWidth, height);
        startX = 0;
        [_segmentBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.frame = CGRectMake(startX, 0, width, height);
            startX += width;
        }];
    }
}

#pragma mark - Event Response
- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.contentView.layer.cornerRadius = cornerRadius;
    self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.contentView.layer.borderWidth = 1.0f;
    self.contentView.clipsToBounds = YES;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if ((_selectedBtn.tag - 1) != selectedIndex) {
        UIButton *selectedBtn = [self.contentView viewWithTag:(selectedIndex + 1)];
        if (selectedBtn && [selectedBtn isKindOfClass:UIButton.class]) {
            _selectedBtn.selected = NO;
            selectedBtn.selected = YES;
            _selectedBtn = selectedBtn;
        }
    }
}

- (void)onTouchUpInside:(UIButton *)sender {
    _selectedBtn.selected = NO;
    sender.selected = YES;
    _selectedBtn = sender;
    if (self.onSelectedIndexHandler) {
        self.onSelectedIndexHandler(sender.tag - 1);
    }
}

#pragma mark - Private Functions
- (UIButton *)_createBtnWithTitle:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    btn.adjustsImageWhenHighlighted = NO;
    btn.titleOfNormal = title;
    btn.titleColorOfNormal = [UIColor whiteColor];
    btn.titleColorOfSelected = NAV_FGC;
    btn.backgroudColorOfNormal = NAV_FGC;
    btn.backgroudColorOfSelected = [UIColor whiteColor];
    [btn addTarget:self action:@selector(onTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - Getter & Setter
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}

@end
