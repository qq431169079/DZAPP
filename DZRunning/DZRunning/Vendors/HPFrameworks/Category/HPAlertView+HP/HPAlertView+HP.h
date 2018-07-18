//
//  HPAlertView+HP.h
//  MyPractice
//
//  Created by huangpan on 16/8/31.
//  Copyright © 2016年 Leon. All rights reserved.
//

#import "HPAlertView.h"

typedef void(^HPAlertActionBlock) (NSUInteger index);

UIKIT_EXTERN void _HPAlert(NSString *msg, NSInteger expectedIndex, HPAlertActionBlock action, NSString *btn1,NSString *btn2, ...);

UIKIT_EXTERN void _HPAlertTitle(NSString *title, NSString *msg, NSInteger expectedIndex, HPAlertActionBlock action, NSString *btn1, NSString *btn2, ...);

#define HPAlert(msg, expIdx, action, ...) _HPAlert(msg, expIdx, action, @"" # __VA_ARGS__, __VA_ARGS__, nil)

#define HPAlertTitle(title, mess, expIdx, actionBlock, ...) _HPAlertTitle(title, mess, expIdx, actionBlock, @"" # __VA_ARGS__, __VA_ARGS__, nil)


UIKIT_EXTERN void occasionalHint(NSString *message);

#define hint(message) HPAlert(message, -1, nil, @"确定")

@interface HPAlertView (HP)

@end
