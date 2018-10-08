//
//  DZFakeNavigationBar.m
//  DZTakeout
//
//  Created by HuangPan on 2018/3/30.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZFakeNavigationBar.h"
#import "UIButton+HPUtil.h"
#import "UISearchBar+HPUtil.h"

@interface DZFakeNavigationBar () {
    
    CGRect m_selfOldFrame;
}

@property (nonatomic, strong) UIView *allSubviewsContainer;

@property (nonatomic, strong) UIButton *titleBtn;

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIView *separatorLine;

@property (nonatomic, strong) UIButton *messageBtn;
@property (nonatomic, strong) UIButton *shoppingCartBtn;

@property (nonatomic, strong) UIButton *searchBarContainer;
//@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation DZFakeNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    self.backgroundColor = NAV_FGC;
    m_selfOldFrame =  CGRectMake(0, 0, SCREEN_WIDTH, (ASPECT_NAV_HEIGHT + 35));
    _titleColor = [UIColor whiteColor];
    
    [self addSubview:self.allSubviewsContainer];
    [self.allSubviewsContainer addSubview:self.titleBtn];
//    [self.allSubviewsContainer addSubview:self.messageBtn];
//    [self.allSubviewsContainer addSubview:self.shoppingCartBtn];
    
    [self addSubview:self.searchBarContainer];
//    [self.searchBarContainer addSubview:self.searchBar];

    @weakify(self);
    
    [self.allSubviewsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-35.0f).priority(999);
        make.top.equalTo(self).offset(ASPECT_STATUS_BAR_H);
    }];
    
    [_titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.center.equalTo(self.allSubviewsContainer);
    }];
    
    [_shoppingCartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self).offset(-12.0f);
        make.centerY.equalTo(self.titleBtn);
        make.size.equalTo(self.messageBtn);
    }];
    
    [_messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self).offset(12.0f);
        make.size.mas_equalTo(CGSizeMake(30.0f, 30.0f));
        make.centerY.equalTo(self.titleBtn);
    }];
    
    [_searchBarContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self).offset(12.0f);
        make.right.equalTo(self).offset(-12.0f);
        make.height.mas_equalTo(30);
        make.bottom.equalTo(self).offset(-5);
    }];
    
//    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        @strongify(self);
//        make.centerX.equalTo(self.searchBarContainer);
//        make.centerY.equalTo(self.searchBarContainer);
//        make.width.mas_equalTo(180);
////        make.right.equalTo(self).offset(-12.0f);
//        make.height.mas_equalTo(30.0f);
////        make.top.equalTo(self.searchBarContainer);
//    }];
}

- (void)setTitle:(NSString *)title {
    
    _title = [title copy];
    self.titleBtn.titleOfNormal = _title;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    
    _backgroundImage = backgroundImage;
    
    if (_backgroundImage && !self.backgroundImageView) {
        self.backgroundImageView = [[UIImageView alloc] init];
        self.backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        self.backgroundImageView.backgroundColor = [UIColor clearColor];
        self.backgroundImageView.clipsToBounds = YES;
        [self addSubview:self.backgroundImageView];
        [self insertSubview:self.backgroundImageView atIndex:0];
        
        @weakify(self);
        [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
    
    self.backgroundImageView.image = _backgroundImage;;
}

- (void)setShowShadow:(BOOL)showShadow {
    
    _showShadow = showShadow;
    
    if (_showShadow && !self.separatorLine) {
        self.separatorLine = [[UIView alloc] init];
        self.separatorLine.backgroundColor = COLOR_HEX(0xeae8e4);
        [self addSubview:self.separatorLine];
        
        @weakify(self);
        [_separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(0.5f);
        }];
    }
    
    self.separatorLine.hidden = !_showShadow;
}

- (void)setBackgroundAlpha:(CGFloat)backgroundAlpha {
    
    if (backgroundAlpha < 0) {
        backgroundAlpha = 0;
    }
    
    if (backgroundAlpha > 1) {
        backgroundAlpha = 1;
    }
    
    if (!self.backgroundImageView) {
        return;
    }
    
    _backgroundAlpha = backgroundAlpha;
    
    self.backgroundImageView.alpha = _backgroundAlpha;
}

- (void)setTitleColor:(UIColor *)titleColor {
    
    _titleColor = titleColor;
    self.titleBtn.titleColorOfNormal = _titleColor;
}


#pragma mark - Private Functions

- (void)_touchUpInsideMessageBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(navBar:onClickMessageButton:)]) {
        [self.delegate navBar:self onClickMessageButton:sender];
    }
}

- (void)_touchUpInsideShoppingCartBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(navBar:onClickShoppingCartButton:)]) {
        [self.delegate navBar:self onClickShoppingCartButton:sender];
    }
}

- (void)_touchUpInsidesearchBarContainer:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(navBar:onClickSearchBar:)]) {
        [self.delegate navBar:self onClickSearchBar:self.searchBarContainer];
    }
}

- (void)_touchUpInsideTitleButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(navBar:onClickTitleButton:)]) {
        [self.delegate navBar:self onClickTitleButton:sender];
    }
}

#pragma mark - Getter & Setter

- (UIView *)allSubviewsContainer {
    if (!_allSubviewsContainer) {
        _allSubviewsContainer = [[UIView alloc] init];
    }
    return _allSubviewsContainer;
}

- (UIButton *)messageBtn {
    if (!_messageBtn) {
        _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _messageBtn.imageOfNormal = [UIImage imageNamed:@"icon_message"];
        _messageBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_messageBtn addTarget:self action:@selector(_touchUpInsideMessageBtn:) forControlEvents:UIControlEventTouchUpInside];
        _messageBtn.adjustsImageWhenHighlighted = NO;
    }
    return _messageBtn;
}

- (UIButton *)shoppingCartBtn {
    if (!_shoppingCartBtn) {
        _shoppingCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shoppingCartBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _shoppingCartBtn.imageOfNormal = [UIImage imageNamed:@"icon_shopping_cart"];
         [_shoppingCartBtn addTarget:self action:@selector(_touchUpInsideShoppingCartBtn:) forControlEvents:UIControlEventTouchUpInside];
        _shoppingCartBtn.adjustsImageWhenHighlighted = NO;
    }
    return _shoppingCartBtn;
}

- (UIButton *)searchBarContainer {
    if (!_searchBarContainer) {
        _searchBarContainer = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBarContainer.adjustsImageWhenHighlighted = NO;
        [_searchBarContainer addTarget:self action:@selector(_touchUpInsidesearchBarContainer:) forControlEvents:UIControlEventTouchUpInside];
        _searchBarContainer.backgroundColor = [UIColor whiteColor];
        _searchBarContainer.layer.cornerRadius = BTN_CRU;
        _searchBarContainer.layer.masksToBounds = YES;
        [_searchBarContainer setTitle: @"看看可以搜点什么" forState:UIControlStateNormal];
        [_searchBarContainer.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [_searchBarContainer setTitleColor:RGB(153,153,153) forState:UIControlStateNormal];
        _searchBarContainer.backgroundColor = [UIColor whiteColor];
        [_searchBarContainer setImage:[UIImage imageNamed:@"search_bar_icon"] forState:UIControlStateNormal];
        CGFloat offset = (SCREEN_WIDTH - 30 -14) *0.5;
        _searchBarContainer.imageEdgeInsets = UIEdgeInsetsMake(8, offset-55, 8, offset+61);
        
    }
    return _searchBarContainer;
}

//- (UISearchBar *)searchBar {
//    if (!_searchBar) {
//        _searchBar = [[UISearchBar alloc] init];
//        _searchBar.placeholder = @"看看可以搜点什么";
//
//        _searchBar.font = [UIFont systemFontOfSize:13.0f];
//
//        _searchBar.clipCornerRadius = BTN_CRU;
//        _searchBar.layer.cornerRadius = BTN_CRU;
//        _searchBar.layer.masksToBounds = YES;
//        _searchBar.userInteractionEnabled = NO;
//        _searchBar.barTintColor = [UIColor whiteColor];
//        _searchBar.backgroundColor = [UIColor whiteColor];
//        _searchBar.searchBarStyle = UISearchBarStyleDefault;
//    }
//    return _searchBar;
//}

- (UIButton *)titleBtn {
    if (!_titleBtn) {
        _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleBtn.adjustsImageWhenHighlighted = NO;
        _titleBtn.titleColorOfNormal = _titleColor;
        _titleBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [_titleBtn addTarget:self action:@selector(_touchUpInsideTitleButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleBtn;
}


/**
 监听滑动事件
 */
- (void)gradation_scrollViewDidScroll:(UIScrollView *)scrollView {
    // 更改导航栏状态
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    // 需要添加动画
    if (contentOffsetY <= 0) {
        
        [self setAnimationStep:1];
        
        self.frame = m_selfOldFrame;
        if (self.adjustNavBarFrameHandler) {
            self.adjustNavBarFrameHandler(m_selfOldFrame);
        }
    }
    else if (contentOffsetY <= 45) {
        
        CGFloat alpha = (45 - contentOffsetY) / 45.0f;
        [self setAnimationStep:alpha];
        CGRect frame = m_selfOldFrame;
        frame.size.height -= contentOffsetY;
        self.frame = frame;
        if (self.adjustNavBarFrameHandler) {
            self.adjustNavBarFrameHandler(frame);
        }
    } else {
        
        [self setAnimationStep:0];
        
        CGRect frame = m_selfOldFrame;
        frame.size.height -= 45;
        self.frame = frame;
        if (self.adjustNavBarFrameHandler) {
            self.adjustNavBarFrameHandler(frame);
        }
    }
}

- (void)gradation_scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //@weakify(self);
//    [self resetAnimationDropDown:^(BOOL dropDown, CGFloat step) {
//        @strongify(self);
//        [self _resetScrollView:scrollView isDropDown:dropDown];
//    }];
}

- (void)gradation_scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // 自动恢复导航栏状态相关
    if (!decelerate) {
//        @weakify(self);
//        [self resetAnimationDropDown:^(BOOL dropDown, CGFloat step) {
//            @strongify(self);
//        }];
    }
}

- (void)setAnimationStep:(CGFloat)step {
    if (step < 0 || step > 1)
        return;
    if (self.allSubviewsContainer.alpha == step)
        return;
    self.allSubviewsContainer.alpha = step;
    self.titleBtn.titleLabel.font = [self _fontByStep:step];
}

- (UIFont *)_fontByStep:(CGFloat)step {
    CGFloat beginFontSize = 13.0f;
    CGFloat endFontSize = 18.0f;
    CGFloat currentSize = beginFontSize + (endFontSize - beginFontSize) * step;
    return [UIFont systemFontOfSize:currentSize];
}

@end
