//
//  DZJSActionModel.h
//  DZTakeout
//
//  Created by 林鸿键 on 2018/9/3.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DZJSActionRouterDelegate<NSObject>
@optional

- (void)base:(JSValue *)destn;

- (void)valLink:(JSValue *)destn final:(JSValue *)param;

- (void)moreLink:(JSValue *)destn first:(JSValue *)firstArg second:(JSValue *)secondArg;

- (void)orderCheck:(JSValue *)destn first:(JSValue *)firstArg second:(JSValue *)secondArg third:(JSValue *)thirdArg;

- (void)moreValCheck:(JSValue *)destn first:(JSValue *)firstArg second:(JSValue *)secondArg third:(JSValue *)thirdArg four:(JSValue *)fourArg;
@end

@interface DZJSActionRouter : NSObject
@property (nonatomic,weak) id<DZJSActionRouterDelegate> delegate;
@end
