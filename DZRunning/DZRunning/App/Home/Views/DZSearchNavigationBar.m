//
//  MTSearchNavigationBar.m
//  xsh
//
//  Created by HuangPan on 2018/3/2.
//  Copyright © 2018年 Moemoe Technology. All rights reserved.
//

#import "DZSearchNavigationBar.h"
#import "UISearchBar+HPUtil.h"
#import "UIButton+HPUtil.h"

@interface DZSearchNavigationBar ()<UISearchBarDelegate>

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UIView *allSubviewsContainer;

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIView *rightViewContainer;

@property (nonatomic, strong) UIButton *searchBarContainer;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation DZSearchNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self addSubview:self.bgImgView];
    [self addSubview:self.allSubviewsContainer];
    [self.allSubviewsContainer addSubview:self.backBtn];
    [self.allSubviewsContainer addSubview:self.searchBarContainer];
    [self.searchBarContainer addSubview:self.searchBar];
    
    @weakify(self);
    CGFloat offset = 10;
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self);
    }];
    
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
    
    [self.searchBarContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.backBtn.mas_right).offset(offset);
        make.centerY.equalTo(self.allSubviewsContainer);
        make.height.mas_equalTo(26);
        make.right.equalTo(self.allSubviewsContainer).offset(-offset);
    }];
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.searchBarContainer);
    }];
}

- (BOOL)searchBecomeFirstResponder {
    return [self.searchBar becomeFirstResponder];
}

- (BOOL)searchResignFirstResponder {
    return [self.searchBar resignFirstResponder];
}

#pragma mark - Private Functions
- (void)_touchUpInsideBackButon:(UIButton *)sender {
    if (self.returnBackHandler) {
        self.returnBackHandler(sender);
    }
}

- (void)_touchUpInsidesearchBarContainer:(UIButton *)sender {
    if (self.onClickSearchBarHandler) {
        self.onClickSearchBarHandler();
    }
}

- (void)_addRightViewContainerIfNeeded {
    if (![self.rightViewContainer superview]) {
        [self.allSubviewsContainer addSubview:self.rightViewContainer];
    }
}

- (void)_addRightView:(UIView *)view {
    if (![self.rightViewContainer superview]) {
        [self.allSubviewsContainer addSubview:self.rightViewContainer];
    }
    [self.rightViewContainer.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.rightViewContainer addSubview:view];
}

#pragma mark - Getter & Setter
- (void)setSearchKey:(NSString *)searchKey {
    _searchKey = searchKey;
    self.searchBar.text = _searchKey;
}

- (void)setSearchBarEnable:(BOOL)searchBarEnable {
    _searchBarEnable = searchBarEnable;
    self.searchBar.userInteractionEnabled = _searchBarEnable;
}

- (void)setDelegate:(id<UISearchBarDelegate>)delegate {
    _delegate = delegate;
    self.searchBar.delegate = _delegate;
}

- (void)setRightView:(UIView *)rightView {
    _rightView = rightView;
    if (_rightView) {
        [self _addRightView:_rightView];
        
        @weakify(self);
        CGSize size = _rightView.bounds.size;
        [self.rightViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerY.equalTo(self.allSubviewsContainer);
            make.size.mas_equalTo(CGSizeMake(size.width, size.height));
            make.right.equalTo(self.allSubviewsContainer).offset(-10);
        }];
        [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.backBtn.mas_right).offset(10);
            make.centerY.equalTo(self.allSubviewsContainer);
            make.height.mas_equalTo(26);
            make.right.equalTo(self.rightViewContainer.mas_left).offset(-10);
        }];
    } else {
        @weakify(self);
        [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.backBtn.mas_right).offset(10);
            make.centerY.equalTo(self.allSubviewsContainer);
            make.height.mas_equalTo(26);
            make.right.equalTo(self.allSubviewsContainer).offset(-10);
        }];
    }
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    self.bgImgView.image = _backgroundImage;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImgView.clipsToBounds = YES;
    }
    return _bgImgView;
}

- (UIView *)allSubviewsContainer {
    if (!_allSubviewsContainer) {
        _allSubviewsContainer = [[UIView alloc] init];
    }
    return _allSubviewsContainer;
}

- (UIView *)rightViewContainer {
    if (!_rightViewContainer) {
        _rightViewContainer = [[UIView alloc] init];
    }
    return _rightViewContainer;
}

- (UIButton *)searchBarContainer {
    if (!_searchBarContainer) {
        _searchBarContainer = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBarContainer.adjustsImageWhenHighlighted = NO;
        [_searchBarContainer addTarget:self action:@selector(_touchUpInsidesearchBarContainer:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBarContainer;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.imageOfNormal = [UIImage imageNamed:@"nav_nav_icon_back_normal"];
        [_backBtn addTarget:self action:@selector(_touchUpInsideBackButon:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.placeholder = @"看看可以搜点什么";
        
        _searchBar.font = [UIFont systemFontOfSize:13.0f];
        
        _searchBar.clipCornerRadius = BTN_CRU;
        _searchBar.layer.cornerRadius = BTN_CRU;
        _searchBar.layer.masksToBounds = YES;
        
        _searchBar.barTintColor = [UIColor whiteColor];
        _searchBar.backgroundColor = [UIColor whiteColor];
        _searchBar.searchBarStyle = UISearchBarStyleDefault;
    }
    return _searchBar;
}

@end
