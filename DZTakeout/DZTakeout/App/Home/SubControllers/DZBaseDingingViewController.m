//
//  DZBaseDingingViewController.m
//  DZTakeout
//
//  Created by 林鸿键 on 2018/7/8.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZBaseDingingViewController.h"
#import "DZSeatSelectionView.h"
#import "FoodsOrderViewController.h"
@interface DZBaseDingingViewController ()
@property (nonatomic,weak) DZSeatSelectionView *selectionView;
@property (nonatomic,strong) NSString *tableNO;
@property (nonatomic,strong) NSString *tableName;
@end

@implementation DZBaseDingingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)launch:(NSString *)destn withParams:(NSArray<NSString *> *)params {
    if ([destn isEqualToString:@"select"]) {
        self.tableNO = [params firstObject];
        self.tableName = [params lastObject];
        //获取预定信息
        [self requestSeatInfo];
        
    }else{
        UIViewController *controler = [DZJSInteractiveRouter instanceFromDestn:destn params:params];
        [DZJSInteractiveRouter nav:self.navigationController needsPush:controler animated:YES];
    }
    
}

#pragma mark - Network
- (void)requestSeatInfo{
    DZWeakSelf(self)
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.tableNO,@"tableNo",
                            self.companyId,@"cid",
                            nil];
    [DZRequests post:@"seatInfo" parameters:params success:^(id record) {
        if ([record isKindOfClass:[NSDictionary class]]) {
            NSDictionary *recordDict = (NSDictionary *)record;
            [weakSelf showSeatSelectionViewWithInfo:recordDict];
        }
        
    } failure:^(HPRequestsError type, NSError *error) {
        occasionalHint(error.localizedDescription);
    }];
}
- (void)requestFoodsOrderInfoEndTime:(NSString *)endTime mealNum:(NSString *)mealNum phoneNum:(NSString *)phoneNum{
    DZWeakSelf(self)
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.tableNO,@"tableNo",
                            self.companyId,@"cid",
                            [UserHelper userToken],@"token",
                            self.tableName,@"Remarks",
                            endTime,@"endTime",
                            self.tableName,@"seat",
                            mealNum,@"meals",
                            phoneNum,@"phone",
                            nil];
    [DZRequests post:@"foodsOrderInfo" parameters:params success:^(id record) {
        if ([record isKindOfClass:[NSDictionary class]]) {
            NSDictionary *recordDict = (NSDictionary *)record;
            [weakSelf gotoFoodsOrderViewController:recordDict];
        }
        
    } failure:^(HPRequestsError type, NSError *error) {
        occasionalHint(error.localizedDescription);
    }];
}

- (void)requestPaySecurityInfoEndTime:(NSString *)endTime mealNum:(NSString *)mealNum phoneNum:(NSString *)phoneNum{
    DZWeakSelf(self)
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.tableNO,@"tableNo",
                            self.companyId,@"cid",
                            [UserHelper userToken],@"token",
                            self.tableName,@"Remarks",
                            endTime,@"endTime",
                            self.tableName,@"seat",
                            mealNum,@"meals",
                            phoneNum,@"phone",
                            nil];
    [DZRequests post:@"foodsOrderInfo" parameters:params success:^(id record) {
        if ([record isKindOfClass:[NSDictionary class]]) {
            NSDictionary *recordDict = (NSDictionary *)record;
            [weakSelf paySecurity:recordDict];
        }
        
    } failure:^(HPRequestsError type, NSError *error) {
        occasionalHint(error.localizedDescription);
    }];
}

#pragma mark - 其他
//进点菜界面
-(void)gotoFoodsOrderViewController:(NSDictionary *)orderInfo{
    self.selectionView.hidden = YES;
    FoodsOrderViewController *foodsOrderVC = [FoodsOrderViewController controller];
        foodsOrderVC.companyId = self.companyId;
    NSArray *allKeys = [orderInfo allKeys];
    if ([allKeys containsObject:@"orderNo"]) {
        NSString *orderNo = orderInfo[@"orderNo"];
        [UserHelper temporaryCacheObject:orderNo forKey:kOrderNoCacheKey];
        foodsOrderVC.orderNo = orderInfo[@"orderNo"];
    }
    if ([allKeys containsObject:@"orderId"]) {
        NSNumber *orderId = orderInfo[@"orderId"];
        [UserHelper temporaryCacheObject:[NSString stringWithFormat:@"%@",orderId] forKey:kOrderIdCacheKey];
        foodsOrderVC.orderId = [NSString stringWithFormat:@"%@",orderId];
    }
    [self.navigationController pushViewController:foodsOrderVC animated:YES];
}
//支付押金
-(void)paySecurity:(NSDictionary *)payInfo{
    self.selectionView.hidden = YES;
    if ([[payInfo allKeys]containsObject:@"orderId"]) {
        NSNumber *orderId = payInfo[@"orderId"];
        [UserHelper temporaryCacheObject:[NSString stringWithFormat:@"%@",orderId] forKey:kOrderIdCacheKey];
        UIViewController *payVC = [DZJSInteractiveRouter instanceFromDestn:@"mspay"];
        [self.navigationController pushViewController:payVC animated:YES];
    }

}
//显示座位信息
-(void)showSeatSelectionViewWithInfo:(NSDictionary *)infoDict{
    self.selectionView.hidden = NO;
    [self.selectionView reloadUIWithSeatInfo:infoDict];
}
//返回
-(void)onReturnBackComplete:(void (^)(void))complete{
    if (_selectionView) {
        [_selectionView removeFromSuperview];
    }
    [super onReturnBackComplete:complete];
}
#pragma mark - lazy
-(DZSeatSelectionView *)selectionView{
    if (_selectionView == nil) {
        DZSeatSelectionView *selectionView =  [[NSBundle mainBundle] loadNibNamed:@"DZSeatSelectionView" owner:nil options:nil].firstObject;
        DZWeakSelf(self)
        selectionView.orderDishesBlock = ^(NSString *endTime, NSString *mealNum, NSString *phoneNum) {
            [weakSelf requestFoodsOrderInfoEndTime:endTime mealNum:mealNum phoneNum:phoneNum];
        };
        selectionView.paySecurityBlock = ^(NSString *endTime, NSString *mealNum, NSString *phoneNum) {
            [weakSelf requestPaySecurityInfoEndTime:endTime mealNum:mealNum phoneNum:phoneNum];
        };
        selectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [[UIApplication sharedApplication].keyWindow addSubview:selectionView];
        _selectionView = selectionView;
    }
    return _selectionView;
}
@end
