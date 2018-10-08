//
//  UserModel.m
//  DiceGame
//
//  Created by HuangPan on 2017/10/9.
//  Copyright © 2017年 HuangPan. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"userID":@"id"};
}
@end
