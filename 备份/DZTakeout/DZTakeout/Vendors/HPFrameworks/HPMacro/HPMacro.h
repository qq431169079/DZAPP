
//
//  HPMacro.h
//  DZTakeout
//
//  Created by HuangPan on 2018/3/26.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#ifndef HPMacro_h
#define HPMacro_h

#endif /* HPMacro_h */

// ========== 通用参数 ==========
#define kDZBMKAK @"eCLCgTxFpvSDaroR8OGcGO9X4Iq0V4qd"

#define kDZSearchWordHistory    @"SearchWordHistory"
#define kCateIdCacheKey @"kCateIdCacheKey"
// ========== 通知 ==========
//自动登录
#define kDZAutoLogin    @"kDZAutoLogin"
// ========== 多语言相关 ==========
#define HPLocalizedString(key, comment) \
            ([[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"zh-Hans" ofType:@"lproj"]] localizedStringForKey:key value:@"" table:nil])
#define L(key) HPLocalizedString(key, nil)

// ========== 设备相关 ==========
#define SCREEN_WIDTH    ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT   ([[UIScreen mainScreen] bounds].size.height)
#define FRAME_SCALE_FIT (MIN(SCREEN_WIDTH, SCREEN_HEIGHT) / 375.0)

// ========== 适配相关 ==========
#define isIPhoneX (SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 812.f)
#define ASPECT_STATUS_BAR_H     (isIPhoneX ? 44.0f : 20.0f)
#define ASPECT_NAV_HEIGHT       (isIPhoneX ? 88.0f : 64.0f)
#define ASPECT_HOME_INDICATOR_H (isIPhoneX ? 34.0f : 0.0f)

// ========== 颜色配置 ==========
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define COLOR_HEX(rgbValue)              [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define COLOR_HEX_ALPHA(rgbValue, a)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

// ========== 调试输出 ==========
#ifdef DEBUG
    #define HPLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
    #define HPLog(...)
#endif


// ========== 处理循环引用相关 ==========
#define DZStrongSelf(o) __strong typeof(o) strongSelf = weakSelf;
#define DZWeakSelf(o) __weak typeof(o) weakSelf = o;
#ifndef weakify

#if __has_feature(objc_arc)
#define weakify( x ) \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Wshadow\"") \
    autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \
    _Pragma("clang diagnostic pop")

#else

    #define weakify( x ) \
        _Pragma("clang diagnostic push") \
        _Pragma("clang diagnostic ignored \"-Wshadow\"") \
        autoreleasepool{} __block __typeof__(x) __block_##x##__ = x; \
        _Pragma("clang diagnostic pop")

    #endif
#endif


#ifndef strongify

#if __has_feature(objc_arc)
#define strongify( x ) \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Wshadow\"") \
    try{} @finally{} __typeof__(x) x = __weak_##x##__; \
    _Pragma("clang diagnostic pop")

#else

    #define strongify( x ) \
        _Pragma("clang diagnostic push") \
        _Pragma("clang diagnostic ignored \"-Wshadow\"") \
        try{} @finally{} __typeof__(x) x = __block_##x##__; \
        _Pragma("clang diagnostic pop")
    #endif
#endif

// ========== 主队列执行 ==========
#define _hy_dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);}
