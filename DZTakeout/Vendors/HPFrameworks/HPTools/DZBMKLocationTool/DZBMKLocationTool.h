//
//  DZBMKLocationTool.h
//  DZTakeout
//
//  Created by 林鸿键 on 2018/7/4.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BMKLocationkit/BMKLocationComponent.h>
@interface DZBMKLocationTool : NSObject
@property (nonatomic, strong) BMKLocation *curLocation;
@property (nonatomic, strong) NSString *coordinateStr;

+(DZBMKLocationTool *)sharedInstance;

/**
 *  @brief 单次定位。如果当前正在连续定位，调用此方法将会失败，返回NO。\n该方法将会根据设定的 desiredAccuracy 去获取定位信息。如果获取的定位信息精确度低于 desiredAccuracy ，将会持续的等待定位信息，直到超时后通过completionBlock返回精度最高的定位信息。\n可以通过 stopUpdatingLocation 方法去取消正在进行的单次定位请求。
 *  @param withReGeocode 是否带有逆地理信息(获取逆地理信息需要联网)
 *  @param withNetWorkState 是否带有移动热点识别状态(需要联网)
 *  @param completionBlock 单次定位完成后的Block

 */
- (void)requestLocationWithReGeocode:(BOOL)withReGeocode withNetworkState:(BOOL)withNetWorkState completionBlock:(BMKLocatingCompletionBlock _Nonnull)completionBlock;
@end
