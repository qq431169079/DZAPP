//
//  HPKeyboardRecord.h
//  MyPractice
//
//  Created by huangpan on 16/7/15.
//  Copyright © 2016年 huangpan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern CGFloat const kDefaultMarginWithKeyboard;

extern NSString *const kHPkeyboardChangedStatusNotification;

@interface HPKeyboardRecord : NSObject
/**
 *  键盘是否可见
 */
@property (nonatomic, assign, readonly, getter=isKeyboardVisiable) BOOL keyboardVisiable;
/**
 *  键盘大小
 */
@property (nonatomic, assign, readonly) CGRect keyboardRect;

/**
 键盘状态改变
 */
@property (nonatomic, copy) void(^keyboardChangedStatus)(BOOL, CGRect);

/**
 单例
 */
+ (instancetype)shareInstance;

/**
 开始通知模式(设置keyboardChangedStatusBlock则自动开始)
 */
+ (void)enableNofitication;
@end
