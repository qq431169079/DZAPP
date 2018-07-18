//
//  NSString+HPUtil.h
//  DZTakeout
//
//  Created by HuangPan on 2018/6/21.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HPUtil)
/**
 字符串 nil, @"", @"  ", @"\n" Returns NO;
 其他 Returns YES.
 */
- (BOOL)isNotBlank;

- (BOOL)isValid;

- (NSString *)removeWhiteSpacesFromString;

/**
 字符串size

 @param width 最大显示宽度
 @param font 字体
 @return size
 */
- (CGSize)sizeWithMaxWidth:(CGFloat)width font:(UIFont *)font;

/**
 *  将字符串通过空号分割成数组
 *
 *  @return 分割数组
 */
- (NSArray *)split;

/**
 *  将字符串通过指定的分割符分割成数组
 *
 *  @param delimiter 指定分隔符
 *
 *  @return 分割数组
 */
- (NSArray *)split:(NSString *)delimiter;

/**
 *  蛇形表示－>驼峰表示
 *
 *  @return 驼峰串
 */
- (NSString *)camelCase;

/**
 *  是否包含子串
 *
 *  @param string 判定字符串
 *
 *  @return 是否包含
 */
- (BOOL)containsString:(NSString *)string;

/**
 *  过滤掉所有空格和换行符
 *
 *  @return 过滤字符串
 */
- (NSString *)strip;

/**
 *  返回MD5码
 *
 *  @return MD5码
 */
- (NSString *)md5;

/**
 *  是否为空
 *
 *  @return 是否为空或者全由空格换行符组成
 */
- (BOOL)isBlank;

/**
 *  匹配字符中的AppId
 */
- (NSString *)matchExternalAppId;

/**
 *  正则匹配字符串
 *
 *  @param pattern 正则表达式
 *
 *  @return 匹配好的字符串
 */
- (NSString *)matchWithPattern:(NSString *)pattern;

/**
 *  是否是打开外部应用的链接
 */
- (BOOL)isOpenExternalAppRequire;

/**
 *  使用replacement替换target，不存在target则拼接在最后
 */
- (NSString *)replacingString:(NSString *)target with:(NSString *)replacment;

- (NSString *)stringValue;
- (NSUInteger)countNumberOfWords;
- (BOOL)isBeginsWith:(NSString *)string;
- (BOOL)isEndssWith:(NSString *)string;

- (NSString*)getSubstringFrom:(NSInteger)begin to:(NSInteger)end;
- (NSString *)addString:(NSString *)string;
- (NSString *)removeSubString:(NSString *)subString;

- (BOOL)containsOnlyLetters;
- (BOOL)containsOnlyNumbers;
- (BOOL)containsOnlyNumbersAndLetters;
- (BOOL)isInThisArray:(NSArray*)array;

+ (NSString *)getStringFromArray:(NSArray *)array;
- (NSArray *)getArray;

+ (NSString *)getMyApplicationVersion;
+ (NSString *)getMyApplicationName;

- (NSData *)convertToData;
+ (NSString *)getStringFromData:(NSData *)data;

- (BOOL)isValidEmail;
- (BOOL)isValidPhoneNumber;
- (BOOL)isValidUrl;
@end

UIKIT_EXTERN CGFloat HPTextWidth(NSString * text, UIFont * font);


/**
 *  快速构造字符串对象方法
 *
 *  @param format 格式
 *  @param ...    拼接
 *
 *  @return 字符串对象
 */
NSString *NSStringWithFormat(NSString * format, ...) NS_FORMAT_FUNCTION(1,2);
