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

@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *auditor;
@property (nonatomic, copy) NSString *card_back;
@property (nonatomic, copy) NSString *card_front;
@property (nonatomic, copy) NSString *career;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *hobby;
@property (nonatomic, copy) NSString *is_distribution;
@property (nonatomic, copy) NSString *is_newuser;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *random_code;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *update_time;
@end
