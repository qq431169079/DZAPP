//
//  DZJrmfWalletSDK.m
//  SealTalk
//
//  Created by 林鸿键 on 2018/7/9.
//  Copyright © 2018年 RongCloud. All rights reserved.
//

#import "DZJrmfWalletSDK.h"

@implementation DZJrmfWalletSDK
+(instancetype)shareInstace{
    static DZJrmfWalletSDK * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DZJrmfWalletSDK alloc] init];
    });
    return instance;
}
@end
