//
//  DZMenuScrollView.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/22.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZMenuScrollView.h"
#import "UIButton+HPUtil.h"
#import "NSString+HPUtil.h"

@interface MenuButton : UIButton {
    NSInteger _badgeCount;
}
- (void)changedBadge:(NSInteger)count;
@end

@interface MenuButton ()
@property (nonatomic, strong) UILabel *badgeLabel;
@end

@implementation MenuButton
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self addSubview:self.badgeLabel];
    
    @weakify(self);
    [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
    }];
}

- (void)changedBadge:(NSInteger)count {
    
    _badgeCount += count;
    if (_badgeCount <= 0) {
        _badgeCount = 0;
        self.badgeLabel.hidden = YES;
        return;
    }
    self.badgeLabel.hidden = NO;
    NSString *t = [NSString stringWithFormat:@"%zd", _badgeCount];
    self.badgeLabel.text = t;
    CGFloat width = [t sizeWithMaxWidth:CGFLOAT_MAX font:[UIFont systemFontOfSize:13.0f]].width + 10;
    width = MAX(20, width);
    [self.badgeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
}

- (UILabel *)badgeLabel {
    if (!_badgeLabel) {
        _badgeLabel = [UILabel new];
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.backgroundColor = NAV_FGC;
        _badgeLabel.font = [UIFont systemFontOfSize:13.0f];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.layer.cornerRadius = 10;
        _badgeLabel.layer.masksToBounds = YES;
        _badgeLabel.hidden = YES;
    }
    return _badgeLabel;
}
@end

static NSInteger const MENU_BTN_TAG_START_INDEX = 1000;

@interface DZMenuScrollView () {
    UIButton *_selectedMenuBtn;
    
    CGFloat _oldWidth;
    BOOL _layout;
}

@property (nonatomic, strong) NSMutableArray<MenuButton *> *menuBtns;
@end

@implementation DZMenuScrollView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _selectedMenuBtn = [[UIButton alloc] init];
        _oldWidth = CGRectGetWidth(frame);
        _layout = YES;
        self.menuBtns = [NSMutableArray array];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    BOOL widthChanged = (width != _oldWidth);
    if (!widthChanged && !_layout) { return; }
    __block CGFloat startY = 0;
    [self.menuBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger index = obj.tag - MENU_BTN_TAG_START_INDEX;
        CGFloat height = [self.menuDelegate menu:self heightForIndex:index];
        obj.frame = CGRectMake(0, startY, width, height);
        startY += height;
    }];
    self.contentSize = CGSizeMake(width, startY);
    _layout = NO;
    _oldWidth = width;
}

#pragma mark - Public Funtions
- (void)setSelectedMenuAtIndex:(NSInteger)index {
    if (index < 0 || index > self.menuBtns.count) {
        return;
    }
    
    UIButton *targetMenu = [self viewWithTag:(index + MENU_BTN_TAG_START_INDEX)];
    if ([targetMenu isKindOfClass:UIButton.class]) {
        _selectedMenuBtn.selected = NO;
        targetMenu.selected = YES;
        _selectedMenuBtn = targetMenu;
    }
}

- (void)changedBadge:(NSInteger)badge atIndex:(NSUInteger)index {
    if (index < self.menuBtns.count) {
        MenuButton *target = self.menuBtns[index];
        [target changedBadge:badge];
    }
}
-(void)clearAllBage{
    for (MenuButton *target in self.menuBtns) {
        [target changedBadge:-1000];
        
    }
}
#pragma mark - Events Response
- (void)onClickMenuBtn:(MenuButton *)sender {
    _selectedMenuBtn.selected = NO;
    sender.selected = YES;
    _selectedMenuBtn = sender;
    
    NSInteger index = (sender.tag - MENU_BTN_TAG_START_INDEX);
    if ([self.menuDelegate respondsToSelector:@selector(menu:onSelectIndex:)]) {
        [self.menuDelegate menu:self onSelectIndex:index];
    }
}

#pragma mark - Getter & Setter
- (void)setMenuModels:(NSArray<id<DZMenuModelProtocol>> *)menuModels {
    _menuModels = menuModels;
    
    [self.menuBtns removeAllObjects];
    [_menuModels enumerateObjectsUsingBlock:^(id<DZMenuModelProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        MenuButton *menu = [self _menuBtnWithTitle:obj.name];
        [menu addTarget:self action:@selector(onClickMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
        menu.tag = idx + MENU_BTN_TAG_START_INDEX;
        if (idx == 0) {
            menu.selected = YES;
            _selectedMenuBtn = menu;
        }
        [self addSubview:menu];
        [self.menuBtns addObject:menu];
    }];
    _layout = YES;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - Private Functions
- (MenuButton *)_menuBtnWithTitle:(NSString *)title {
    MenuButton *menu = [MenuButton buttonWithType:UIButtonTypeCustom];
    menu.titleOfNormal = title;
    menu.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    menu.titleLabel.textAlignment = NSTextAlignmentCenter;
    menu.titleColorOfNormal = [UIColor grayColor];
    menu.titleColorOfSelected = NAV_FGC;
    menu.backgroudColorOfNormal = COLOR_HEX(0xf5f5f5);
    menu.backgroudColorOfSelected = [UIColor whiteColor];
    return menu;
}
@end
