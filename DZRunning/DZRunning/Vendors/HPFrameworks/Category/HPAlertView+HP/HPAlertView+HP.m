//
//  HPAlertView+HP.m
//  MyPractice
//
//  Created by huangpan on 16/8/31.
//  Copyright © 2016年 Leon. All rights reserved.
//

#import "HPAlertView+HP.h"
#import "TKAlertCenter.h"

UIKIT_EXTERN void _HPAlert(NSString *msg, NSInteger expectedIndex, HPAlertActionBlock action, NSString *btn1,NSString *btn2, ...) {
    NSMutableArray *btns = [NSMutableArray array];
    va_list arguments;
    id eachObject;
    if ( btn1 && btn2 ) {
        NSInteger index = 0;
        [btns addObject:btn2];
        va_start(arguments, btn2);
        while ( (eachObject = va_arg(arguments, id)) ) {
            index++;
            [btns addObject:eachObject];
        }
        va_end(arguments);
    }
    _hy_dispatch_main_async_safe(^{
        [HPAlertView showAlertViewWithTitle:nil mess:msg expectedIndex:expectedIndex buttonsTitle:btns actionBlock:action];
    });
}

UIKIT_EXTERN void _HPAlertTitle(NSString *title, NSString *msg, NSInteger expectedIndex, HPAlertActionBlock action, NSString *btn1, NSString *btn2, ...) {
    NSMutableArray *btns = [NSMutableArray array];
    va_list arguments;
    id eachObject;
    if ( btn1 && btn2 ) {
        NSInteger index = 0;
        [btns addObject:btn2];
        va_start(arguments, btn2);
        while ( (eachObject = va_arg(arguments, id)) ) {
            index ++;
            [btns addObject:eachObject];
        }
        va_end(arguments);
    }
    _hy_dispatch_main_async_safe(^{
        [HPAlertView showAlertViewWithTitle:title mess:msg expectedIndex:expectedIndex buttonsTitle:btns actionBlock:action];
    });
}

UIKIT_EXTERN void occasionalHint(NSString *message) {
    static dispatch_semaphore_t semaphore = nil;
    if (!semaphore) {
        semaphore = dispatch_semaphore_create(1);
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSString *msg = message;
        if ( [message containsString:@"The Operation"] ) {
            msg = @"无法连接网络，网络连接已经断开！";
        }
        _hy_dispatch_main_async_safe(^{
            [[TKAlertCenter defaultCenter] postAlertWithMessage:message];
        });
        // 一个展示时间(1s)过后再恢复信号量
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_semaphore_signal(semaphore);
        });
    });
}

@implementation HPAlertView (HP)

@end
