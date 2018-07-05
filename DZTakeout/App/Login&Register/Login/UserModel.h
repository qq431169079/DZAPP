//
//  UserModel.h
//  DiceGame
//
//  Created by HuangPan on 2017/10/9.
//  Copyright © 2017年 HuangPan. All rights reserved.
//

#import "HPModel.h"

@interface UserModel : HPModel

@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *img_url;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *userID;
@end
