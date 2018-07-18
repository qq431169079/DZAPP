//
//  DZBMKLocationTool.m
//  DZTakeout
//
//  Created by 林鸿键 on 2018/7/4.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZBMKLocationTool.h"
@interface DZBMKLocationTool()<BMKLocationManagerDelegate,BMKLocationAuthDelegate>
@property (nonatomic, strong) BMKLocationManager *locationManager;
@property (nonatomic, assign) BOOL setupSuccess;
@property (nonatomic, copy) void(^checkPermisionBlock)(void);
@end

@implementation DZBMKLocationTool

+(DZBMKLocationTool *)sharedInstance
{
    static DZBMKLocationTool * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DZBMKLocationTool alloc] init];
        [instance setupLocationManager];
    });
    return instance;
}
#pragma mark - BMKLocationAuthDelegate
/**
 *@brief 返回授权验证错误
 *@param iError 错误号 : 为0时验证通过，具体参加BMKLocationAuthErrorCode
 */
- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError{
    NSLog(@"onCheckPermissionState%ld",(long)iError);
    if (iError == BMKLocationAuthErrorSuccess) {
        self.setupSuccess = YES;
        if (self.checkPermisionBlock) {
            self.checkPermisionBlock();
        }
    }
}
#pragma mark - BMKLocationManagerDelegate
/**
 *  @brief 当定位发生错误时，会调用代理的此方法。
 *  @param manager 定位 BMKLocationManager 类。
 *  @param error 返回的错误，参考 CLError 。
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nullable)error{
    NSLog(@"定位失败%@",error);
}
-(void)checkPermision{
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:kDZBMKAK authDelegate:self];
}
-(void)setupLocationManager{

    //初始化实例
    _locationManager = [[BMKLocationManager alloc] init];
    //设置delegate
    _locationManager.delegate = self;
    //设置返回位置的坐标系类型
    _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    //设置距离过滤参数
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    //设置预期精度参数
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置应用位置类型
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    //设置是否自动停止位置更新
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    //设置是否允许后台定位
    _locationManager.allowsBackgroundLocationUpdates = YES;
    //设置位置获取超时时间
    _locationManager.locationTimeout = 10;
    //设置获取地址信息超时时间
    _locationManager.reGeocodeTimeout = 10;
}
-(void)requestLocationWithReGeocode:(BOOL)withReGeocode withNetworkState:(BOOL)withNetWorkState completionBlock:(BMKLocatingCompletionBlock)completionBlock{
    @weakify(self);
    if (self.setupSuccess) {
         [self.locationManager requestLocationWithReGeocode:withReGeocode withNetworkState:withNetWorkState completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
            __weak_self__.curLocation = location;
            if (completionBlock) {
                completionBlock(location,state,error);
            }
        }];
    }else{
        self.checkPermisionBlock = ^{
            [__weak_self__.locationManager requestLocationWithReGeocode:withReGeocode withNetworkState:withNetWorkState completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
                __weak_self__.curLocation = location;
                __weak_self__.coordinateStr = [NSString stringWithFormat:@"%f,%f",location.location.coordinate.latitude,location.location.coordinate.longitude];
                if (completionBlock) {
                    completionBlock(location,state,error);
                }
            }];
        };
        [self checkPermision];
    }

}

@end
