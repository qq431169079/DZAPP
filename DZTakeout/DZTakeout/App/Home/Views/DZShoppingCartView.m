
//
//  DZShoppingCartView.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/21.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZShoppingCartView.h"
#import "UIButton+HPUtil.h"
#import "NSString+HPUtil.h"
#import "__FormatGoodsNode.h"
#import "DZShoppingCartRelatedView.h"

static NSString * CartDetailCellReuseIDKey = @"CartDetailCellReuseIdentifier";
static NSString * CartDetailHeaderReuseIDKey = @"CartDetailHeaderReuseID";
static CGFloat DetailCellHeight = 60;
static CGFloat DetailHeaderHeight = 30;

@interface DZShoppingCartView ()<UITableViewDelegate, UITableViewDataSource> {
    NSString *_pricePlacehold;
    NSInteger _numberOfTotalGoods; // 总数量
    CGFloat _totalPrice; // 总价格
}
@property (nonatomic, strong) UILabel *bageLabel;// 价格标签
@property (nonatomic, strong) UILabel *priceLabel;// 价格
@property (nonatomic, strong) UILabel *logisticsLabel;// 物流
@property (nonatomic, strong) UILabel *noticeLabel;
@property (nonatomic, strong) UIButton *cartStatusBtn;
@property (nonatomic, strong) UIButton *commitPriceBtn;

@property (nonatomic, strong) NSMutableDictionary<NSString *, __FormatGoodsNode *> *goodsDict;

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DZShoppingCartView
+ (instancetype)shoppingCart {
    static dispatch_once_t onceToken;
    static DZShoppingCartView *cartView;
    dispatch_once(&onceToken, ^{
        cartView = [[DZShoppingCartView alloc] initWithFrame:CGRectZero];
    });
    return cartView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor darkGrayColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    _pricePlacehold = @"¥5元起送";
    _numberOfTotalGoods = 0;
    _totalPrice = 0.0f;
    self.goodsDict = [NSMutableDictionary dictionary];
    [self addSubview:self.cartStatusBtn];
    [self addSubview:self.bageLabel];
    [self addSubview:self.noticeLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.logisticsLabel];
    [self addSubview:self.commitPriceBtn];
    
    @weakify(self);
    [self.cartStatusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(-15);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self);
        make.left.equalTo(self.cartStatusBtn.mas_right).offset(15);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self).offset(5);
        make.left.equalTo(self.noticeLabel);
    }];
    [self.logisticsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self).offset(-5);
        make.left.equalTo(self.noticeLabel);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSString *title = [self.commitPriceBtn titleOfDisabled];
    if (self.commitPriceBtn.isEnabled) {
        title = [self.commitPriceBtn titleOfNormal];
    }
    CGFloat width = [title sizeWithMaxWidth:CGFLOAT_MAX font:[UIFont boldSystemFontOfSize:16.0f]].width + 50;
    self.commitPriceBtn.frame = CGRectMake(CGRectGetWidth(self.bounds) - width, 0, width, CGRectGetHeight(self.bounds));
    
    width = [self.bageLabel.text sizeWithMaxWidth:CGFLOAT_MAX font:[UIFont systemFontOfSize:11]].width + 5;
    width = MAX(20, width);
    // 标签
    self.bageLabel.frame = CGRectMake(CGRectGetMaxX(self.cartStatusBtn.frame) - width * 0.5f, -10, width, 20.0f);
}

- (void)onClickcommitPriceBtn:(UIButton *)sender {
    if (self.isBusiness) {
        if (self.onPrepareCommitHandler) {
            self.onPrepareCommitHandler();
        }
    }else{
         occasionalHint(@"打烊了");
    }

}

- (NSInteger)numberOfGooods:(CompanyGoodModel *)goods {
    __block NSInteger count = 0;
    [self.goodsDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, __FormatGoodsNode * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:goods.gid]) {
            count = [obj count];
            *stop = YES;
        };
    }];
    return count;
}

- (void)newlyAddedGoods:(CompanyGoodModel *)goods toCart:(NSInteger)number {
    if (!goods) { return; }
    if (number == 0) {
        NSString *key = goods.gid;
        __FormatGoodsNode *n = self.goodsDict[key];
        if (n) {
            _numberOfTotalGoods -= [n count];
            _totalPrice -= [n totalPrice];
            [self.goodsDict removeObjectForKey:key];
        }
        return;
    };
    __block BOOL exsited = NO;
    [self.goodsDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, __FormatGoodsNode * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:goods.gid]) {
            _numberOfTotalGoods -= [obj count];
            _totalPrice -= [obj totalPrice];
            [obj resetModel:goods withNumber:number];
            _numberOfTotalGoods += number;
            _totalPrice += [obj totalPrice];
            exsited = YES;
            *stop = YES;
        };
    }];
    if (!exsited) {
        __FormatGoodsNode *n = [__FormatGoodsNode new];
        n.key = goods.gid;
        [n resetModel:goods withNumber:number];
        [self.goodsDict setObject:n forKey:n.key];
        _numberOfTotalGoods += number;
        _totalPrice += [n totalPrice];
    }
    [self upShopInfo:_numberOfTotalGoods>0];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
-(void)upShopInfo:(BOOL)canPay{
    // 更新数据
    if (canPay) {
        
        self.noticeLabel.hidden = YES;
        self.priceLabel.hidden = NO;
        self.logisticsLabel.hidden = NO;
        self.bageLabel.hidden = NO;
        
        self.bageLabel.text = [NSString stringWithFormat:@"%zd", _numberOfTotalGoods];
        self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", _totalPrice];
        self.logisticsLabel.text = [NSString stringWithFormat:@"另需配送费¥%.2f", self.logisticsPrice]; // 配送费
        if (_totalPrice>= [self.minPrice floatValue]) {
            self.commitPriceBtn.titleOfNormal = @"去结算";
            self.commitPriceBtn.enabled = YES;
        }else{
            self.commitPriceBtn.enabled = NO;
        }
        self.cartStatusBtn.enabled = YES;
        self.commitPriceBtn.enabled = YES;
    } else {
        self.cartStatusBtn.enabled = NO;
        self.commitPriceBtn.enabled = NO;
        
        self.noticeLabel.hidden = NO;
        self.priceLabel.hidden = YES;
        self.logisticsLabel.hidden = YES;
        self.bageLabel.hidden = YES;
    }
}
- (void)removeGoods:(CompanyGoodModel *)goods {
    if (!goods) { return; }
    [self.goodsDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, __FormatGoodsNode * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:goods.gid]) {
            _numberOfTotalGoods -= [obj count];
            _totalPrice -= [obj totalPrice];
            [obj removeLastObject];
            _numberOfTotalGoods += [obj count];
            _totalPrice += [obj totalPrice];
            *stop = YES;
        };
    }];
    
    // 更新数据
    [self upShopInfo:_numberOfTotalGoods > 0];

    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
-(NSDictionary *)getAllGoodsByCompanyId:(NSString *)companyId{
    NSMutableDictionary *allGoodsDict = [NSMutableDictionary dictionary];
    if ([companyId isEqualToString:self.companyId]) {
        for (NSString *key in [self.goodsDict allKeys]) {
            __FormatGoodsNode *n = self.goodsDict[key];
            NSInteger goodNum = [n count];
            [allGoodsDict setObject:[NSString stringWithFormat:@"%ld",(long)goodNum] forKey:key];
        }
    }
    return allGoodsDict;
}
#pragma mark - Event Response
- (void)showAllGoodsInCartDetails {
    NSUInteger count = self.goodsDict.count;
    if (count > 0) {
        if ([_tableView superview] && [_maskView superview]) {
            [self hiddenGoodsShowView];

        }else{
            CGFloat height = CGRectGetHeight(self.frame);
            CGFloat h = count * DetailCellHeight;
            h = MIN(h, (5 * DetailCellHeight)); //最多现实5行
            self.maskView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - height);
            CGRect frame = self.tableView.frame = CGRectMake(0, SCREEN_HEIGHT - height - h - DetailHeaderHeight, SCREEN_WIDTH, h + DetailHeaderHeight);
            frame.origin.y += (h + DetailHeaderHeight);
            self.tableView.frame = frame;
            [self.superview addSubview:self.maskView];
            [self.superview addSubview:self.tableView];
            [self.superview bringSubviewToFront:self];
            
            frame.origin.y -= (h + DetailHeaderHeight);
            [UIView animateWithDuration:0.35f animations:^{
                self.tableView.frame = frame;
            } completion:^(BOOL finished) {
                [self.tableView reloadData];
            }];
        }

    } else {
        [self removeTableViewIfNeededComplete:nil];
    }
}

- (void)removeGoodFromCart:(CompanyGoodModel *)model atIndex:(NSIndexPath *)indexPath {
    [self removeGoods:model];
    // 修改左边菜单栏
    if (self.onChangedBadgeHanlder) {
        self.onChangedBadgeHanlder(-1, model);
    }
}

- (void)newlyAddedGoods:(CompanyGoodModel *)goods toCart:(NSInteger)number atIndex:(NSIndexPath *)indexPath {
    NSInteger count = [self numberOfGooods:goods];
    // 加入购物车
    [self newlyAddedGoods:goods toCart:number];
    // 修改左边菜单栏
    if (self.onChangedBadgeHanlder) {
        NSInteger c = (number - count);
        self.onChangedBadgeHanlder(c, goods);
    }
}

- (void)onTapGestureRecognizer:(UITapGestureRecognizer *)sender {
    [self removeTableViewIfNeededComplete:nil];
}

- (void)removeTableViewIfNeededComplete:(void(^)(void))complete {
    if ([_tableView superview]) {
        CGRect rect = _tableView.frame;
        rect.origin.y = CGRectGetMinY(self.frame);
        [UIView animateWithDuration:0.35f animations:^{
            _maskView.alpha = 0;
            _tableView.frame = rect;
        } completion:^(BOOL finished) {
            _maskView.alpha = 1;
            [_tableView removeFromSuperview];
            [_maskView removeFromSuperview];
            if (complete) {
                complete();
            }
        }];
    } else {
        if (complete) {
            complete();
        }
    }
}

- (void)clearAllGoods {
    [self.goodsDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, __FormatGoodsNode * _Nonnull obj, BOOL * _Nonnull stop) {
            NSInteger count = [obj count];
        while (count>0) {
            CompanyGoodModel *goodModel = [obj modelAtIndex:0];
            if (self.onChangedBadgeHanlder) {
                goodModel.hasSelectedCount = 0;
                self.onChangedBadgeHanlder(0, goodModel);
            }
            
            [obj removeFirstObject];
            count = [obj count];
            NSLog(@"移除了一个商品");
        }
    }];
    
    self.companyId = nil;
    self.logisticsPrice = 0;

    [self.goodsDict removeAllObjects];
    _numberOfTotalGoods = 0;
    _totalPrice = 0;
    
    self.cartStatusBtn.enabled = NO;
    self.commitPriceBtn.enabled = NO;
    
    self.noticeLabel.hidden = NO;
    self.priceLabel.hidden = YES;
    self.logisticsLabel.hidden = YES;
    self.bageLabel.hidden = YES;
    [self.tableView reloadData];
    [self hiddenGoodsShowView];
    if (self.clearAllGoodsHandler){
        self.clearAllGoodsHandler();
    }
}

#pragma mark - Public Functions
- (void)show {
    if ([self superview]) {
        [self removeFromSuperview];
    }
    self.frame = CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50);
    UIView *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}

- (void)remove {
    if ([self superview]) {
        @weakify(self);
        [self removeTableViewIfNeededComplete:^{
            @strongify(self);
            [self removeFromSuperview];
        }];
    }
}

- (void)clear {
    
    self.companyId = nil;
    self.logisticsPrice = 0;
    self.onPrepareCommitHandler = nil;
    self.onChangedBadgeHanlder = nil;
    [self.goodsDict removeAllObjects];
    _numberOfTotalGoods = 0;
    _totalPrice = 0;
    
    self.cartStatusBtn.enabled = NO;
    self.commitPriceBtn.enabled = NO;
    
    self.noticeLabel.hidden = NO;
    self.priceLabel.hidden = YES;
    self.logisticsLabel.hidden = YES;
    self.bageLabel.hidden = YES;

    [self remove];
}
-(void)removeCurOrd:(NSString *)cid{
    NSDictionary *params = @{@"cid":cid, @"token":[UserHelper userToken]};
    [DZRequests post:@"clearShop" parameters:params success:^(id record) {
        NSLog(@"清空购物车成功");
    } failure:^(HPRequestsError type, NSError *error) {
        NSLog(@"清空购物车失败");
    }];
}

-(void)hiddenGoodsShowView{
    CGRect rect = _tableView.frame;
    rect.origin.y = CGRectGetMinY(self.frame);
    [UIView animateWithDuration:0.35f animations:^{
        _maskView.alpha = 0;
        _tableView.frame = rect;
    } completion:^(BOOL finished) {
        _maskView.alpha = 1;
        [_tableView removeFromSuperview];
        [_maskView removeFromSuperview];
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.goodsDict count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return DetailHeaderHeight;
    }
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DetailCellHeight;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self);
    __FormatGoodsNode *n = self.goodsDict.allValues[indexPath.section];
    CartDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CartDetailCellReuseIDKey];
    cell.removeGoodsHandler = ^(CompanyGoodModel *model){
        @strongify(self);
        [self fetchServerRemoveGoodsFromCart:model complete:^{
            [n replaceModel:model atIndex:indexPath.row];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self removeGoodFromCart:model atIndex:indexPath];
        }];
    };
    cell.onAddedGoodsToCartHandler = ^(CompanyGoodModel *model, NSUInteger count) {
        @strongify(self);
        [self fetchServerAddGoodsToCart:model complete:^{
            [n replaceModel:model atIndex:indexPath.row];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [self newlyAddedGoods:model toCart:count atIndex:indexPath];
        }];
    };
    
    cell.model = [n modelAtIndex:indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        CartDetailHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CartDetailHeaderReuseIDKey];
        @weakify(self);
        header.onClearHandler = ^{
            @strongify(self);
            [self clearAllGoods];
        };
        return header;
    }
    return nil;
}

#pragma mark - Network
- (void)fetchServerRemoveGoodsFromCart:(CompanyGoodModel *)model complete:(void(^)(void))complete {
    if (!model) { return; };
    NSDictionary *params = @{@"comId":self.companyId, @"token":[UserHelper userToken], @"goodId":model.gid, @"natrue":@0};
    [DZRequests post:@"DeleteFromCart" parameters:params success:^(id record) {
        
        if (complete) { complete(); }
    } failure:^(HPRequestsError type, NSError *error) {
        occasionalHint(error.localizedDescription);
    }];
}


- (void)fetchServerAddGoodsToCart:(CompanyGoodModel *)model complete:(void(^)(void))complete {
    if (!model) { return; };
    NSDictionary *params = @{@"comId":self.companyId, @"token":[UserHelper userToken], @"goodId":model.gid, @"natrue":@0};
    [DZRequests post:@"AddToCart" parameters:params success:^(id record) {
        if (complete) { complete(); }
    } failure:^(HPRequestsError type, NSError *error) {
        occasionalHint(error.localizedDescription);
    }];
}

#pragma mark - Getter & Setter
-(void)setMinPrice:(NSString *)minPrice{
    _minPrice = minPrice;
    _pricePlacehold = [NSString stringWithFormat:@"%@元起送",minPrice];
    self.commitPriceBtn.titleOfDisabled = _pricePlacehold;
}

- (UILabel *)logisticsLabel {
    if (!_logisticsLabel) {
        _logisticsLabel = [UILabel new];
        _logisticsLabel.textColor = [UIColor whiteColor];
        _logisticsLabel.font = [UIFont systemFontOfSize:13];
        _logisticsLabel.hidden = YES;
    }
    return _logisticsLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.textColor = [UIColor whiteColor];
        _priceLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _priceLabel.hidden = YES;
    }
    return _priceLabel;
}

- (UILabel *)bageLabel {
    if (!_bageLabel) {
        _bageLabel = [UILabel new];
        _bageLabel.textColor = [UIColor whiteColor];
        _bageLabel.textAlignment = NSTextAlignmentCenter;
        _bageLabel.font = [UIFont systemFontOfSize:11];
        _bageLabel.layer.cornerRadius = 10;
        _bageLabel.clipsToBounds = YES;
        _bageLabel.backgroundColor = NAV_FGC;
        _bageLabel.hidden = YES;
    }
    return _bageLabel;
}

- (UILabel *)noticeLabel {
    if (!_noticeLabel) {
        _noticeLabel = [UILabel new];
        _noticeLabel.textColor = [UIColor lightGrayColor];
        _noticeLabel.font = [UIFont systemFontOfSize:15];
        _noticeLabel.text = @"未选购商品";
    }
    return _noticeLabel;
}

- (UIButton *)cartStatusBtn {
    if (!_cartStatusBtn) {
        _cartStatusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cartStatusBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        _cartStatusBtn.layer.cornerRadius = 25.0f;
        _cartStatusBtn.clipsToBounds = YES;
        _cartStatusBtn.backgroundColor = [UIColor grayColor];
        _cartStatusBtn.imageOfDisabled = [UIImage
                                        imageNamed:@"shop_car_empty"];
        _cartStatusBtn.imageOfNormal = [UIImage imageNamed:@"shop_car"];
        _cartStatusBtn.enabled = NO;
        [_cartStatusBtn addTarget:self action:@selector(showAllGoodsInCartDetails) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cartStatusBtn;
}

- (UIButton *)commitPriceBtn {
    if (!_commitPriceBtn) {
        _commitPriceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitPriceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        _commitPriceBtn.titleColorOfDisabled = [UIColor lightGrayColor];
        _commitPriceBtn.titleColorOfNormal = [UIColor whiteColor];
        _commitPriceBtn.backgroudColorOfDisabled = [UIColor grayColor];
        _commitPriceBtn.backgroudColorOfNormal = NAV_FGC;
        _commitPriceBtn.titleOfDisabled = _pricePlacehold;
        [_commitPriceBtn addTarget:self action:@selector(onClickcommitPriceBtn:) forControlEvents:UIControlEventTouchUpInside];
        _commitPriceBtn.enabled = NO;
    }
    return _commitPriceBtn;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [UIView new];
        _maskView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGestureRecognizer:)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:CartDetailCell.class forCellReuseIdentifier:CartDetailCellReuseIDKey];
        [_tableView registerClass:CartDetailHeaderView.class forHeaderFooterViewReuseIdentifier:CartDetailHeaderReuseIDKey];
    }
    return _tableView;
}

@end
