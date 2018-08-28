//
//  PleaseOrderViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/19.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "PleaseOrderViewController.h"
#import "SellerBusinessRelatedTableViewCell.h"
#import "DZShoppingCartView.h"
#import "HPAnimationTools.h"
#import "ClassifyModel.h"
#import "CompanyAllGoodsModel.h"
#import "DZMenuScrollView.h"
#import "__FormatGoodsNode.h"
#import "DZGoodsProfileView.h"
#import <UIImageView+WebCache.h>
#import "CommitOrderViewController.h"
#import "NSString+HPUtil.h"

static NSString *const CellReuseIdentityOfFoodsKey = @"CellReuseIdentityOfFoodsKey";
static NSString *const HeaderReuseIdentityOfFoodsKey = @"HeaderReuseIdentityOfFoodsKey";

@interface PleaseOrderViewController ()<UITableViewDelegate, UITableViewDataSource, DZMenuScrollViewDelegate> {
    
    //当点击的时候 不去调用滑动调节
    BOOL _needsAdjustMenu;
}
@property (nonatomic, strong) DZMenuScrollView *menuView;
@property (nonatomic, strong) UITableView *foodsTableView;

@property (nonatomic, copy) NSArray<ClassifyModel *> *classifyList;

/// key=classifyId / value=NSArray<CompanyGoodModel *> *
@property (nonatomic, strong) NSMutableDictionary<NSString *, __FormatGoodsNode *> *formatDataDict;
@end

@implementation PleaseOrderViewController
#pragma mark - Init
- (void)setupSubviews {
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.foodsTableView];
    @weakify(self);
    [self.foodsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.menuView.mas_right);
        make.top.right.equalTo(self.view);
        make.bottom.equalTo(self.menuView);
    }];
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-50);
        make.width.mas_equalTo(80);
    }];
}

- (void)dealloc {
    NSLog(@"PleaseOrderViewController ---- ");
    DZShoppingCartView *shoppingCart = [DZShoppingCartView shoppingCart];
    [shoppingCart clear];
    [shoppingCart removeCurOrd:self.companyId];
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.formatDataDict = [NSMutableDictionary dictionary];
    [self fetchClassifyAndFoodsFromServer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showShoppingCart];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self removeShoppingCart];
}

- (void)showShoppingCart {
    DZShoppingCartView *shoppingCart = [DZShoppingCartView shoppingCart];
    shoppingCart.companyId = self.companyId;
    @weakify(self);
    shoppingCart.onPrepareCommitHandler = ^{
        @strongify(self);
        [self fetchServerCreateOrderComplete:nil];
    };
    shoppingCart.onChangedBadgeHanlder = ^(NSInteger count, CompanyGoodModel *model) {
        @strongify(self);
        ClassifyModel *m = self.classifyList[model.indexPath.section];
        __FormatGoodsNode *n = self.formatDataDict[m.classifyId];
        [n replaceModel:model atIndex:model.indexPath.row];
        [self.foodsTableView reloadRowsAtIndexPaths:@[model.indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.menuView changedBadge:count atIndex:model.indexPath.section];
    };
    shoppingCart.clearAllGoodsHandler = ^{
      //清空购物车
        @strongify(self);
        [self.menuView clearAllBage];
        [self clearGoodForServer];
    };
    [shoppingCart show];

    //如果有商品要重新添加
    NSDictionary *curGoodsDict = [shoppingCart getAllGoodsByCompanyId:self.companyId];
    if ([curGoodsDict allKeys].count >0) {


        for (NSString *key in [curGoodsDict allKeys]) {
            NSInteger goodsNum = [curGoodsDict[key] integerValue];
            for (NSInteger i = goodsNum; i>0; i--) {
                NSLog(@"goodsNum__%@",key);
                [self addGoodWithID:key time:0];
            }
        }
    }
}

- (void)removeShoppingCart {
    DZShoppingCartView *shoppingCart = [DZShoppingCartView shoppingCart];
    [shoppingCart remove];
}

#pragma mark - Network
-(void)addGoodWithID:(NSString *)goodID time:(NSInteger)time{
    __block NSInteger curTime = time;
    __block NSError *requestsError = nil;
    if (time<3) {
        DZWeakSelf(self)
        NSLog(@"准备发送请求%@",goodID);
        NSDictionary *params = @{@"comId":self.companyId, @"token":[UserHelper userToken], @"goodId":goodID, @"natrue":@0};
        [DZRequests post:@"AddToCart" parameters:params success:^(id record) {
            NSLog(@"重新增加了商品%@,",goodID);
        } failure:^(HPRequestsError type, NSError *error) {
            occasionalHint(error.localizedDescription);
            requestsError = error;
            curTime++;
            NSLog(@"添加商品%@失败__重新尝试__%ld",goodID,(long)curTime);
            [weakSelf addGoodWithID:goodID time:curTime];
        }];
    }
}

- (void)fetchClassifyAndFoodsFromServer {
    if (self.companyId.length == 0) {return;}
    __block NSError *requestsError = nil;
    __block CompanyAllGoodsModel *allGoods = nil;
    __block NSArray<ClassifyModel *> *allClassify = nil;
    NSDictionary *params = @{@"id":self.companyId};
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [DZRequests post:@"CompanyAllGoods" parameters:params success:^(id record) {
        allGoods = [CompanyAllGoodsModel modelWithJSON:record];
        dispatch_group_leave(group);
    } failure:^(HPRequestsError type, NSError *error) {
        requestsError = error;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [DZRequests post:@"CompanyAllGoodClassify" parameters:params success:^(id record) {
        allClassify = [ClassifyModel modelsWithArray:record[@"list"]];
        dispatch_group_leave(group);
    } failure:^(HPRequestsError type, NSError *error) {
        requestsError = error;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (requestsError) {
            NSString *errorMsg = requestsError.localizedDescription;
            occasionalHint(errorMsg);
        } else {
            self.classifyList = allClassify;
            [self.formatDataDict removeAllObjects];
            [self.classifyList enumerateObjectsUsingBlock:^(ClassifyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.classifyId.length > 0) {
                    __FormatGoodsNode *n = [__FormatGoodsNode new];
                    [self.formatDataDict setObject:n forKey:obj.classifyId];
                }
            }];
            [allGoods.list enumerateObjectsUsingBlock:^(CompanyGoodModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.ificationId.length > 0) {
                    __FormatGoodsNode *n = self.formatDataDict[obj.ificationId];
                    [n append:obj];
                }
            }];
            self.menuView.menuModels = self.classifyList;
            [self.foodsTableView reloadData];
        }
    });
}

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

- (void)fetchServerCreateOrderComplete:(void(^)(void))complete {
    NSDictionary *params = @{@"cid":self.companyId, @"token":[UserHelper userToken]};
    [DZRequests post:@"CreateOrder" parameters:params success:^(id record) {
        if ([record isKindOfClass:NSDictionary.class]) {
            NSString *orderId = [NSString stringWithFormat:@"%ld", [record[@"orderId"] longValue]];
            [self gotoConfirmWithOrderId:orderId orderNo:record[@"orderNo"]];
            if (complete) { complete(); }
        } else {
            occasionalHint(@"数据异常，请重试");
        }
    } failure:^(HPRequestsError type, NSError *error) {
        occasionalHint(error.localizedDescription);
    }];
}
-(void)clearGoodForServer{
    NSDictionary *params = @{@"cid":self.companyId, @"token":[UserHelper userToken]};
    [DZRequests post:@"clearShop" parameters:params success:^(id record) {
        if ([record isKindOfClass:NSDictionary.class]) {
            if ([[record allKeys]containsObject:@"message"]) {
                occasionalHint(record[@"message"]);
            }
        } else {
            occasionalHint(@"数据异常，请重试");
        }
    } failure:^(HPRequestsError type, NSError *error) {
        occasionalHint(error.localizedDescription);
    }];
}
- (void)gotoConfirmWithOrderId:(NSString *)orderId orderNo:(NSString *)orderNo {
    if (orderId.length > 0 && orderNo.length > 0) {
        CommitOrderViewController *vc = [CommitOrderViewController controller];
        vc.orderNo = orderNo;
        vc.orderId = orderId;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        occasionalHint(@"数据异常，请重试");
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.classifyList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ClassifyModel *m = self.classifyList[section];
    __FormatGoodsNode *n = self.formatDataDict[m.classifyId];
    return [n count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) wself = self;
    ClassifyModel *m = self.classifyList[indexPath.section];
    __FormatGoodsNode *n = self.formatDataDict[m.classifyId];
    PartInfo_FoodsSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentityOfFoodsKey];
    cell.removeGoodsHandler = ^(CompanyGoodModel *model){
        [wself fetchServerRemoveGoodsFromCart:model complete:^{
            model.indexPath = indexPath;
            [n replaceModel:model atIndex:indexPath.row];
            [wself.foodsTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [wself removeGoodFromCart:model atIndex:indexPath];
        }];
    };
    cell.onAddedGoodsToCartHandler = ^(CGPoint startPoint, CompanyGoodModel *model, NSUInteger count) {
        [wself fetchServerAddGoodsToCart:model complete:^{
            model.indexPath = indexPath;
            [n replaceModel:model atIndex:indexPath.row];
            [wself.foodsTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [wself startNewlyAddedAnimations:model from:startPoint complete:^{
                [wself newlyAddedGoods:model toCart:count atIndex:indexPath];
            }];
        }];
    };
    
    cell.model = [n modelAtIndex:indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PartInfo_FoodsHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderReuseIdentityOfFoodsKey];
    ClassifyModel *m = self.classifyList[section];
    header.name = m.name;
    if (_needsAdjustMenu) {
        [self.menuView setSelectedMenuAtIndex:section];
    }
    return header;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassifyModel *m = self.classifyList[indexPath.section];
    __FormatGoodsNode *n = self.formatDataDict[m.classifyId];
    CompanyGoodModel *model = [n modelAtIndex:indexPath.row];
    DZGoodsProfileView *profile = [[DZGoodsProfileView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    DZWeakSelf(self)
    profile.removeGoodsHandler = ^(CompanyGoodModel *model){
        DZStrongSelf(weakSelf)
        [strongSelf fetchServerRemoveGoodsFromCart:model complete:^{
            model.indexPath = indexPath;
            [n replaceModel:model atIndex:indexPath.row];
            [self.foodsTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self removeGoodFromCart:model atIndex:indexPath];
        }];
    };
    profile.onAddedGoodsToCartHandler = ^(CGPoint startPoint, CompanyGoodModel *model, NSUInteger count) {
        DZStrongSelf(weakSelf)
        [strongSelf fetchServerAddGoodsToCart:model complete:^{
            model.indexPath = indexPath;
            [n replaceModel:model atIndex:indexPath.row];
            [strongSelf.foodsTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [strongSelf startNewlyAddedAnimations:model from:startPoint complete:^{
                [weakSelf newlyAddedGoods:model toCart:count atIndex:indexPath];
            }];
        }];
    };
    profile.model = model;
    [profile show];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
}

#pragma mark - DZMenuScrollViewDelegate
- (CGFloat)menu:(DZMenuScrollView *)menu heightForIndex:(NSInteger)index {
    return 60;
}

- (void)menu:(DZMenuScrollView *)menu onSelectIndex:(NSInteger)index {
    _needsAdjustMenu = NO;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    [self.foodsTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - UIScrollDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _needsAdjustMenu = YES;
}

#pragma mark - Events Reponse
- (void)startNewlyAddedAnimations:(CompanyGoodModel *)model from:(CGPoint )startPoint complete:(void(^)(void))complete {
    NSString *count = [NSString stringWithFormat:@"%zd", model.hasSelectedCount];
    CGFloat width = [count sizeWithMaxWidth:CGFLOAT_MAX font:[UIFont systemFontOfSize:12.0f]].width;
    width = MAX(20.0f, width);
    CGRect frame = CGRectMake(0, 0, width, 20.0f);
    frame.origin.x = startPoint.x - 10;
    frame.origin.y = startPoint.y - 10;
    frame.origin.y = startPoint.y;
    UILabel *ani = [[UILabel alloc] initWithFrame:frame];
    ani.textColor = [UIColor whiteColor];
    ani.font = [UIFont systemFontOfSize:12.0f];
    ani.backgroundColor = COLOR_HEX(0x186FED);
    ani.textAlignment = NSTextAlignmentCenter;
    ani.text = count;
    ani.clipsToBounds = YES;
    ani.layer.cornerRadius = 10;
    [[UIApplication sharedApplication].keyWindow addSubview:ani];
    CGPoint endPoint = CGPointMake(40, SCREEN_HEIGHT - 65);
    [HPAnimationTools startTarget:ani animation:HPAnimationStyleScale | HPAnimationStyleQuadCurve startPoint:startPoint endPoint:endPoint complete:^{
        [ani removeFromSuperview];
        if (complete) { complete ();}
    }];
}

- (void)removeGoodFromCart:(CompanyGoodModel *)model atIndex:(NSIndexPath *)indexPath {
    [[DZShoppingCartView shoppingCart] removeGoods:model];
    // 修改左边菜单栏
    [self.menuView changedBadge:-1 atIndex:indexPath.section];
}

- (void)newlyAddedGoods:(CompanyGoodModel *)goods toCart:(NSInteger)number atIndex:(NSIndexPath *)indexPath {
    NSInteger count = [[DZShoppingCartView shoppingCart] numberOfGooods:goods];
    // 加入购物车
    [[DZShoppingCartView shoppingCart] newlyAddedGoods:goods toCart:number];
    // 修改左边菜单栏
    NSInteger c = (number - count);
    [self.menuView changedBadge:c atIndex:indexPath.section];
}

#pragma mark - Getter & Setter
- (void)setLogisticsPrice:(CGFloat)logisticsPrice {
    _logisticsPrice = logisticsPrice;
    [DZShoppingCartView shoppingCart].logisticsPrice = _logisticsPrice;
}
-(void)setMinPrice:(NSString *)minPrice{
    _minPrice = minPrice;
    [DZShoppingCartView shoppingCart].minPrice = minPrice;
}
-(void)setIsBusiness:(BOOL)isBusiness{
    _isBusiness = isBusiness;
    [DZShoppingCartView shoppingCart].isBusiness = isBusiness;
}
- (UITableView *)foodsTableView {
    if (!_foodsTableView) {
        _foodsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _foodsTableView.backgroundColor = [UIColor whiteColor];
        _foodsTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _foodsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _foodsTableView.showsVerticalScrollIndicator = NO;
        _foodsTableView.delegate = self;
        _foodsTableView.dataSource = self;
        [_foodsTableView registerClass:PartInfo_FoodsSummaryCell.class forCellReuseIdentifier:CellReuseIdentityOfFoodsKey];
        [_foodsTableView registerClass:PartInfo_FoodsHeaderView.class forHeaderFooterViewReuseIdentifier:HeaderReuseIdentityOfFoodsKey];
    }
    return _foodsTableView;
}

- (DZMenuScrollView *)menuView {
    if (!_menuView) {
        _menuView = [DZMenuScrollView new];
        _menuView.menuDelegate = self;
    }
    return _menuView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
