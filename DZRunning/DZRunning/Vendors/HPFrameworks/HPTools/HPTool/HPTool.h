//
//  HPTool.h
//  MyPractice
//
//  Created by huangpan on 16/7/8.
//  Copyright © 2016年 huangpan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HPCheckType) {
    HPCheckTypeUserName,      // 校验用户名（中文，2 - 13个字长）
    HPCheckTypePhoneNumber,   // 校验电话号码
    HPCheckTypeAlipayAccount, // 校验支付宝
    HPCheckTypeQQAccount,     // QQ账号
    HPCheckTypeTenPayAccount, // 财富通账号
    HPCheckTypeEmailAccount,  // 邮箱账号
    HPCheckTypeNoCheck,       // 不做检测
};

@interface HPTool : NSObject
/**
 *  计算文字的长度
 */
CGFloat HPCalculateTextWidth(NSString *text, UIFont *font);
/**
 *  计算文字的size
 *
 *  @param maxLayoutWidth 最大显示宽度
 *  @param font           字体大小
 *
 *  @return 字符串size
 */
CGSize  HPCalculateTextSize(NSString *text, CGFloat maxLayoutWidth, UIFont *font);

/**
 校验value的正确性

 @param value 待校验的值
 @param type  类型
 */
BOOL HPCheckValue(NSString *value, HPCheckType type);

/**
 *  时间戳转时间字符串
 *  @param formatter 格式化字符串（如果传nil，默认：yyyy-MM-dd HH:MM:ss）
 *  @return 根据1970至今的秒数转成指定的字符串
 */
NSString *HPConvertTimeToString(NSTimeInterval timeInterval, NSString*formatter);

/**
 获得当前app的版本号

 @return 当前版本号
 */
NSString *HPGetAppVersionInBundle(void);

/**
 获得当前app的BundelID
 
 @return 当前BundelID
 */
NSString *HPGetBundelIDInBundle(void);

/**
 获得当前app的displayName
 
 @return 当前displayName
 */
NSString *HPGetDisplayNameInBundle(void);

/**
 获得当前app的icon
 
 @return 当前appicon
 */
UIImage *HPGetAppIconInBundle(void);
@end
