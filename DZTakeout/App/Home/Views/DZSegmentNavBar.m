//
//  DZSegmentNavBar.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/15.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZSegmentNavBar.h"
#import "UIButton+HPUtil.h"
#import "DZSegment.h"

@interface DZSegmentNavBar () 

@property (nonatomic, strong) UIView *allSubviewsContainer;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) DZSegment *segment;

@end

@implementation DZSegmentNavBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    [self addSubview:self.allSubviewsContainer];
    [self.allSubviewsContainer addSubview:self.backBtn];
    @weakify(self);
    CGFloat offset = 10;
    [self.allSubviewsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self).offset(ASPECT_STATUS_BAR_H);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self).offset(offset);
        make.centerY.equalTo(self.allSubviewsContainer);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
}

#pragma mark - Private Functions
- (void)_touchUpInsideBackButon:(UIButton *)sender {
    if (self.returnBackHandler) {
        self.returnBackHandler(sender);
    }
}

- (void)_segmentSelectedIndex:(NSInteger)index {
    if (self.onSelectedIndexHandler) {
        self.onSelectedIndexHandler(index);
    }
}

#pragma mark - Public Functions
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (_segment) {
        [_segment setSelectedIndex:selectedIndex];
    }
}

#pragma mark - Getter & Setter
- (void)setSegmentTitles:(NSArray<NSString *> *)segmentTitles {
    _segmentTitles = segmentTitles.copy;
    if ([_segment superview]) {
        [_segment removeFromSuperview];
        _segment = nil;
    }
    if (segmentTitles.count == 0) { return; };
    [self.allSubviewsContainer addSubview:self.segment];
    
    @weakify(self);
    CGFloat offset = 10;
    CGFloat r_offset = -(offset * 2 + 26);
    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.backBtn.mas_right).offset(offset);
        make.right.equalTo(self.allSubviewsContainer).offset(r_offset);
        make.centerY.equalTo(self.allSubviewsContainer);
        make.height.mas_equalTo(26);
    }];
}

- (UIView *)allSubviewsContainer {
    if (!_allSubviewsContainer) {
        _allSubviewsContainer = [[UIView alloc] init];
    }
    return _allSubviewsContainer;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.imageOfNormal = [UIImage imageNamed:@"nav_nav_icon_back_normal"];
        [_backBtn addTarget:self action:@selector(_touchUpInsideBackButon:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (DZSegment *)segment {
    if (!_segment) {
        _segment = [[DZSegment alloc] initWithFrame:CGRectZero items:_segmentTitles];
        @weakify(self);
        _segment.onSelectedIndexHandler = ^(NSInteger index) {
            @strongify(self);
            [self _segmentSelectedIndex:index];
        };
        [_segment setCornerRadius:13.0f];
    }
    return _segment;
}
@end
