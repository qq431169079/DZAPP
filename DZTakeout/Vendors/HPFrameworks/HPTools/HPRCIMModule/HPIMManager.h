//
//  HPIMManager.h
//  DZTakeout
//
//  Created by HuangPan on 2018/6/25.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>

@interface HPIMManager : NSObject

+ (void)initWithAppKey:(NSString *)key;

+ (void)connectWithToken:(NSString *)token
                 success:(void (^)(NSString *userId))successBlock
                   error:(void (^)(RCConnectErrorCode status))errorBlock
          tokenIncorrect:(void (^)(void))tokenIncorrectBlock;

@end
