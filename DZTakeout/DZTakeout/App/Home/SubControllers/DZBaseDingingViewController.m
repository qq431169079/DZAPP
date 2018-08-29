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
#import "DZSeatReserveView.h"
@interface DZBaseDingingViewController ()<DZSeatReserveViewDelegate>
@property (nonatomic,weak) DZSeatSelectionView *selectionView;
@property (nonatomic,strong) NSString *tableNO;
@property (nonatomic,strong) NSString *tableID;
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

- (void)moreValCheck:(JSValue *)destn first:(JSValue *)firstArg second:(JSValue *)secondArg third:(JSValue *)thirdArg four:(JSValue *)fourArg{
    if ([destn isString] && [[destn toString] isEqualToString:@"select"]) {
        NSString *state = [thirdArg toString];
        self.tableNO = [firstArg toString];
        NSString *name = @"大厅";
        if ([[secondArg toString]isEqualToString:@"dt"]){
            name = @"大厅";
        }else{
            name = @"包厢";
        }
        self.tableName = name;
        self.tableID = [fourArg toString];
        switch ([state integerValue]) {
            case 0:
                {
                    //获取预定信息
                    [self requestSeatInfo];
                }
                break;
            default:
            {
//弹提示框
                [self requestSeatNotiInfo];
            }
                break;
        }
      
        
    }
}

#pragma mark - Network
- (void)requestSeatInfo{
    DZWeakSelf(self)
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.tableID,@"id",
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

-(void)requestSeatNotiInfo{
    
    DZWeakSelf(self)
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.tableID,@"reservesId",
                            nil];
    [DZRequests post:@"BookTime" parameters:params success:^(id record) {
        if ([record isKindOfClass:[NSDictionary class]]) {
            NSDictionary *recordDict = (NSDictionary *)record;
            if ([[recordDict allKeys]containsObject:@"totalCount"]) {
                NSInteger totalCount = [recordDict[@"totalCount"] integerValue];
                if (totalCount >0) {
                    [weakSelf showSeatReserveInfo:recordDict];
                }else{
                    [weakSelf requestSeatInfo];
                }
            }
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
#pragma mark 代理
-(void)continueReserve{
    [self requestSeatInfo];
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

//预定信息
-(void)showSeatReserveInfo:(NSDictionary *)recordDict{
    DZSeatReserveView *seatReserveView = [[NSBundle mainBundle] loadNibNamed:@"DZSeatReserveView" owner:nil options:nil].firstObject;
    seatReserveView.frame = self.view.bounds;
    seatReserveView.delegate = self;
    [seatReserveView setupSeatReserveInfo:recordDict];
    [self.view addSubview:seatReserveView];
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
        selectionView.frame = self.view.bounds;
        [self.view addSubview:selectionView];
        _selectionView = selectionView;
    }
    return _selectionView;
}
@end
